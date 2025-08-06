{
  hostname,
  ...
}:
{
  networking = {
    hostName = hostname;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    # systemd.services.nix-daemon = {
    #   after = [
    #     "network-online.target"
    #     "nss-lookup.target"
    #   ];
    #   wants = [
    #     "network-online.target"
    #   ];
    # };
  };
}
