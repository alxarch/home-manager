{ pkgs, ... }:
{
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard mapper service";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${ ./kanata.kbd }";
      Restart = "no";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
