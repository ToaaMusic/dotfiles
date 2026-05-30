-- Monitors
local monitors = hl.get_monitors()

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

for _, mon in ipairs(monitors) do
	if mon.name == "eDP-1" then
		hl.monitor({
			output = mon.name,
			mode = "preferred",
			position = "0x0",
			scale = 1.0,
		})
	elseif mon.name:find("HDMI") then
		hl.monitor({
			output = mon.name,
			mode = "highrr",
			position = "0x0",
			scale = 1.0,
			mirror = "eDP-1",
		})
	end
end
