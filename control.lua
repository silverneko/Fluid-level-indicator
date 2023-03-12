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

local function on_tick(event)

    if game.tick % 60 == 0 then
        if players_present and global.flis~=nil then
            for _, fli in pairs(global.flis) do
                local fluid_count = fli.get_fluid_count()
                rendering.set_text(global.flitexts[fli.unit_number],tostring(string.format("%.f",fluid_count)).."%" )
                rendering.set_color(global.flitexts[fli.unit_number], {
                    r=math.max(0, fluid_count < 50 and 1 or (100 - fluid_count) / 50),  
                    g=math.max(0, tonumber((fluid_count >= 50 and fluid_count <= 100) and 1 or ((fluid_count >= 0 and fluid_count < 50) and fluid_count / 50 or 0))),
                    b=0})
               
            end
        end
    end
end

local function register_flis ()
    global.flis = {}

    for _,surface in pairs(game.surfaces) do
        for _,fli in pairs(surface.find_entities_filtered({name = "fluid-level-indicator"})) do
            global.flis[fli.unit_number] = fli
            local textbox = surface.find_entities_filtered({type="text",position={fli.position.x,fli.position.y-0.38}})
            global.flitexts[fli.unit_number] = textbox
        end
    end
end

local function placedfli(placed_entity)

    local surface = placed_entity.surface
    if placed_entity.name=="fluid-level-indicator" then
        global.flis[placed_entity.unit_number] = placed_entity
        global.flitexts[placed_entity.unit_number] = rendering.draw_text({
            text = "0%",
            surface = surface,
            target = {placed_entity.position.x,placed_entity.position.y-0.38},
            color = {r=1,g=0,b=0},
            scale = 1.0,
            font = "default",
            alignment = "center",
            vertical_alignment = "top",
            time_to_live = 0
        })
    end
end

local function removedfli(removed_entity)
    if removed_entity.name=="fluid-level-indicator" then
        global.flis[removed_entity.unit_number] = nil
        rendering.destroy(global.flitexts[removed_entity.unit_number])
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

script.on_configuration_changed(function()
    global.flis = {}
    global.flitexts = {}
    register_flis()
  end)

script.on_init(function() 
    global.flis = {}
    global.flitexts = {}
    end
    )

script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_tick, on_tick)


