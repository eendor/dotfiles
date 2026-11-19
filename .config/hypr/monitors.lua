-- Hyprland Monitor Configuration
-- Automatically generated & maintained by Hyprland Monitor Settings

local function is_drm_connected(name)
  local f = io.open('/sys/class/drm/card1-' .. name .. '/status', 'r')
  if not f then
    local p = io.popen('cat /sys/class/drm/*-' .. name .. '/status 2>/dev/null')
    if p then
      local out = p:read('*a')
      p:close()
      return out:find('connected') ~= nil and out:find('disconnected') == nil
    end
    return false
  end
  local status = f:read('*l') or ''
  f:close()
  return status:find('connected') ~= nil and status:find('disconnected') == nil
end

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120", position = "1920x0", scale = 1.0 })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.0 })

-- Fallback rule
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
