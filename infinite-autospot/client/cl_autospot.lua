local Infinite = {}
local fatneek = 0
local InPoly = false
local breasty = 0
local spawns = {
    [1] = {
        ["x"] = -377.14587402344, 
        ["y"] = -146.86508178711, 
        ["z"] = 38.682029724121, 
        ["h"] = 299.99057006836
    },
    [2] = {
        ["x"] = -378.99334716797, 
        ["y"] = -143.66078186035, 
        ["z"] = 38.682823181152, 
        ["h"] = 299.99057006836
    },
    [3] = {
        ["x"] = -380.79104614258, 
        ["y"] = -140.54315185547, 
        ["z"] = 38.683574676514, 
        ["h"] = 299.99057006836
    },
    [4] = {
        ["x"] = -382.53848266602, 
        ["y"] = -137.51184082031, 
        ["z"] = 38.683574676514, 
        ["h"] = 299.99057006836
    },
    [5] = {
        ["x"] = -384.31121826172, 
        ["y"] = -134.43753051758, 
        ["z"] = 38.684120178223, 
        ["h"] = 299.99057006836
    },
    [6] = {
        ["x"] = -386.1591796875, 
        ["y"] = -131.23364257812, 
        ["z"] = 38.684177398682, 
        ["h"] = 299.99057006836
    },
    [7] = {
        ["x"] = -387.88198852539, 
        ["y"] = -128.24592590332, 
        ["z"] = 38.683155059814, 
        ["h"] = 299.99057006836
    },
    [8] = {
        ["x"] = -389.47744750977, 
        ["y"] = -125.36014556885, 
        ["z"] = 38.683547973633, 
        ["h"] = 299.99057006836
    },
    [9] = {
        ["x"] = -391.1953125, 
        ["y"] = -122.30990600586, 
        ["z"] = 38.680694580078,
        ["h"] = 299.99057006836
    },
    [10] = {
        ["x"] = -392.98913574219,
        ["y"] = -119.13307952881, 
        ["z"] = 38.561862945557,
        ["h"] = 299.99057006836
    }
}
local vehicles = {
    [1] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [2] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [3] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [4] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [5] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [6] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [7] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [8] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [9] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    },
    [10] = {
        ["id"] = nil,
        ["plate"] = nil,
        ['testdrive'] = false,
        ['model'] = nil
    }
}

RegisterNetEvent('infinite-autospot:begincheck')
AddEventHandler('infinite-autospot:begincheck', function(cid, cost)
    TriggerServerEvent('infinite-autospot-check:sv', cid, cost)
end)

RegisterNetEvent('infinite-autospots:purchased')
AddEventHandler('infinite-autospots:purchased', function(target, price, plate)
    if target == exports['PedManager']:PedManager('cid') then
        TriggerServerEvent('infinite-autos:pay-customer', target, price, plate)
    end
end)

RegisterNetEvent('irp-polyzone:enter')
AddEventHandler('irp-polyzone:enter', function(name)
    if name == 'autospot_enter' then
        InPoly = true
        TriggerServerEvent('infinite-autos:get-vehicledata')
    elseif name == "vehicle_view_values1" then
        if vehicles[1].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[1].plate, 1)
        end
    elseif name == "vehicle_view_values2" then
        if vehicles[2].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[2].plate, 2)
        end
    elseif name == "vehicle_view_values3" then
        if vehicles[3].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[3].plate, 3)
        end
    elseif name == "vehicle_view_values4" then
        if vehicles[4].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[4].plate, 4)
        end
    elseif name == "vehicle_view_values5" then
        if vehicles[5].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[5].plate, 5)
        end
    elseif name == "vehicle_view_values6" then
        if vehicles[6].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[6].plate, 6)
        end
    elseif name == "vehicle_view_values7" then
        if vehicles[7].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[7].plate, 7)
        end
    elseif name == "vehicle_view_values8" then
        if vehicles[8].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[8].plate, 8)
        end
    elseif name == "vehicle_view_values9" then
        if vehicles[9].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[9].plate, 9)
        end
    elseif name == "vehicle_view_values10" then
        if vehicles[10].plate ~= nil then
            TriggerServerEvent('infinite-autos:vehicleprice', vehicles[10].plate, 10)
        end
    elseif name == "autospot_testdrive_rent" then
        if exports['PedManager']:PedManager('myJob') == 'autospot' then
            ReadyToReturn = true
            exports['irp-ui']:showInteraction('[E] Return Vehicle')
            ReturnVehicle()
        end
    end
