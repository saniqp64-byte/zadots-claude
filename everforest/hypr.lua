-- Райс Everforest: цвета, рамки, размытие, желейные анимации

local c = {
    bg3   = "475258",
    green = "a7c080",
    aqua  = "83c092",
}

hl.env("XCURSOR_THEME",    "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 12,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(" .. c.green .. "ff)", "rgba(" .. c.aqua .. "ff)" }, angle = 45 },
            inactive_border = "rgba(" .. c.bg3 .. "aa)",
        },
    },

    decoration = {
        rounding         = 12,
        rounding_power   = 2,
        inactive_opacity = 0.95,
        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = "rgba(1a1f22aa)",
        },
        blur = {
            enabled  = true,
            size     = 6,
            passes   = 3,
            noise    = 0.02,
            vibrancy = 0.17,
            popups   = true,
        },
    },
})

-- Кривые
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},   {0.32, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5},  {0.75, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},   {0.1, 1}  } })
hl.curve("overshot",     { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.08} } })

-- Желе: пружины с малым затуханием перелетают цель и пару раз качаются.
-- Меньше dampening → сильнее трясётся, больше stiffness → быстрее.
hl.curve("jelly",  { type = "spring", mass = 1, stiffness = 170, dampening = 13 })
hl.curve("wobbly", { type = "spring", mass = 1, stiffness = 140, dampening = 9 })
hl.curve("soft",   { type = "spring", mass = 1, stiffness = 200, dampening = 20 })

hl.animation({ leaf = "global",        enabled = true, speed = 8,   bezier = "easeOutQuint" })
hl.animation({ leaf = "border",        enabled = true, speed = 5,   bezier = "easeOutQuint" })

hl.animation({ leaf = "windows",       enabled = true, speed = 5,   spring = "jelly" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,   spring = "wobbly", style = "popin 70%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2,   bezier = "quick",  style = "popin 80%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 5,   spring = "jelly" })

hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 2,   bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3,   bezier = "quick" })

hl.animation({ leaf = "layers",        enabled = true, speed = 4,   spring = "soft" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,   spring = "wobbly", style = "slide" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2,   bezier = "quick",  style = "slide" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2,   bezier = "almostLinear" })

-- Панель слева → воркспейсы листаются вертикально
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4, spring = "soft",  style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, spring = "jelly", style = "slidefadevert 20%" })
hl.animation({ leaf = "zoomFactor",       enabled = true, speed = 6, bezier = "overshot" })

-- Размытие под панелью и меню
hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "blur-rofi",   match = { namespace = "^rofi$" },   blur = true, ignore_alpha = 0.2, animation = "slide top" })

hl.gesture({
    fingers   = 3,
    direction = "vertical",
    action    = "workspace",
})
