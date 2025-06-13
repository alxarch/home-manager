{ pkgs, ... }:
{
  programs.ssh.enable = true;
  programs.ssh.package = pkgs.openssh_gssapi;
  programs.ssh.extraConfig = ''
    Host geant-dev
      HostName 13.49.67.240
      User ec2-user
      IdentityFile ~/.ssh/id_ed25519
  '';
  services.ssh-agent.enable = true;
}
