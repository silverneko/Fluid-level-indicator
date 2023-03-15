local function players_present()

    local players_present = false
    for _, player in pairs(game.players) do
        if player.connected then
            players_present = true
            break
        end
    end
    return players_present
end

local function fliupdate()

    if next(global.flis)~=nil then
        for i=0, settings.global["number_of_units_to_check_per_update"].value do
            global.fliindex, fli = next(global.flis, global.fliindex)
            if fli~=nil then
                if fli.valid then
                    local surface = fli.surface
                    local fluid_count = fli.get_fluid_count()
                    rendering.set_text(global.flitexts[fli.unit_number],tostring(string.format("%.f",fluid_count)).."%" )
                    rendering.set_color(global.flitexts[fli.unit_number], {
                        r=math.max(0, fluid_count < 50 and 1 or (100 - fluid_count) / 50),  
                        g=math.max(0, tonumber((fluid_count >= 50 and fluid_count <= 100) and 1 or ((fluid_count >= 0 and fluid_count < 50) and fluid_count / 50 or 0))),
                        b=0,
                        a=0.9})
                else
                    rendering.destroy(global.flitexts[global.fliindex])
                    rendering.destroy(global.flikocka[global.fliindex])
                    global.flikocka[global.fliindex] = nil
                    global.flitexts[global.fliindex] = nil
                    global.flis[global.fliindex] = nil
                end
            end
        end
    end
end

local function on_tick(event)
    
    -- Check if players present and if yes, update flis.
    if players_present then
        if game.tick % settings.global["update_every_x_tick"].value == 0 then
                fliupdate()
        end
    end
end

local function create_textbox(fli, surface)

    global.flikocka[fli.unit_number] = rendering.draw_sprite({
        sprite = "cross-pipe",
        target = fli.position,
        surface = surface,
        only_in_alt_mode = true

    })
    global.flitexts[fli.unit_number] = rendering.draw_text({
        text = "0%",
        surface = surface,
        target = {fli.position.x,fli.position.y-0.33},
        color = {r=1,g=0,b=0,a=0.9},
        scale = 1.0,
        font = "seven",
        alignment = "center",
        vertical_alignment = "top",
        time_to_live = 0
    })
end

local function placedfli(placed_entity)

    local surface = placed_entity.surface
    if placed_entity.name=="fluid-level-indicator" then
        global.flis[placed_entity.unit_number] = placed_entity
        create_textbox(placed_entity, surface)
        global.fliindex = placed_entity.unit_number
    end
end

local function register_flis()
    rendering.clear("Fluid-level-indicator")
    for _,surface in pairs(game.surfaces) do
        for _,fli in pairs(surface.find_entities_filtered({name = "fluid-level-indicator"})) do
            global.flis[fli.unit_number] = fli
            create_textbox(fli, surface)
            global.fliindex = fli.unit_number
        end
    end
    if next(global.flis)~= nil then
        global.fliindex, fli = next(global.flis, nil)
    end
end

local function removedfli(removed_entity)
    if removed_entity.name=="fluid-level-indicator" then
        global.flis[removed_entity.unit_number] = nil
        rendering.destroy(global.flitexts[removed_entity.unit_number])
        rendering.destroy(global.flikocka[removed_entity.unit_number])
        global.flikocka[removed_entity.unit_number] = nil
        global.flitexts[removed_entity.unit_number] = nil
    end
end

script.on_event(defines.events.on_built_entity, function(event) placedfli(event.created_entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) placedfli(event.created_entity) end)
script.on_event(defines.events.script_raised_built, function(event) placedfli(event.entity) end)
script.on_event(defines.events.script_raised_revive, function(event) placedfli(event.entity) end)
script.on_event(defines.events.on_entity_cloned, function(event) placedfli(event.destination) end)

script.on_event(defines.events.on_pre_player_mined_item, function(event) removedfli(event.entity) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) removedfli(event.entity) end)
script.on_event(defines.events.on_entity_died, function(event) removedfli(event.entity) end)
script.on_event(defines.events.script_raised_destroy, function(event) removedfli(event.entity) end)


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
  script.on_event(defines.events.on_pre_surface_cleared,function (event)
    for _,ent in pairs(game.get_surface(event.surface_index).find_entities_filtered{name = "fluid-level-indicator"}) do
        removedfli(ent)
    end
  end)
  script.on_event(defines.events.on_pre_surface_deleted,function (event)
    for _,ent in pairs(game.get_surface(event.surface_index).find_entities_filtered{name = "fluid-level-indicator"}) do
        removedfli(ent)
    end
  end)


script.on_configuration_changed(function()
    global.flis = {}
    global.flitexts = {}
    global.fliindex = 1
    global.flikocka = {}
    register_flis()
  end)

script.on_init(function() 
    global.flis = {}
    global.flitexts = {}
    global.fliindex = 1
    global.flikocka = {}
    end
    )

script.on_event(defines.events.on_tick, on_tick)
