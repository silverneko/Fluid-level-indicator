data:extend({
    {
        type = "technology",
        name = "fluid-level-indicator-st-bobs-tungsten",
        icon_size = 256,
        icon = "__Fluid-level-indicator__/graphics/icons/tech_icon_blackscreenbck_tungsten.png",
        hidden = false,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "fluid-level-indicator-st-bobs-tungsten"
          }
        },
        prerequisites = {"optics", "tungsten-processing", "fluid-level-indicator"},
        unit =
        {
          count = 50,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1}
          },
          time = 30
        },
        order = "e-d-f"
      },
      {
        type = "technology",
        name = "fluid-level-indicator-st-bobs-coppertungsten",
        icon_size = 256,
        icon = "__Fluid-level-indicator__/graphics/icons/tech_icon_blackscreenbck_ct.png",
        hidden = false,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "fluid-level-indicator-st-bobs-coppertungsten"
          }
        },
        prerequisites = {"optics", "tungsten-alloy-processing", "fluid-level-indicator"},
        unit =
        {
          count = 50,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1}
          },
          time = 30
        },
        order = "e-d-g"
      }
})