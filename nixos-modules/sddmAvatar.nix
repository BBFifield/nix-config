# Might have a usecase for this at some point

{ config, pkgs, ... }:

{
    environment.etc = {
      "scripts/sddm-avatar.sh" = {
        text = ''
          #!/run/current-system/sw/bin/bash
          for user in /home/*; do
            username=$(basename $user)
            if [ ! -f /etc/nixos/sddm/$username ]; then
              cp $user/.face.icon /var/lib/AccountsService/icons/$username
            else
              if [ $user/,face.icon -nt /var/lib/AccountsService/icons/$username ]; then
                cp -i $user/.face.icon /var/lib/AccountsService/icons/$username
              fi
            fi
          done
        '';
        mode = "0554";
      };
    };

    systemd.services.sddm-avatar = {
      description = "Script to update user avatar";
      wantedBy = [ "multi-user.target" ];
      before = [ "sddm.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "etc/scripts.sddm-avatar.sh";
        StandardOutput = "journal+console";
        StandardError = "journal + console";
      };
    };

    systemd.services.sddm = {
      after = [ "sddm-avatar.service" ];
    };
}
