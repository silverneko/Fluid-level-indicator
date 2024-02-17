if not fli then
    fli = {}
end

require("fli/fli_gui")

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

local function get_digit(num, digit)

    local length = #num
    if digit < 1 or digit > length then
        return "flinumber "
    end
    return ("flinumber"..string.sub(num, length - digit + 1, length - digit + 1))
end

local function set_color(unit, fluid_count)

    rendering.set_color(unit, {
        r=0.8*math.max(0, fluid_count < 50 and 1 or (100 - fluid_count) / 50),  
        g=0.8*math.max(0, tonumber((fluid_count >= 50 and fluid_count <= 100) and 1 or ((fluid_count >= 0 and fluid_count < 50) and fluid_count / 50 or 0))),
        b=0
    })
end

local function calc_color(fluid_count, fli_type)

    b = 0
    a = 1
    if fli_type == 1 then
        -- normal color
        r=0.8*math.max(0, fluid_count < 50 and 1 or (100 - fluid_count) / 50)
        g=0.8*math.max(0, tonumber((fluid_count >= 50 and fluid_count <= 100) and 1 or ((fluid_count >= 0 and fluid_count < 50) and fluid_count / 50 or 0)))
    elseif fli_type == 2 then
        g = 0.8 * math.max(0, ((fluid_count > 25 and fluid_count < 75) and 1 or (((fluid_count <= 25 and (fluid_count / 25)) or (fluid_count >= 75 and math.abs(50-fluid_count/50)) and (-(fluid_count-100) / 25) or 0))))
        r = 0.8* ((fluid_count < 25 or fluid_count > 75) and 1 or 2*math.abs(50 - fluid_count) / 50)
    elseif fli_type == 3 then
        r=0.8*math.max(0, tonumber((fluid_count >= 50 and fluid_count <= 100) and 1 or ((fluid_count >= 0 and fluid_count < 50) and fluid_count / 50 or 0)))
        g=0.8*math.max(0, fluid_count < 50 and 1 or (100 - fluid_count) / 50)
    else
        r = 0.2
        g = 0.65
        b = 1
    end
    local color = {r, g, b, a}
    return color
end

function removedfli(removed_entity)

    if (removed_entity.name=="fluid-level-indicator") or (removed_entity.name=="fluid-level-indicator-straight") or (removed_entity.name=="fluid-level-indicator-k2") or (removed_entity.name=="fluid-level-indicator-straight-k2")then
        global.flis[removed_entity.unit_number] = nil
        --rendering.destroy(global.flikocka[removed_entity.unit_number])
        --global.flikocka[removed_entity.unit_number] = nil
        global.flitype[removed_entity.unit_number] = nil
        if settings.startup["font-picker"].value=="sprite" then
            rendering.destroy(global.flidig1[removed_entity.unit_number])
            rendering.destroy(global.flidig10[removed_entity.unit_number])
            rendering.destroy(global.flidig100[removed_entity.unit_number])
            rendering.destroy(global.flidigpc[removed_entity.unit_number])
            global.flidig1[removed_entity.unit_number] = nil
            global.flidig10[removed_entity.unit_number] = nil
            global.flidig100[removed_entity.unit_number] = nil
            global.flidigpc[removed_entity.unit_number] = nil
        else
            rendering.destroy(global.flitexts[removed_entity.unit_number])
            global.flitexts[removed_entity.unit_number] = nil
        end
    end
end

local function fli_update()

    if next(global.flis)~=nil then
        for i=0, settings.global["number_of_units_to_check_per_update"].value do
            global.fliindex, fli = next(global.flis, global.fliindex)
            if fli~=nil then
                if fli.valid then
                    local surface = fli.surface
                    if global.flitype[fli.unit_number] == nil then
                        -- If migration failed
                        global.flitype[fli.unit_number] = 1
                    end
                    local fluid_count = 0
                    if global.flitype[fli.unit_number] == 4 then
                        fluid_count = fli.fluidbox.get_flow(1)*60
                        -- game.print(fluid_count)
                    else
                        local fluid_count_actual = fli.get_fluid_count()
                        local maxfluid = fli.fluidbox.get_capacity(1)
                        fluid_count = fluid_count_actual/maxfluid*100
                    end
                    local color = {1, 1, 1, 1}

                    color = calc_color(fluid_count, global.flitype[fli.unit_number])
                    if settings.startup["font-picker"].value=="sprite" then
                        if global.flitype[fli.unit_number] == 4 then
                            rendering.set_sprite(global.flidig1[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),2))
                            rendering.set_sprite(global.flidig10[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),3))
                            rendering.set_sprite(global.flidig100[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),4))
                            rendering.set_sprite(global.flidigpc[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),1))
                        else
                            rendering.set_sprite(global.flidig1[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),1))
                            rendering.set_sprite(global.flidig10[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),2))
                            rendering.set_sprite(global.flidig100[global.fliindex], get_digit(tostring(string.format("%.f",fluid_count)),3))
                            rendering.set_sprite(global.flidigpc[global.fliindex], "flinumberpc")
                        end
                        rendering.set_color(global.flidig1[fli.unit_number],color)
                        rendering.set_color(global.flidig10[fli.unit_number],color)
                        rendering.set_color(global.flidig100[fli.unit_number],color)
                        rendering.set_color(global.flidigpc[fli.unit_number],color)
                    else
                        if global.flitype[fli.unit_number] == 4 then
                            rendering.set_text(global.flitexts[fli.unit_number],tostring(string.format("%.f",fluid_count)))
                            rendering.set_color(global.flitexts[fli.unit_number], color)
                        else
                            rendering.set_text(global.flitexts[fli.unit_number],tostring(string.format("%.f",fluid_count)).."%" )
                            rendering.set_color(global.flitexts[fli.unit_number], color)
                        end
                    end
                else
                    if settings.startup["font-picker"].value=="sprite" then
                        rendering.destroy(global.flidig1[global.fliindex])
                        rendering.destroy(global.flidig10[global.fliindex])
                        rendering.destroy(global.flidig100[global.fliindex])
                        rendering.destroy(global.flidigpc[global.fliindex])
                        --rendering.destroy(global.flikocka[global.fliindex])
                        --global.flikocka[global.fliindex] = nil
                        global.flidig1[global.fliindex] = nil
                        global.flidig10[global.fliindex] = nil
                        global.flidig100[global.fliindex] = nil
                        global.flidigpc[global.fliindex] = nil
                        global.flis[global.fliindex] = nil
                    else
                        rendering.destroy(global.flitexts[global.fliindex])
                        --rendering.destroy(global.flikocka[global.fliindex])
                        --global.flikocka[global.fliindex] = nil
                        global.flitexts[global.fliindex] = nil
                        global.flis[global.fliindex] = nil
                    end
                end
            end
        end
    end
