-- Monitor setup: load monitors.lua if available, otherwise default to auto
local monitors_conf = os.getenv("HOME") .. "/.config/hypr/monitors.lua"
local f_mon = io.open(monitors_conf, "r")
if f_mon then
  f_mon:close()
  dofile(monitors_conf)
else
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end
hl.env("XCURSOR_THEME", "Osage-Chan")
hl.env("XCURSOR_SIZE", "48")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.config({
  cursor = {
    enable_hyprcursor = false,
    no_hardware_cursors = false,
    min_refresh_rate = 74,
  },
  general = {
    gaps_in = 3, gaps_out = 5, border_size = 2, layout = "dwindle",
    resize_on_border = true,
    col = { active_border = "rgba(aaaaaaee)", inactive_border = "rgba(303030aa)" },
  },
  decoration = {
    rounding = 14, active_opacity = 1.0, inactive_opacity = 0.85,
    shadow = { enabled = false, range = 18, render_power = 3, color = 0x55000000 },
    blur = { enabled = true, size = 6, passes = 2, vibrancy = 0.20, noise = 0.0, popups = true },
  },
  animations = { enabled = true },
  input = {
    kb_layout = "us", follow_mouse = 1, accel_profile = "adaptive", sensitivity = 0.0,
    touchpad = { natural_scroll = true, tap_to_click = true, disable_while_typing = true },
  },
  misc = { disable_hyprland_logo = true, force_default_wallpaper = 0 },
})

-- Snappy, fluid animations (replaces 800ms sluggish defaults)
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 3.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.8, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.8, bezier = "quick", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "almostLinear" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.0, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.8, bezier = "quick", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "almostLinear", style = "slide" })

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal")
  hl.exec_cmd("swaybg -i $HOME/.local/share/wallpapers/osage-spot-late.png -m fill")
  hl.exec_cmd("$HOME/.local/bin/start-osage-desktop")
  hl.exec_cmd("hyprpm reload")
  hl.exec_cmd("mako")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme WhiteSur-OLED")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme Osage-Mono")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
end)
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("loginctl terminate-user $USER"))
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
for _, direction in ipairs({"left", "right", "up", "down"}) do
  hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = direction }))
end
for i = 1, 10 do
  hl.bind("SUPER + " .. (i % 10), hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Miku Launchpad and recoverable minimization.
hl.bind("SUPER + Space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("$HOME/.local/bin/miku-windows minimize"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("$HOME/.local/bin/miku-windows restore"))
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
-- Patched hyprbars: hover shows only that button's symbol (original: /var/cache/hyprpm/rodnee/hyprland-plugins/hyprbars.so)
hl.plugin.load(os.getenv("HOME") .. "/.local/lib/hyprland/hyprbars-solo-hover.so")

if hl.plugin and hl.plugin.hyprbars then
  hl.config({plugin = {hyprbars = {
   -- iOS / macOS style: dark frosted glass, traffic lights, centered title
   bar_height = 36, bar_color = "rgba(000000d6)", bar_blur = true,
   col = {text = "rgba(ffffffd9)"},
   bar_text_size = 12, bar_text_font = "SF Pro Display", bar_text_align = "center", bar_text_weight = "bold",
   bar_buttons_alignment = "left", bar_padding = 14, bar_button_padding = 9,
   bar_part_of_window = true, bar_precedence_over_border = true,
   icon_on_hover = true, inactive_button_color = "rgba(ffffff33)",
   on_double_click = "$HOME/.local/bin/titlebar-action maximize dblclick",
  }}})
  hl.plugin.hyprbars.add_button({bg_color="rgb(ff5f57)",fg_color="rgb(2e0000)",size=17,icon="✖",action="$HOME/.local/bin/titlebar-action close"})
  hl.plugin.hyprbars.add_button({bg_color="rgb(febc2e)",fg_color="rgb(5c3300)",size=17,icon="━",action="$HOME/.local/bin/titlebar-action minimize"})
  hl.plugin.hyprbars.add_button({bg_color="rgb(28c840)",fg_color="rgb(003d00)",size=17,icon="✚",action="$HOME/.local/bin/titlebar-action maximize"})
end

-- Window switcher (both Alt+Tab and Win+Tab).
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("$HOME/.local/bin/osage-switcher"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("$HOME/.local/bin/osage-switcher"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("$HOME/.local/bin/osage-screenshot"))
hl.bind("SUPER + bracketleft", hl.dsp.exec_cmd("$HOME/.local/bin/obs-toggle-record"))

hl.bind("SUPER + F", hl.dsp.window.fullscreen({mode="fullscreen",action="toggle"}))

hl.config({ecosystem={no_donation_nag=true,no_update_news=true}})

hl.bind("ALT + F4", hl.dsp.window.close())

hl.bind("SUPER + Super_L", hl.dsp.exec_cmd("$HOME/.local/bin/osage-apps"), {release=true})
hl.bind("SUPER + Super_R", hl.dsp.exec_cmd("$HOME/.local/bin/osage-apps"), {release=true})

hl.bind("F11", hl.dsp.window.fullscreen({mode="fullscreen",action="toggle"}))

-- Emoji picker (Windows + .)
hl.bind("SUPER + period", hl.dsp.exec_cmd("$HOME/.local/bin/osage-emoji"))

-- Monitor / Display Settings GUI
hl.bind("SUPER + P", hl.dsp.exec_cmd("hypr-monitors-gui"))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("wdisplays"))

hl.config({render={direct_scanout=1}})



-- Frosted glass behind Waybar (only where the bar draws, not the gaps)
hl.layer_rule({
  name = "waybar-glass",
  match = { namespace = "^waybar$" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
})

-- Frosted glass behind the Eww bar and its popups
hl.layer_rule({
  name = "eww-glass",
  match = { namespace = "^eww-(bar|popup)$" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
})

-- Frosted glass behind rofi
hl.layer_rule({
  name = "rofi-glass",
  match = { namespace = "^rofi$" },
  blur = true,
  ignore_alpha = 0.2,
})

-- Frosted glass behind desktop icon tiles (transparent areas stay unblurred)
hl.layer_rule({
  name = "desktop-icons-glass",
  match = { namespace = "^desktop-icons$" },
  blur = true,
  ignore_alpha = 0.4,
})

-- OLED look on the LCD: true blacks + contrast/saturation shader
hl.config({ decoration = { screen_shader = os.getenv("HOME") .. "/.config/hypr/shaders/oled.frag" } })