end)

function ReturnVehicle()
    Citizen.CreateThread(function()
        while ReadyToReturn do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                DeleteEntity(vehicle)
                breasty = 0
                TriggerEvent('infinite-autospot:swap:cl')
                ReadyToReturn = false
                return
            end
        end
    end)
end

RegisterNetEvent('irp-polyzone:exit')
AddEventHandler('irp-polyzone:exit', function(name)
    if name == "autospot_enter" then
        InPoly = false
        for i = 1, #vehicles do
            Citizen.Wait(10)
            if vehicles[i].id ~= nil then
                DeleteEntity(vehicles[i].id)
            end
        end
    elseif name == "vehicle_view_values1" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values2" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values3" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values4" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values5" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values6" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values7" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values8" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values9" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "vehicle_view_values10" then
        rapey = false
        exports['irp-ui']:hideInteraction()
    elseif name == "autospot_testdrive_rent" then
        if exports['PedManager']:PedManager('myJob') == 'autospot' then
            ReadyToReturn = false
            exports['irp-ui']:hideInteraction()
        end
    end
end)

RegisterNetEvent('infinite-autospot:spawnvehicles')
AddEventHandler('infinite-autospot:spawnvehicles', function()
    TriggerServerEvent('infinite-autos:get-vehicledata')
end)

RegisterNetEvent('infinite-autospot:purchase')
AddEventHandler('infinite-autospot:purchase', function(plate, args)
    if tonumber(args) == 1 then
        TriggerEvent('irp-context:sendMenu', {
            {
                id = 1,
                header = '> Accept Vehicle Offer',
                txt = 'Accept Vehicle | ' .. plate,
                params = {
                    event = "infinite-autospot:purchase",
                    args = plate,
                    args2 = 2
                }
            },
            {
                id = 2, 
                header = '> Decline Vehicle Offer',
                txt = "Decline Vehicle | " .. plate,
                params = {
                    event = "infinite-autospot:purchase",
                    args = plate,
                    args2 = 3
                }
            }
        })
    elseif tonumber(args) == 2 then
        TriggerEvent('DoLongHudText', 'Attempting Purchase')
        Citizen.Wait(math.random(500, 1000))
        TriggerServerEvent('infinite-autospot:purchasedvehicle', plate)
    elseif tonumber(args) == 3 then
        TriggerEvent('DoLongHudText', 'Declining Vehicle Offer')
        Citizen.Wait(math.random(500, 1000))
        TriggerServerEvent('infinite-autospot:declinevehicle', plate)
    end
end)

RegisterNetEvent('infinite-autospot:viewstock')
AddEventHandler('infinite-autospot:viewstock', function()
    TriggerServerEvent('infinite-autos:check-stock-list')
end)

RegisterNetEvent('infinite-autospot:sellvehicle')
AddEventHandler('infinite-autospot:sellvehicle', function()
    local plate = exports["irp-applications"]:KeyboardInput({
		header = "Enter License Plate",
		rows = {
		  {
			id = 0,
			txt = "Plate (Case Sens)"
		  },
          {
            id = 1,
            txt = "Price ($)"
        }
		}
	})
	if plate then
        TriggerServerEvent('infinite-autospot:sellsv', plate[1].input, tonumber(plate[2].input))
    end
end)

