name = "Lantern glitch"

description = "Brings back the lantern glitch."
author = "MrOroshiX"
version = "1.0.0"
forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
hamlet_compatible = true
shipwrecked_compatible = true
server_filter_tags = {"lantern bug","lantern","infinite lantern"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "isLit",
		label = "lanterns on/off",
        hover = "Change whether you want to keep bugged lanterns on or off.",
		options =
	{
		{description = "On", data = "InfiniteLanternOn", hover = ""},
		{description = "Off", data = "InfiniteLanternOff", hover = ""},
	},
		default = "Off",
	}
}