end

local function create_textbox(fli, surface)

    --global.flikocka[fli.unit_number] = rendering.draw_sprite({
    --    sprite = "cross-pipe",
    --    target = fli.position,
    --    surface = surface,
    --    --only_in_alt_mode = true
    --})
    if settings.startup["font-picker"].value=="sprite" then
        global.flidig100[fli.unit_number] = rendering.draw_sprite({
            sprite = "flinumber ",
            target = {fli.position.x-0.29,fli.position.y-0.06},
            surface = surface,
            tint = {r=1.0,  g=0.0,  b=0.0, a=0.9},
            x_scale = 0.05,
            y_scale = 0.05,
            })
        global.flidig10[fli.unit_number] = rendering.draw_sprite({
            sprite = "flinumber ",
            target = {fli.position.x-0.12,fli.position.y-0.06},
            surface = surface,
            tint = {r=1.0,  g=0.0,  b=0.0, a=0.9},
            x_scale = 0.05,
            y_scale = 0.05,
            })
        global.flidig1[fli.unit_number] = rendering.draw_sprite({
            sprite = "flinumber0",
            target = {fli.position.x+0.1,fli.position.y-0.06},
            surface = surface,
            tint = {r=1.0,  g=0.0,  b=0.0, a=0.9},
            x_scale = 0.05,
            y_scale = 0.05,
            })
        global.flidigpc[fli.unit_number] = rendering.draw_sprite({
            sprite = "flinumberpc",
            target = {fli.position.x+0.28,fli.position.y-0.06},
            surface = surface,
            tint = {r=1.0,  g=0.0,  b=0.0, a=0.9},
            x_scale = 0.05,
            y_scale = 0.05,
            })
    elseif settings.startup["font-picker"].value=="default" then
        global.flitexts[fli.unit_number] = rendering.draw_text({
            text = "0%",
            surface = surface,
            target = {fli.position.x,fli.position.y-0.34},
            color = {r=1,g=0,b=0,a=0.9},
            scale = 0.90,
            font = settings.startup["font-picker"].value,
            alignment = "center",
            vertical_alignment = "top",
            time_to_live = 0
        })
    else
        global.flitexts[fli.unit_number] = rendering.draw_text({
            text = "0%",
            surface = surface,
            target = {fli.position.x+0.03,fli.position.y-0.32},
            color = {r=1,g=0,b=0,a=0.9},
            scale = 1,
            font = settings.startup["font-picker"].value,
            alignment = "center",
            vertical_alignment = "top",
            time_to_live = 0
        })
    end
end

function flion_tick(event)

    if players_present then
        if game.tick % settings.global["update_every_x_tick"].value == 0 then
                fli_update()
        end
    end
end

function placedfli(placed_entity)

    local surface = placed_entity.surface
    if (placed_entity.name=="fluid-level-indicator") or (placed_entity.name=="fluid-level-indicator-straight") or (placed_entity.name=="fluid-level-indicator-k2") or (placed_entity.name=="fluid-level-indicator-straight-k2") then
        global.flis[placed_entity.unit_number] = placed_entity
        create_textbox(placed_entity, surface)
        global.fliindex = placed_entity.unit_number
        global.flitype[placed_entity.unit_number] = 1
    end
end

function register_flis()

    rendering.clear("Fluid-level-indicator")
    for _,surface in pairs(game.surfaces) do
        for _,fli in pairs(surface.find_entities_filtered({name = {"fluid-level-indicator", "fluid-level-indicator-straight","fluid-level-indicator-k2","fluid-level-indicator-straight-k2"}})) do
            global.flis[fli.unit_number] = fli
            if global.flitype[fli.unit_number] == nil then
                global.flitype[fli.unit_number] = 1
            end
            create_textbox(fli, surface)
            global.fliindex = fli.unit_number
        end
    end
    if next(global.flis)~= nil then
        global.fliindex, fli = next(global.flis, nil)
    end
end