RegisterNetEvent('infinite-autospot:spawn:cl')
AddEventHandler('infinite-autospot:spawn:cl', function(data)
    fatneek = 0
    for i = 1, #data do
        if tonumber(data[i].display) == 1 then
            Citizen.Wait(100)
            if fatneek > 10 then
                fatneek = 0
                return 
            end
            fatneek = fatneek + 1
            if not vehicles[fatneek].testdrive then
                local model = GetHashKey(data[i].model)
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(1)
                    RequestModel(model)
                end 
                vehicles[fatneek].id = CreateVehicle(model, spawns[fatneek].x, spawns[fatneek].y, spawns[fatneek].z, spawns[fatneek].h, false, false)
                vehicles[fatneek].model = data[i].model
                FreezeEntityPosition(vehicles[fatneek].id, true) -- causing issue with headlights? 
                SetVehicleDoorsLocked(vehicles[fatneek].id, 3)
                SetVehicleNumberPlateText(vehicles[fatneek].id, data[i].license_plate)
                vehicles[fatneek].plate = data[i].license_plate
                SetModelAsNoLongerNeeded(data[fatneek].model)
                            
                DecorSetInt(vehicles[fatneek].id, "CurrentFuel", 100)
                DecorSetBool(vehicles[fatneek].id, "PlayerVehicle", true)
                SetVehicleOnGroundProperly(vehicles[fatneek].id)
                SetEntityInvincible(vehicles[fatneek].id, false) 

                SetVehicleModKit(vehicles[fatneek].id, 0)

                local customized = json.decode(data[i].data)
                if customized then
                    
                    SetVehicleWheelType(vehicles[fatneek].id, customized.wheeltype)
                    SetVehicleNumberPlateTextIndex(vehicles[fatneek].id, 3)
                    for a = 0, 16 do
                        SetVehicleMod(vehicles[fatneek].id, a, customized.mods[tostring(a)])
                    end

                    for a = 17, 22 do
                        ToggleVehicleMod(vehicles[fatneek].id, a, customized.mods[tostring(a)])
                    end

                    for a = 23, 24 do
                        local isCustom = customized.mods[tostring(a)]
                        if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
                            isSet = false
                        else
                            isSet = true
                        end
                        SetVehicleMod(vehicles[fatneek].id, a, customized.mods[tostring(a)], isCustom)
                    end

                    for a = 23, 48 do
                        SetVehicleMod(vehicles[fatneek].id, a, customized.mods[tostring(a)])
                    end

                    for a = 0, 3 do
                        SetVehicleNeonLightEnabled(vehicles[fatneek].id, a, customized.neon[tostring(a)])
                    end

                    if customized.extras ~= nil then
                        for a = 1, 12 do
                            local onoff = tonumber(customized.extras[a])
                            if onoff == 1 then
                                SetVehicleExtra(vehicles[fatneek].id, a, 0)
                            else
                                SetVehicleExtra(vehicles[fatneek].id, a, 1)
                            end
                        end
                    end

                    if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
                        SetVehicleLivery(vehicles[fatneek].id, customized.oldLiveries)
                    end

                    if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
                        SetVehicleNumberPlateTextIndex(vehicles[fatneek].id, customized.plateIndex)
                    end

                    -- Xenon Colors
                    SetVehicleXenonLightsColour(vehicles[fatneek].id, (customized.xenonColor or -1))
                    SetVehicleColours(vehicles[fatneek].id, customized.colors[1], customized.colors[2])
                    SetVehicleExtraColours(vehicles[fatneek].id, customized.extracolors[1], customized.extracolors[2])
                    SetVehicleNeonLightsColour(vehicles[fatneek].id, customized.lights[1], customized.lights[2], customized.lights[3])
                    SetVehicleTyreSmokeColor(vehicles[fatneek].id, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
                    SetVehicleWindowTint(vehicles[fatneek].id, customized.tint)
                    SetVehicleInteriorColour(vehicles[fatneek].id, customized.dashColour)
                    SetVehicleDashboardColour(vehicles[fatneek].id, customized.interColour)
                else
                    SetVehicleColours(vehicles[fatneek].id, 0, 0)
                    SetVehicleExtraColours(vehicles[fatneek].id, 0, 0)
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for i = 1, #vehicles do
        if vehicles[i].id ~= nil then
            DeleteEntity(vehicles[i].id)
        end
    end
end)

RegisterNetEvent('infinite-autospot:change-display:vehicle')
AddEventHandler('infinite-autospot:change-display:vehicle', function()
    TriggerServerEvent('infinite-autospot:swapveh:sv')
end)

RegisterNetEvent('infinite-autospot:swapveh')
AddEventHandler('infinite-autospot:swapveh', function(plate, args)
    local args = tonumber(args)
    if args == 1 then
        Infinite.PlateOne = plate
        TriggerServerEvent('infinite-autospot:query:swap', plate)
    elseif args == 2 then
        Infinite.PlateTwo = plate
        TriggerServerEvent('infinite-autospot:actualquery:swap', Infinite.PlateOne, Infinite.PlateTwo)
    end
end)

RegisterNetEvent('infinite-autospot:adddisplay')
AddEventHandler('infinite-autospot:adddisplay', function(plate)
    TriggerServerEvent('infinite-autospot:update:db', plate)
end)

RegisterNetEvent('infinite-autospot:swap:cl')
AddEventHandler('infinite-autospot:swap:cl', function()
    if InPoly then
        for i = 1, #vehicles do
            if vehicles[i].id ~= nil then
                DeleteEntity(vehicles[i].id)
            end
        end
        TriggerServerEvent('infinite-autos:get-vehicledata')
    end
end)

RegisterNetEvent('infinite-autos:vehicleprice:cl')
AddEventHandler('infinite-autos:vehicleprice:cl', function(cost, plate, kian)
    if exports['PedManager']:PedManager('myJob') == 'autospot' and exports['PedManager']:GroupRank() >= 6 then
        exports['irp-ui']:showInteraction('[E] Edit Price | $' .. cost .. ' | [F] Test Drive')
        rapey = true
        Citizen.CreateThread(function()
            while rapey do
                Citizen.Wait(5)
                if IsControlJustReleased(0, 38) then
                    local info = exports["irp-applications"]:KeyboardInput({
                        header = "Edit Price | $" .. cost,
                        rows = {
                          {
                            id = 0,
                            txt = "Vehicle Price"
                          }
                        }
                    })
                    if info then
                        TriggerServerEvent('infinite-autospot:edit-price', plate, tonumber(info[1].input))
                    end
                    rapey = false
                    return
                end
                if IsControlJustReleased(0, 23) then
                    -- vehicles[kian].testdrive = true
                    DeleteEntity(vehicles[kian].id)
                    TriggerServerEvent('infinite-autospot:testdrive-vehicle', plate, kian)
                    rapey = false
                    -- -364.97131347656, -112.46500396729, 38.69660949707, 161.03588867188
                    return
                end
            end
        end)
    else
        exports['irp-ui']:showInteraction('Vehicle Price: $' .. cost)
    end
end)

RegisterNetEvent('infinite-autospot:testdrive:cl')
AddEventHandler('infinite-autospot:testdrive:cl', function(data, breasty)
    breasty = breasty
    RequestModel(data.model)

    while not HasModelLoaded(data.model) do
        Citizen.Wait(4)
    end

    Infinite.Testdrive = CreateVehicle(data.model, -364.97131347656, -112.46500396729, 38.69660949707, 161.03588867188, true, false)
        
    local plt = GetVehicleNumberPlateText(Infinite.Testdrive)

    SetVehicleModKit(Infinite.Testdrive, 0)

    local customized = json.decode(data.data)
    if customized then
        
        SetVehicleWheelType(Infinite.Testdrive, customized.wheeltype)
        SetVehicleNumberPlateTextIndex(Infinite.Testdrive, 3)
        for a = 0, 16 do
            SetVehicleMod(Infinite.Testdrive, a, customized.mods[tostring(a)])
        end

        for a = 17, 22 do
            ToggleVehicleMod(Infinite.Testdrive, a, customized.mods[tostring(a)])
        end

        for a = 23, 24 do
            local isCustom = customized.mods[tostring(a)]
            if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
                isSet = false
            else
                isSet = true
            end
            SetVehicleMod(Infinite.Testdrive, a, customized.mods[tostring(a)], isCustom)
        end

        for a = 23, 48 do
            SetVehicleMod(Infinite.Testdrive, a, customized.mods[tostring(a)])
        end

        for a = 0, 3 do
            SetVehicleNeonLightEnabled(Infinite.Testdrive, a, customized.neon[tostring(a)])
        end

        if customized.extras ~= nil then
            for a = 1, 12 do
                local onoff = tonumber(customized.extras[a])
                if onoff == 1 then
                    SetVehicleExtra(Infinite.Testdrive, a, 0)
                else
                    SetVehicleExtra(Infinite.Testdrive, a, 1)
                end
            end
        end

        if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
            SetVehicleLivery(Infinite.Testdrive, customized.oldLiveries)
        end

        if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
            SetVehicleNumberPlateTextIndex(Infinite.Testdrive, customized.plateIndex)
        end

        -- Xenon Colors
        SetVehicleXenonLightsColour(Infinite.Testdrive, (customized.xenonColor or -1))
        SetVehicleColours(Infinite.Testdrive, customized.colors[1], customized.colors[2])
        SetVehicleExtraColours(Infinite.Testdrive, customized.extracolors[1], customized.extracolors[2])
        SetVehicleNeonLightsColour(Infinite.Testdrive, customized.lights[1], customized.lights[2], customized.lights[3])
        SetVehicleTyreSmokeColor(Infinite.Testdrive, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
        SetVehicleWindowTint(Infinite.Testdrive, customized.tint)
        SetVehicleInteriorColour(Infinite.Testdrive, customized.dashColour)
        SetVehicleDashboardColour(Infinite.Testdrive, customized.interColour)
    else
        SetVehicleColours(Infinite.Testdrive, 0, 0)
        SetVehicleExtraColours(Infinite.Testdrive, 0, 0)
    end

    DecorSetInt(Infinite.Testdrive,"GamemodeCar",955)
        
    SetVehicleHasBeenOwnedByPlayer(Infinite.Testdrive,true)

    TriggerEvent("keys:received",plt)

    SetModelAsNoLongerNeeded(data.model)
        
    SetVehicleHasBeenOwnedByPlayer(Infinite.Testdrive, true)

    local netid = NetworkGetNetworkIdFromEntity(Infinite.Testdrive)

    SetNetworkIdCanMigrate(netid, true)

    NetworkRegisterEntityAsNetworked(VehToNet(Infinite.Testdrive))
    TaskWarpPedIntoVehicle(PlayerPedId(), Infinite.Testdrive, -1)
    rapey = false
end)

RegisterNetEvent('infinite-autospot:updateui')
AddEventHandler('infinite-autospot:updateui', function(price)
    exports['irp-ui']:hideInteraction()
    Citizen.Wait(500)
    exports['irp-ui']:showInteraction('Edit Price | $' .. price)
end)

RegisterNetEvent('infinite-autospot:sellveh')
AddEventHandler('infinite-autospot:sellveh', function()
    local info = exports["irp-applications"]:KeyboardInput({
		header = "Enter License Plate",
		rows = {
		  {
			id = 0,
			txt = "Plate (Case Sens)"
		  },
          {
            id = 1,
            txt = "Player ID"
        }
		}
	})
	if info then
        TriggerServerEvent('infinite-auotspot:sellveh:sv', info[1].input, tonumber(info[2].input))
    end
end)

RegisterNetEvent('infinite-autospot:add-display:vehicle')
AddEventHandler('infinite-autospot:add-display:vehicle', function()
    TriggerServerEvent('infinite-autospot:add-display:vehicle:sv')
end)