
empty_sprite = { filename = "__core__/graphics/empty.png", size = 1, frame_count = 1 }
fluid_level_indicator = util.table.deepcopy(data.raw["storage-tank"]["storage-tank"])
local pipe = data.raw["pipe"]["pipe"]

fluid_level_indicator.name = "fluid-level-indicator"
fluid_level_indicator.icon = "__Fluid-level-indicator__/graphics/icons/fi-icon.png"
fluid_level_indicator.icon_size = 32
fluid_level_indicator.flags = {"placeable-player", "player-creation", "placeable-neutral", "placeable-enemy"}
fluid_level_indicator.minable = {mining_time = 0.1, result = "fluid-level-indicator"}
fluid_level_indicator.collision_box = pipe.collision_box
fluid_level_indicator.selection_box = pipe.selection_box
fluid_level_indicator.apply_runtime_tint = true
fluid_level_indicator.fluid_box = 
{
      base_area = 1,
      base_level = 0,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { position = {0, -1} },
        { position = {1, 0} },
        { position = {0, 1} },
        { position = {-1, 0} }
      }
}
fluid_level_indicator.pictures = 
{
      picture =
      {
        sheets =
        {
          {
            filename = "__Fluid-level-indicator__/graphics/entities/hr-pipe-cross-screen.png",
            priority = "extra-high",
            frames = 1,
            width = 64,
            height = 64,
            scale = 1,
            hr_version =
            {
              filename = "__Fluid-level-indicator__/graphics/entities/hr-pipe-cross-screen.png",
              priority = "extra-high",
              frames = 1,
              width = 128,
              height = 128,
              scale = 0.5,
            }
          }
        }
      },
      gas_flow = empty_sprite,
      fluid_background = empty_sprite,
      window_background = empty_sprite,
      flow_sprite = empty_sprite
}

data:extend({
    {
    type = "recipe",
    name = "fluid-level-indicator",
    energy_required = 2,
    enabled = true,
    ingredients = {
        {"steel-plate", 2},
        {"pipe", 2},
        {"small-lamp",1}
    },
    results = {
        {"fluid-level-indicator", 1}
    }
},

{
    type = "item",
    name = "fluid-level-indicator",
    icon = "__Fluid-level-indicator__/graphics/icons/fi-icon.png",
    icon_size = 32,
    flags = {},
    subgroup = "energy-pipe-distribution",
    order = "g[fluid-level-indicator]",
    place_result = "fluid-level-indicator",
    stack_size = 50
},

{
    type = "sprite",
    name = "fluid-level-indicator-red",
    filename = "__Fluid-level-indicator__/graphics/entities/hr-pipe-cross-red.png",
    width = 128,
    height = 128,
    scale = 0.5,
},

fluid_level_indicator
})


