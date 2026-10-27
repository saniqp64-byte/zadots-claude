-- Райс macOS: тонкие рамки, большие мягкие тени, стеклянное размытие,
-- плавные анимации без перелёта

hl.env("XCURSOR_THEME",    "macOS")
hl.env("HYPRCURSOR_THEME", "macOS")

hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 10,
        border_size = 1,
        col = {
            active_border   = "rgba(ffffff30)",
            inactive_border = "rgba(ffffff12)",
        },
    },

    decoration = {
        rounding         = 12,
        rounding_power   = 2,
        inactive_opacity = 1.0,
        shadow = {
            enabled        = true,
            range          = 40,
            render_power   = 4,
            offset         = "0 10",
            color          = "rgba(00000077)",
            color_inactive = "rgba(00000044)",
        },
        blur = {
            enabled    = true,
            size       = 12,
            passes     = 4,
            noise      = 0.01,
            brightness = 0.9,
            vibrancy   = 0.25,
            popups     = true,
        },
    },
})

-- Плавные кривые как в macOS: быстрый старт, мягкая остановка
hl.curve("mac",          { type = "bezier", points = { {0.25, 1}, {0.5, 1}  } })
hl.curve("macOut",       { type = "bezier", points = { {0.4, 0},  {1, 1}    } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("smooth",       { type = "spring", mass = 1, stiffness = 230, dampening = 30 })

hl.animation({ leaf = "global",        enabled = true, speed = 6,   bezier = "mac" })
hl.animation({ leaf = "border",        enabled = true, speed = 4,   bezier = "mac" })

hl.animation({ leaf = "windows",       enabled = true, speed = 4,   spring = "smooth" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 3.5, bezier = "mac",    style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2.5, bezier = "macOut", style = "popin 90%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 4,   spring = "smooth" })

hl.animation({ leaf = "fadeIn",        enabled = true, speed = 3,   bezier = "mac" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 2.5, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3,   bezier = "mac" })

hl.animation({ leaf = "layers",        enabled = true, speed = 4,   bezier = "mac" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3.5, bezier = "mac",    style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2.5, bezier = "macOut", style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 3,   bezier = "mac" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.5, bezier = "almostLinear" })

-- Рабочие столы листаются вбок, как Spaces
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4, spring = "smooth", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "mac",    style = "slidefadevert 15%" })
hl.animation({ leaf = "zoomFactor",       enabled = true, speed = 6, bezier = "mac" })

-- Стекло под строкой меню, доком и Spotlight
hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ name = "blur-rofi",   match = { namespace = "^rofi$" },   blur = true, ignore_alpha = 0.1 })

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
