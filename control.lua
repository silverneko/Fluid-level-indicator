mod_gui = require("mod-gui")
require "fli/fli"

script.on_event(defines.events.on_built_entity, function(event) placedfli(event.created_entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) placedfli(event.created_entity) end)
script.on_event(defines.events.script_raised_built, function(event) placedfli(event.entity) end)
script.on_event(defines.events.script_raised_revive, function(event) placedfli(event.entity) end)
script.on_event(defines.events.on_entity_cloned, function(event) placedfli(event.destination) end)

script.on_event(defines.events.on_pre_player_mined_item, function(event) removedfli(event.entity) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) removedfli(event.entity) end)
script.on_event(defines.events.on_entity_died, function(event) removedfli(event.entity) end)
script.on_event(defines.events.script_raised_destroy, function(event) removedfli(event.entity) end)
--script.on_event(defines.events.on_entity_destroyed, function(event) fli.removedfli(event.entity) end)


script.on_event(defines.events.on_pre_chunk_deleted, function(event)
    for _,chunk in pairs(event.positions) do
      local x = chunk.x
      local y = chunk.y
      local area = {{x*32,y*32},{31+x*32,31+y*32}}
      for _,ent in pairs(game.get_surface(event.surface_index).find_entities_filtered{name = "fluid-level-indicator",area = area}) do
        removedfli(ent)
      end
    end
end)

script.on_event(defines.events.on_pre_surface_cleared,function(event)
    for _,ent in pairs(game.get_surface(event.surface_index).find_entities_filtered{name = "fluid-level-indicator"}) do
        removedfli(ent)
    end
end)

script.on_event(defines.events.on_pre_surface_deleted,function(event)
    for _,ent in pairs(game.get_surface(event.surface_index).find_entities_filtered{name = "fluid-level-indicator"}) do
        removedfli(ent)
    end
end)


script.on_configuration_changed(function(data)
    --if data.mod_changes and data.mod_changes["fluid-level-indicator"] then
        global.flis = {}
        global.flitexts = {}
        global.flidig1 = {}
        global.flidig10 = {}
        global.flidig100 = {}
        global.flidigpc = {}
        global.fliindex = 1
        global.flikocka = {}
        if global.flitype == nil then
            -- to keep settings
            global.flitype = {}
        end
        global.currentfliunitnumber = nil
        register_flis()
    --end
end)

script.on_init(function() 
    global.flis = {}
    global.flitexts = {}
    global.flidig1 = {}
    global.flidig10 = {}
    global.flidig100 = {}
    global.flidigpc = {}
    global.fliindex = 1
    global.flikocka = {}
    global.flitype = {}
    global.currentfliunitnumber = nil
    end)

script.on_event(defines.events.on_tick, flion_tick)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
    local player = game.players[event.player_index]
    if (event.element.name == "fli_dropdown") then
        set_fli_type(event)
    end
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.players[event.player_index]
    local ent = event.entity
    if (event.gui_type == defines.gui_type.entity) and (ent.name == "fluid-level-indicator") then
        open_fli_gui(player, ent)
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.players[event.player_index]
    local ent = event.entity
    if (event.gui_type == defines.gui_type.entity) and (ent.name == "fluid-level-indicator") then
        close_fli_gui(player, ent)
    end
end)