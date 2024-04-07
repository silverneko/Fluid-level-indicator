require("__Ultracube__/prototypes/lib/tech_costs")

data:extend({
    {
        type = "technology",
        name = "cube-fluid-level-indicator",
        icon_size = 256,
        icon = "__Fluid-level-indicator__/graphics/icons/tech_icon_blackscreenbck.png",
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "cube-fluid-level-indicator"
          },
          {
            type = "unlock-recipe",
            recipe = "cube-fluid-level-indicator-straight"
          }
        },
        prerequisites = {
          "cube-fundamental-comprehension-card",
          "cube-fluid-handling",
        },
        unit = tech_cost_unit("1a", 120),
        order = "e-d-e"
    },    
})
