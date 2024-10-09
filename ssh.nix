{ pkgs, ... }:
{
  programs.ssh.enable = true;
  programs.ssh.package = pkgs.openssh;
  programs.ssh.extraConfig = ''
    Host geant-dev
      HostName 13.49.67.240
      User ec2-user
      IdentityFile ~/.ssh/id_ed25519

    # Ansible managed
    # SSH client configuration snippet for eduTEAMS customer 'eosc_federation'.
    # Include this file's path at the very top of your ~/.ssh/config
    #

    # The jumphost, both by human readable name and by bare IP
    Host eosc_federation-jumphost 52.57.84.177
      Hostname 52.57.84.177
      Port 61351
      User admin
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      IdentityFile ~/.ssh/id_ed25519_wsl

    # All the other instances
    Host eosc_federation-prod-proxy1 eosc_federation-prod-proxy2 eosc_federation-prod-proxy3 eosc_federation-prod-mdx1 eosc_federation-prod-mdx2 eosc_federation-prod-mdx3 eosc_federation-prod-scimapi1 eosc_federation-prod-scimapi2 eosc_federation-prod-nagios1 eosc_federation-prod-container1 eosc_federation-staging-proxy1 eosc_federation-staging-proxy2 eosc_federation-staging-proxy3 eosc_federation-staging-mdx1 eosc_federation-staging-mdx2 eosc_federation-staging-mdx3 eosc_federation-staging-scimapi1 eosc_federation-staging-scimapi2 eosc_federation-staging-nagios1 eosc_federation-testing-proxy1 eosc_federation-testing-proxy2 eosc_federation-testing-mdx1 eosc_federation-testing-mdx2 eosc_federation-testing-scimapi1 eosc_federation-testing-scimapi2 eosc_federation-testing-nagios1
      Hostname %h.coreaai.internal
      User admin
      ProxyJump eosc_federation-jumphost
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      IdentityFile ~/.ssh/id_ed25519_wsl
      '';
      services.ssh-agent.enable = true;
}
