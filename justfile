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

[group('system')]
_validate-hostname hostname:
    #!/usr/bin/env bash
    set -euo pipefail
    hostname={{ quote(hostname) }}
    case "$hostname" in
        woglinde|rhein) ;;
        *)
            echo "error: unknown hostname '$hostname'" >&2
            exit 1
            ;;
    esac

[group('system')]
_validate-ip ip:
    #!/usr/bin/env bash
    set -euo pipefail
    ip={{ quote(ip) }}

    octet='(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])'
    ipv4_re="^${octet}\.${octet}\.${octet}\.${octet}\$"

    label='[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    hostname_re="^${label}(\.${label})*\$"

    if [[ "$ip" =~ $ipv4_re ]]; then
        exit 0
    fi

    if [[ "$ip" =~ ^[0-9.]+$ ]]; then
        echo "error: invalid IPv4 address '$ip'" >&2
        exit 1
    fi

    if [[ "$ip" =~ $hostname_re ]]; then
        exit 0
    fi

    echo "error: invalid IPv4 address or hostname '$ip'" >&2
    exit 1

# Partition and format the target host's disk via nixos-anywhere
[confirm("This will WIPE the disk at {{ip}}. Continue?")]
[group('system')]
bootstrap-disko hostname ip: (_validate-hostname hostname) (_validate-ip ip)
    #!/usr/bin/env bash
    set -euo pipefail
    hostname={{ quote(hostname) }}
    ip={{ quote(ip) }}

    declare -a extra_args=()

    case "$hostname" in
        rhein)
            extra_args+=(--build-on remote)
            ;;
    esac

    nixos-anywhere \
        -i ~/.ssh/id_ed25519 \
        --ssh-option "StrictHostKeyChecking=accept-new" \
        --phases disko \
        --generate-hardware-config nixos-generate-config "./hosts/$hostname/hardware.nix" \
        "${extra_args[@]}" \
        --flake ".#$hostname" "root@$ip"

    echo "==> disko phase done."
    echo "==> Verify manually, e.g.:"
    echo "      ssh root@$ip lsblk"
    echo "      ssh root@$ip findmnt"
    echo "==> Then run: just bootstrap-install $hostname $ip"

# Install NixOS on the target host and reboot it via nixos-anywhere
[confirm("This will install NixOS on {{ip}} and reboot it. Continue?")]
[group('system')]
bootstrap-install hostname ip: (_validate-hostname hostname) (_validate-ip ip)
    #!/usr/bin/env bash
    set -euo pipefail
    hostname={{ quote(hostname) }}
    ip={{ quote(ip) }}

    checkpoint() {
        if [ "${SKIP:-0}" = "0" ]; then
            echo -e "\n\e[33m[DEBUG] Next: $1\e[0m"
            read -p "Press [Enter] to continue..."
        fi
    }

    temp=$(mktemp -d)
    agent_pid=""

    cleanup() {
        trap - ERR EXIT
        rm -rf -- "$temp"
        if [ -n "$agent_pid" ]; then
            kill "$agent_pid" 2>/dev/null || true
        fi
    }

    trap cleanup ERR EXIT
    trap 'trap - ERR EXIT; cleanup; exit 130' INT
    trap 'trap - ERR EXIT; cleanup; exit 143' TERM
    trap 'trap - ERR EXIT; cleanup; exit 129' HUP

    umask 077

    install -d -m 755 "$temp/etc/ssh"
    install -d -m 700 "$temp/root/.ssh"

    nixos_secrets_path=$(nix eval --raw .#inputs.nixos-secrets.outPath)

    checkpoint "decrypt host ssh key via sops"
    sops --decrypt \
        --extract '["hosts"]["'"$hostname"'"]["ssh_host_ed25519_key"]' \
        "${nixos_secrets_path}/hosts.yaml" > "$temp/etc/ssh/ssh_host_ed25519_key"

    chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

    if ! github_pubkey=$(
        nix eval --raw \
        ".#nixosConfigurations.$hostname.config.programs.ssh.knownHosts.github.publicKey"
    ); then
        echo "error: failed to evaluate github public key" >&2
        exit 1
    fi

    if [ -n "$github_pubkey" ]; then
        printf 'github.com %s\n' "$github_pubkey" > "$temp/root/.ssh/known_hosts"
        chmod 600 "$temp/root/.ssh/known_hosts"
    else
        echo "error: github public key is empty for nixosConfigurations.$hostname" >&2
        exit 1
    fi

    need_agent=false
    if [ -z "${SSH_AUTH_SOCK:-}" ]; then
        need_agent=true
    else
        if ssh-add -l >/dev/null 2>&1; then
            rc=0
        else
            rc=$?
        fi
        [ "$rc" -eq 2 ] && need_agent=true
    fi
    if $need_agent; then
        eval "$(ssh-agent -s)" >/dev/null
        agent_pid="$SSH_AGENT_PID"
    fi

    ssh-add -t 15m ~/.ssh/id_ed25519

    declare -a extra_args=()

    case "$hostname" in
        rhein)
            ssh-add -t 15m ~/.ssh/id_ed25519_github

            checkpoint "run 'nix profile add nixpkgs#git' on root@$ip"
            echo "==> aarch64 host: installing git on kexec target for remote build..."
            ssh \
                -i ~/.ssh/id_ed25519 \
                -o StrictHostKeyChecking=accept-new \
                -o IdentitiesOnly=yes \
                "root@$ip" \
                "nix profile add nixpkgs#git"

            extra_args+=(
                --ssh-option "ForwardAgent=yes"
                --build-on remote
            )
            ;;
        woglinde)
            ;;
    esac

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
