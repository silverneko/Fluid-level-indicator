data:extend({
    {
        type = "technology",
        name = "fluid-level-indicator-st-bobs-steel",
        icon_size = 256,
        icon = "__Fluid-level-indicator__/graphics/icons/tech_icon_blackscreenbck_ss.png",
        hidden = false,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "fluid-level-indicator-st-bobs-steel"
          }
        },
        prerequisites = {"optics", "steel-processing", "fluid-level-indicator"},
        unit =
        {
          count = 75,
          ingredients =
          {
            {"automation-science-pack", 1}
          },
          time = 30
        },
        order = "e-d-f"
      },
      {
        type = "technology",
        name = "fluid-level-indicator-st-bobs-plastic",
        icon_size = 256,
        icon = "__Fluid-level-indicator__/graphics/icons/tech_icon_blackscreenbck_bobsplastic.png",
        hidden = false,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "fluid-level-indicator-st-bobs-plastic"
          }
        },
        prerequisites = {"optics", "plastics", "fluid-level-indicator"},
        unit =
        {
          count = 120,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1}
          },
          time = 30
        },
        order = "e-d-g"
      }
})