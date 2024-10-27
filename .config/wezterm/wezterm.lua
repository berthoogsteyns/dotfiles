-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- appearance

config.enable_tab_bar = false

-- color_scheme

config.color_scheme = "Gruvbox dark, soft (base16)"

-- font configuration

config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")

config.window_close_confirmation = "NeverPrompt"

-- and finally, return the configuration to wezterm
return config
