---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local asset_theme = scheme.dark_mode and "default-dark" or "default"
	local asset_root = "/usr/share/fcitx5/themes/" .. asset_theme

	local template = [[
[Metadata]
Name=Auto Gen
Version=1
Author=ToaaM
Description=Auto generated theme
ScaleWithDPI=True

[InputPanel]
NormalColor=%s
HighlightCandidateColor=%s
HighlightColor=%s
HighlightBackgroundColor=%s
PageButtonAlignment=Last Candidate

[InputPanel/TextMargin]
Left=5
Right=5
Top=5
Bottom=5

[InputPanel/ContentMargin]
Left=2
Right=2
Top=2
Bottom=2

[InputPanel/Background]
Color=%s
BorderColor=%s
BorderWidth=2

[InputPanel/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[InputPanel/Highlight]
Color=%s

[InputPanel/Highlight/Margin]
Left=5
Right=5
Top=5
Bottom=5

[InputPanel/PrevPage]
Image=%s/prev.png

[InputPanel/PrevPage/ClickMargin]
Left=5
Right=5
Top=4
Bottom=4

[InputPanel/NextPage]
Image=%s/next.png

[InputPanel/NextPage/ClickMargin]
Left=5
Right=5
Top=4
Bottom=4

[Menu]
NormalColor=%s
HighlightCandidateColor=%s

[Menu/Background]
Color=%s
BorderColor=%s
BorderWidth=2

[Menu/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[Menu/ContentMargin]
Left=2
Right=2
Top=2
Bottom=2

[Menu/CheckBox]
Image=%s/radio.png

[Menu/SubMenu]
Image=%s/arrow.png

[Menu/Highlight]
Color=%s

[Menu/Highlight/Margin]
Left=5
Right=5
Top=5
Bottom=5

[Menu/Separator]
Color=%s

[Menu/TextMargin]
Left=5
Right=5
Top=5
Bottom=5

[AccentColorField]
0=Input Panel Border
1=Input Panel Highlight Candidate Background
2=Input Panel Highlight
3=Menu Border
4=Menu Separator
5=Menu Selected Item Background
]]

	local content = template:format(
		scheme.fg.common, -- NormalColor
		scheme.accents[1], -- HighlightCandidateColor
		scheme.accents[1], -- HighlightColor
		scheme.brand,     -- HighlightBackgroundColor
		scheme.bg.common, -- [InputPanel/Background] Color
		scheme.bg.border, -- BorderColor
		scheme.bg.active, -- [InputPanel/Highlight] Color
		asset_root,     -- [InputPanel/PrevPage] Image
		asset_root,     -- [InputPanel/NextPage] Image
		scheme.fg.common, -- [Menu] NormalColor
		scheme.accents[1], -- [Menu] HighlightCandidateColor
		scheme.bg.common, -- [Menu/Background] Color
		scheme.bg.border, -- [Menu/Background] BorderColor
		asset_root,     -- [Menu/CheckBox] Image
		asset_root,     -- [Menu/SubMenu] Image
		scheme.bg.active, -- [Menu/Highlight] Color
		scheme.bg.border -- [Menu/Separator] Color
	)

	return content
end
