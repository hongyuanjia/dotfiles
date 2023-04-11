local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local wallpaper_path = gfs.get_configuration_dir() .. "wallpapers"

local pallete = require("theme.pallete")

local theme = {}

theme.font          = "JetBrainsMono Nerd Font"
theme.icon_font     = "JetBrainsMono Nerd Font"

theme.bg_normal     = pallete.black
theme.bg_focus      = pallete.background2
theme.bg_urgent     = pallete.red
theme.bg_minimize   = pallete.background2
theme.bg_systray    = pallete.background

theme.module_bg     = pallete.background
theme.module_bg_focused = pallete.background2

theme.fg_normal     = pallete.foreground
theme.fg_focus      = pallete.foreground
theme.fg_urgent     = pallete.black
theme.fg_minimize   = pallete.black

theme.useless_gap   = dpi(4)
theme.gap_single_client = true
theme.border_width  = dpi(3)
theme.border_normal = pallete.black
theme.border_focus  = pallete.blue
theme.border_marked = pallete.brightgreen

theme.taglist_bg_empty    = theme.module_bg
theme.taglist_bg_occupied = theme.module_bg
theme.taglist_bg_urgent   = theme.module_bg
theme.taglist_bg_focus    = pallete.blue
theme.taglist_font        = theme.icon_font .. " 11"
theme.taglist_spacing     = dpi(2)
theme.taglist_fg_focus    = pallete.black
theme.taglist_fg_occupied = pallete.foreground
theme.taglist_fg_urgent   = pallete.brightred
theme.taglist_fg_empty    = pallete.brightblack
theme.taglist_shape       = gears.shape.rectangle

theme.tasklist_bg_normal = theme.module_bg
theme.tasklist_bg_focus  = pallete.blue
theme.tasklist_bg_urgent = theme.module_bg_focused
theme.tasklist_fg_urgent = pallete.brightred

theme.menu_font = theme.font .. " 9"
theme.menu_height = dpi(20)
theme.menu_width = dpi(100)
theme.menu_border_color = pallete.brightblack
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = pallete.black
theme.menu_bg_focus = pallete.blue
theme.menu_fg_normal = pallete.foreground
theme.menu_bg_normal = pallete.background

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = wallpaper_path .. "/snowmoutain.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
