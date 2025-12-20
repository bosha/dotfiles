local wezterm = require("wezterm")

-- local LIGHT_THEME_NAME = "Tokyo Night Day"
-- local DARK_THEME_NAME = "Tokyo Night"
-- local LIGHT_THEME_NAME = "Gruvbox light, soft (base16)"
-- local LIGHT_THEME_NAME = "Classic Light (base16)"
-- local LIGHT_THEME_NAME = "CLRS"
-- local LIGHT_THEME_NAME = "Cupertino (base16)"
-- local DARK_THEME_NAME = "Tokyo Night"
-- local DARK_THEME_NAME = "Gruvbox Dark (Gogh)"

local DARK_THEME_NAME = "Vs Code Dark+ (Gogh)"
local LIGHT_THEME_NAME = "Vs Code Light+ (Gogh)"

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return DARK_THEME_NAME
	end
	return LIGHT_THEME_NAME
end

-- local CURRENT_THEME = nil

wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == LIGHT_THEME_NAME then
		overrides.color_scheme = DARK_THEME_NAME
	else
		overrides.color_scheme = LIGHT_THEME_NAME
	end
	window:set_config_overrides(overrides)
end)

-- Apply the right scheme whenever a window is created or config/appearance changes
local function apply_appearance(window)
	local overrides = window:get_config_overrides() or {}
	overrides.color_scheme = scheme_for_appearance(window:get_appearance())
	window:set_config_overrides(overrides)
end

wezterm.on("window-config-reloaded", function(window, _)
	apply_appearance(window)
end)

wezterm.on("window-created", function(window, _)
	apply_appearance(window)
end)

return {

	initial_cols = 150,
	initial_rows = 40,

	-- Font settings
	font = wezterm.font_with_fallback({
		"Monaco Nerd Font", -- Preferred font
		"Fira Code", -- Preferred font
		"Hack", -- Fallback font
	}),
	font_size = 13.0,
	line_height = 1.2,

	-- Enable ligatures if font supports them
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" },

	-- Color scheme
	-- color_scheme = "Tokyo Night",
	-- color_scheme = scheme_for_appearance(get_appearance()),
	window_background_opacity = 0.95,
	window_close_confirmation = "NeverPrompt",
	-- window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	-- window_padding = {
	-- 	top = "1.5cell",
	-- },

	-- Tab bar appearance
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,

	-- Keybindings
	keys = {
		-- New tab
		{ key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },

		-- Close tab
		-- { key = "w", mods = "CMD",       action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "w", mods = "CMD", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

		-- Navigate between tabs
		{ key = "[", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "]", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },

		-- Splits (horizontal and vertical)
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "D",
			mods = "CMD|SHIFT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},

		-- Navigate between panes
		{ key = "h", mods = "CMD|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "l", mods = "CMD|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "k", mods = "CMD|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "j", mods = "CMD|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },

		{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-colorscheme") },

		-- -- Resize panes
		-- { key = "=", mods = "CMD|SHIFT", action = "IncreaseFontSize" },
		-- { key = "-", mods = "CMD|SHIFT", action = "DecreaseFontSize" },
	},

	-- Mouse support
	enable_scroll_bar = true,
	-- enable_mouse = true,

	-- Image and graphics support (Kitty protocol)
	enable_kitty_graphics = true,
	-- enable_hyperlink = true,

	use_dead_keys = false,

	-- -- Use left Option (⌥) as Meta
	send_composed_key_when_left_alt_is_pressed = false,
	-- send_alt_gr_when_left_alt_is_pressed = false,
	--
	-- -- Use right Option (⌥) as Meta too (optional)
	send_composed_key_when_right_alt_is_pressed = false,
	-- send_alt_gr_when_right_alt_is_pressed = false,
}
