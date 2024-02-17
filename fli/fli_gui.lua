function open_fli_gui(player, ent)

    if not ent or not ent.valid or (ent.name ~= "fluid-level-indicator" and ent.name ~= "fluid-level-indicator-straight" and ent.name ~= "fluid-level-indicator-k2" and ent.name ~= "fluid-level-indicator-straight-k2") then
        return
    end
    if not player then
        return
    end
    global.currentfliunitnumber = ent.unit_number
    local frame_flow = player.gui
    if frame_flow.relative.fli_picker then
        frame_flow.relative.fli_picker.destroy()
    end
    local fli_picker = frame_flow.relative.add({
            type = "frame",
            name = "fli_picker",
            direction = "vertical",
            anchor = { gui = defines.relative_gui_type.storage_tank_gui, position = defines.relative_gui_position.bottom  },
            })
    local fli_title = fli_picker.add({
            type = "label",
            caption = {"fli.pick-indicator-type"},
            tooltip = {"fli.pick-indicator-tooltip"}
            })

    local fli_dropdown = fli_picker.add(
        {
            type = "drop-down",
            items = {{"fli.high-ideal"}, {"fli.mid-ideal"}, {"fli.low-ideal"}, {"fli.flow"}},
            selected_index = global.flitype[ent.unit_number],
            name = "fli_dropdown"
        }    
    )
end    

function close_fli_gui(player, ent)

    if not player then
        return
    end
    local frame_flow = player.gui.relative
    if frame_flow.fli_picker then
        frame_flow.fli_picker.destroy()
    end
    global.currentfliunitnumber = nil
end

function set_fli_type(event)

    local player = game.players[event.player_index]
    if not player then
        return
    end
    if global.currentfliunitnumber == nil then
        return
    end
    global.flitype[global.currentfliunitnumber] = event.element.selected_index
end