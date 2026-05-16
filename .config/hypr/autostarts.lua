-------------------
---- AUTOSTART ----
-------------------

-- Utils

hl.on("hyprland.start", function () 
  hl.exec_cmd("quickshell & dunst & vicinae server & pypr & hypridle & hyprpaper & systemctl --user start hyprpolkitagent & hyprpm reload -n")
end)

-- apps

hl.on("hyprland.start", function () 
  hl.exec_cmd("vesktop -minimzed & steam -silent")
end)
