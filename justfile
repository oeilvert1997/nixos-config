# Default action: list all available recipes
default:
    @just --list
# Hostname of the local machine executing this recipe
local_host := `hostname`

# Usage:
#   just diff
#   just diff target-host
# Show diff between the built configuration and the current system
[group('system')]
diff target_host=local_host:
    @echo "==> Building configuration for [{{ target_host }}] locally..."
    nom build .#nixosConfigurations.{{ target_host }}.config.system.build.toplevel --no-link
    @echo "==> Diffing against [{{ target_host }}]'s current system..."
    nix store diff-closures \
        "{{ if target_host == local_host { "/run/current-system" } else { "ssh://" + target_host } }}" \
        .#nixosConfigurations.{{ target_host }}.config.system.build.toplevel

# Usage:
#   just switch                         # Local build, local switch
#   just switch target-host             # Remote build, remote switch
#   just switch target-host build-host  # Build elsewhere, remote switch
# Build and activate a configuration
[group('system')]
switch target_host=local_host build_host=target_host:
    @echo "==> Switching [{{ target_host }}] to the new configuration..."
    {{ if target_host == local_host { "sudo nixos-rebuild switch --flake .#" + target_host } else if build_host == local_host { "nixos-rebuild switch --flake .#" + target_host + " --target-host " + target_host + " --elevate=sudo --ask-elevate-password" } else { "nixos-rebuild switch --flake .#" + target_host + " --target-host " + target_host + " --build-host " + build_host + " --elevate=sudo --ask-elevate-password" } }}

# Check flake across all systems
[group('system')]
check:
    nix flake check --all-systems

[group('bootstrap')]
_validate-hostname hostname:
    @nix eval --raw .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel.drvPath >/dev/null 2>&1 \
        || (echo "error: unknown hostname '{{ hostname }}' (not in nixosConfigurations)" >&2; exit 1)

[group('bootstrap')]
_validate-ip ip:
    @test -n  "{{ ip }}" || (echo "error: ip is empty" >&2; exit 1)

# Usage:
#   just authorize 192.168.1.1
# Register public key
[group('bootstrap')]
authorize ip: (_validate-ip ip)
    ssh-copy-id -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_ed25519.pub root@{{ ip }}

# dns-set
# dns-set-remote
# dns-reset
# dns-resset-remote

# Boot the target into the NixOS installer
[confirm("This will kexec {{ip}} into the NixOS installer. Continue?")]
[group('bootstrap')]
bootstrap-kexec hostname ip: (_validate-hostname hostname) (_validate-ip ip)
    nixos-anywhere \
        -i ~/.ssh/id_ed25519 \
        --ssh-option "StrictHostKeyChecking=accept-new" \
        --phases kexec \
        --flake ".#{{ hostname }}" root@{{ ip }}

# Partition and format the target host's disk via nixos-anywhere
[confirm("This will WIPE the disk at {{ip}}. Continue?")]
[group('bootstrap')]
bootstrap-disko hostname ip build_on=env_var_or_default("BUILD_ON", "remote"): (_validate-hostname hostname) (_validate-ip ip)
    #!/usr/bin/env bash
    set -euo pipefail
    hostname={{ quote(hostname) }}
    ip={{ quote(ip) }}
    build_on={{ quote(build_on) }}

    declare -a extra_args=()
    [ "$build_on" = "remote" ] && extra_args+=(--build-on remote)

    nixos-anywhere \
        -i ~/.ssh/id_ed25519 \
        --ssh-option "StrictHostKeyChecking=accept-new" \
        --phases disko \
        --generate-hardware-config nixos-facter "./hosts/$hostname/facter.json" \
        "${extra_args[@]}" \
        --flake ".#$hostname" "root@$ip"

    echo "==> disko phase done."
    echo "==> Verify manually, e.g.:"
    echo "      ssh root@$ip lsblk"
    echo "      ssh root@$ip findmnt"
    echo "==> Then run: just bootstrap-install $hostname $ip"

