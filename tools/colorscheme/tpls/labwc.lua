-- Only generates color items, other items (width, padding, geometry, ...) should be kept in themerc-override.

---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local template = [[
window.active.border.color: %s
window.inactive.border.color: %s
window.active.indicator.toggled-keybind.color: %s

window.active.label.text.color: %s
window.inactive.label.text.color: %s

window.active.title.bg.color: %s
window.inactive.title.bg.color: %s

window.active.button.unpressed.image.color: %s
window.inactive.button.unpressed.image.color: %s

window.button.hover.bg.color: %s

window.active.shadow.color: %s
window.inactive.shadow.color: %s

menu.border.color: %s
menu.items.bg.color: %s
menu.items.text.color: %s
menu.items.active.bg.color: %s
menu.items.active.text.color: %s
menu.separator.color: %s
menu.title.bg.color: %s
menu.title.text.color: %s

osd.bg.color: %s
osd.border.color: %s
osd.label.text.color: %s
osd.window-switcher.style-classic.item.active.border.color: %s
osd.window-switcher.style-classic.item.active.bg.color: %s
osd.window-switcher.style-thumbnail.item.active.border.color: %s
osd.window-switcher.style-thumbnail.item.active.bg.color: %s
osd.window-switcher.preview.border.color: %s

snapping.overlay.region.bg.color: %s
snapping.overlay.edge.bg.color: %s
snapping.overlay.region.border.color: %s
snapping.overlay.edge.border.color: %s

magnifier.border.color: %s
]]

	local content = template:format(
		scheme.bg.border,                                                         -- window.active.border.color
		scheme.bg.border,                                                         -- window.inactive.border.color
		scheme.role.error,                                                        -- window.active.indicator.toggled-keybind.color

		scheme.fg.common,                                                         -- window.active.label.text.color
		scheme.fg.muted,                                                          -- window.inactive.label.text.color

		scheme.bg.elevated,                                                       -- window.active.title.bg.color
		scheme.bg.elevated,                                                       -- window.inactive.title.bg.color

		scheme.fg.common,                                                         -- window.active.button.unpressed.image.color
		scheme.fg.muted,                                                          -- window.inactive.button.unpressed.image.color

		scheme.bg.active .. "40",                                                 -- window.button.hover.bg.color

		scheme.bg.shadow .. "60",                                                 -- window.active.shadow.color
		scheme.bg.shadow .. "40",                                                 -- window.inactive.shadow.color

		scheme.bg.border,                                                         -- menu.border.color
		scheme.bg.elevated,                                                       -- menu.items.bg.color
		scheme.fg.common,                                                         -- menu.items.text.color
		scheme.bg.active,                                                         -- menu.items.active.bg.color
		scheme.fg.hover,                                                          -- menu.items.active.text.color
		scheme.bg.border,                                                         -- menu.separator.color
		scheme.bg.elevated,                                                       -- menu.title.bg.color
		scheme.fg.common,                                                         -- menu.title.text.color

		scheme.bg.elevated,                                                       -- osd.bg.color
		scheme.bg.border,                                                         -- osd.border.color
		scheme.fg.common,                                                         -- osd.label.text.color
		scheme.brand,                                                             -- osd.window-switcher.style-classic.item.active.border.color
		scheme.bg.active,                                                         -- osd.window-switcher.style-classic.item.active.bg.color
		scheme.brand,                                                             -- osd.window-switcher.style-thumbnail.item.active.border.color
		scheme.bg.active,                                                         -- osd.window-switcher.style-thumbnail.item.active.bg.color
		scheme.bg.elevated .. "," .. scheme.fg.common .. "," .. scheme.bg.elevated, -- osd.window-switcher.preview.border.color

		scheme.brand .. "80",                                                     -- snapping.overlay.region.bg.color
		scheme.brand .. "80",                                                     -- snapping.overlay.edge.bg.color
		scheme.brand,                                                             -- snapping.overlay.region.border.color
		scheme.brand,                                                             -- snapping.overlay.edge.border.color

		scheme.role.error                                                         -- magnifier.border.color
	)

	return content
end
