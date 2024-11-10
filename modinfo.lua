name = "Scrollable Chat"
author = "gibberish"
description = "Increase chat log history and make chat text scrollable."
version = "1.0"
api_version = 10

dst_compatible = false
forge_compatible = false
gorge_compatible = false
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
rotwood_compatible = true

client_only_mod = true
all_clients_require_mod = false

icon_atlas = "modicon.png"
icon = "modicon.png"

configuration_options = {
    {
		name = "max_lines_shown",
		label = "Chat Height",
		hover = "How many lines of chat text should be shown at most.",
		options =	
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
            {description = "10", data = 10},
            {description = "11", data = 11},
            {description = "12", data = 12},
		},
		default = 10,
	},
    {
		name = "max_chat_history",
		label = "Chat History Length",
		hover = "How many messages should be kept in history.",
		options =	
		{
			{description = "8", data = 8},
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
			{description = "40", data = 40},
            {description = "50", data = 50},
            {description = "60", data = 60},
            {description = "70", data = 70},
            {description = "80", data = 80},
            {description = "90", data = 90},
            {description = "100", data = 100},
		},
		default = 100,
	},
}
