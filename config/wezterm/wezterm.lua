-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.default_prog = { "/opt/homebrew/bin/fish" }
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "SystemBeep"
-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font("Source Code Pro")
config.font_size = 14
config.color_scheme = "tokyonight_moon"
-- Finally, return the configuration to wezterm:
return config