# Install NixOS on the target host and reboot it via nixos-anywhere
[confirm("This will install NixOS on {{ip}} and reboot it. Continue?")]
[group('bootstrap')]
bootstrap-install hostname ip build_on=env_var_or_default("BUILD_ON", "remote"): (_validate-hostname hostname) (_validate-ip ip)
    #!/usr/bin/env bash
    set -euo pipefail
    hostname={{ quote(hostname) }}
    ip={{ quote(ip) }}
    build_on={{ quote(build_on) }}

    checkpoint() {
        if [ "${SKIP:-0}" = "0" ]; then
            echo -e "\n\e[33m[DEBUG] Next: $1\e[0m"
            read -p "Press [Enter] to continue..."
        fi
    }

    temp=$(mktemp -d)
    trap 'rm -rf -- "$temp"' EXIT

    umask 077
    install -d -m 755 "$temp/persistent/etc/ssh"
    install -d -m 700 "$temp/root/.ssh"

    nixos_secrets_path=$(nix eval --raw .#inputs.nixos-secrets.outPath)

    checkpoint "decrypt host ssh key via sops"
    sops --decrypt \
        --extract '["hosts"]["'"$hostname"'"]["ssh_host_ed25519_key"]' \
        "${nixos_secrets_path}/hosts.yaml" > "$temp/persistent/etc/ssh/ssh_host_ed25519_key"
    chmod 600 "$temp/persistent/etc/ssh/ssh_host_ed25519_key"

    ssh-keygen -y -f "$temp/persistent/etc/ssh/ssh_host_ed25519_key" > "$temp/persistent/etc/ssh/ssh_host_ed25519_key.pub"
    chmod 644 "$temp/persistent/etc/ssh/ssh_host_ed25519_key.pub"

    github_publickey=$(nix eval --raw ".#nixosConfigurations.$hostname.config.programs.ssh.knownHosts.github.publicKey")
    printf 'github.com %s\n' "$github_publickey" > "$temp/root/.ssh/known_hosts"
    chmod 600 "$temp/root/.ssh/known_hosts"

    if [ -z "${SSH_AUTH_SOCK:-}" ]; then
        eval "$(ssh-agent -s)" >/dev/null
        trap 'kill "$SSH_AGENT_PID" 2>/dev/null; rm -rf -- "$temp"' EXIT
    fi

    if ! ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"; then
        ssh-add -t 15m ~/.ssh/id_ed25519
    fi

    declare -a extra_args=()

    if [ "$build_on" = "remote" ]; then
        if ! ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519_github.pub | awk '{print $2}')"; then
            ssh-add -t 15m ~/.ssh/id_ed25519_github
        fi

        checkpoint "run 'nix profile add nixpkgs#git' on root@$ip"

        ssh \
            -i ~/.ssh/id_ed25519 \
            -o StrictHostKeyChecking=accept-new \
            "root@$ip" \
            "nix --extra-experimental-features 'nix-command flakes' profile add nixpkgs#git"

        extra_args+=(
            --ssh-option "ForwardAgent=yes"
            --build-on remote
        )
    fi

    checkpoint "run nixos-anywhere --phases install,reboot on root@$ip"
    nixos-anywhere \
        -i ~/.ssh/id_ed25519 \
        --ssh-option "StrictHostKeyChecking=accept-new" \
        --phases install,reboot \
        --extra-files "$temp" \
        "${extra_args[@]}" \
        --flake ".#$hostname" "root@$ip"

    echo "==> Done. Verify with: ssh $hostname systemctl --failed"

# Update flake inputs
[group('maintenance')]
update:
    nix flake update

# Show system generation history
[group('maintenance')]
history:
    sudo nixos-rebuild list-generations

# Lint nix files (deadnix + statix)
[group('formatting')]
lint:
    @echo "Running deadnix..."
    -deadnix
    @echo "Running statix..."
    -statix check
    # statix check -i "hosts/*/hardware.nix"

# Format all files via treefmt
[group('formatting')]
fmt:
    nix fmt

# Pack a directory into markdown and copy to clipboard
[group('tools')]
mix repo="." patterns="":
    #!/usr/bin/env bash
    set -euo pipefail

    flags=(
        --style xml
        --no-file-summary
        --no-gitignore
        -o -
    )

    if [ "{{ repo }}" != "." ]; then
        flags+=(--remote {{ quote(repo) }})
    fi

    if [ -n "{{ patterns }}" ]; then
        flags+=(--include {{ quote(patterns) }})
    fi

    repomix "${flags[@]}" | wl-copy
