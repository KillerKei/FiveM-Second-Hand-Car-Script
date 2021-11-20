local IsFound = false
RegisterServerEvent('infinite-autos:get-vehicledata')
AddEventHandler('infinite-autos:get-vehicledata', function()
    local src = source
    exports.ghmattimysql:execute('SELECT `model`, `license_plate`, `data`, `vehicle_state`, `fuel`, `engine_damage`, `body_damage`, `display` FROM sendhand_cars', function(vehicles)
        TriggerClientEvent('infinite-autospot:spawn:cl', src, vehicles)
    end)
end)    

RegisterServerEvent('infinite-autos:check-stock-list')
AddEventHandler('infinite-autos:check-stock-list', function()
    local src = source
    exports.ghmattimysql:execute('SELECT `cid`, `model`, `license_plate`, `full_name`, `price` FROM secondhand_car_stock', function(vehicles)
        if vehicles[1] ~= nil then
            for i = 1, #vehicles do
                TriggerClientEvent('irp-context:sendMenu', src, {
                    {
                        id = i,
                        header = 'Vehicle Name: ' .. vehicles[i].model .. ' | Owner Name: ' .. vehicles[i].full_name,
                        txt = '> Purchase | Price: ' .. vehicles[i].price .. ' | License Plate: ' .. vehicles[i].license_plate,
                        params = {
                            event = "infinite-autospot:purchase",
                            args = vehicles[i].license_plate,
                            args2 = 1
                        }
                    }
                })
            end
        else
            TriggerClientEvent('DoLongHudText', src, 'No one is wanting to sell vehicles at this time', 2)
        end
    end)
end)

RegisterServerEvent('infinite-autospot:sellsv')
AddEventHandler('infinite-autospot:sellsv', function(plate, cost)
    local src = source
    local user = exports["irp-framework"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    if cost ~= nil then
        if tonumber(cost) <= 1000000 then
            exports.ghmattimysql:execute('SELECT `license_plate`, `cid`, `model`, `sale` FROM characters_cars WHERE cid = ? AND license_plate = ?', {character.id, plate}, function(vehicles)
                if vehicles[1] ~= nil then
                    if tonumber(vehicles[1].sale) ~= 1 then 
                        exports.ghmattimysql:execute("INSERT INTO secondhand_car_stock (cid, model, license_plate, full_name, price) VALUES (@cid, @model, @license_plate, @full_name, @price)", {
                            ['@cid'] = character.id,
                            ['@model'] = vehicles[1].model,
                            ['@license_plate'] = plate,
                            ['@full_name'] = character.first_name .. ' ' .. character.last_name,
                            ['@price'] = tonumber(cost)
                        })
                        TriggerClientEvent('DoLongHudText', src, "The vehicle has been added to a queue. Please wait for the owner to get back to you, he has been notified.")
                    else
                        TriggerClientEvent('DoLongHudText', src, "This vehicle is already up for sale.", 2)
                    end

                else
                    TriggerClientEvent('DoLongHudText', src, 'I cannot find this vehicle, either you do not own it or you have mistyped the license plate, remember is case-sensitive.', 2)
                end
            end)
        else
            TriggerClientEvent('DoLongHudText', src, "You cannot sell a vehicle for more then $1 million.", 2)
        end
    end
end)

RegisterServerEvent('infinite-autospot:purchasedvehicle')
AddEventHandler('infinite-autospot:purchasedvehicle', function(plate)
    local src = source
    local user = exports["irp-framework"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT `license_plate`, `price`, `cid` FROM secondhand_car_stock WHERE license_plate = ?', {plate}, function(result)
        if tonumber(user:getCash()) >= tonumber(result[1].price) then
            exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE license_plate = ?', {plate}, function(vehicledata)
                if vehicledata[1] ~= nil then
                    if result[1] ~= nil then
                        user:removeMoney(tonumber(result[1].price))
                        local cid = tonumber(result[1].cid)
                        TriggerClientEvent('infinite-autospots:purchased', -1, cid, tonumber(result[1].price), plate)
                        TriggerClientEvent('infinite-autospot:begincheck', src, cid, tonumber(result[1].price))
                        exports.ghmattimysql:execute("INSERT INTO sendhand_cars (price, purchase_price, isFinanced, model, vehicle_state, fuel, name, engine_damage, body_damage, degredation, current_garage, financed, last_payment, license_plate, payments_left, server_number, data, repoed, paymentDue, lastroadtax_payment, roadtax, roadtaxDue, display, cid) VALUES (@price, @purchase_price, @isFinanced, @model, @vehicle_state, @fuel, @name, @engine_damage, @body_damage, @degredation, @current_garage, @financed, @last_payment, @license_plate, @payments_left, @server_number, @data, @repoed, @paymentDue, @lastroadtax_payment, @roadtax, @roadtaxDue, @display, @cid)", {
                            ['@price'] = tonumber(result[1].price),
                            ['@purchase_price'] = tonumber(vehicledata[1].purchase_price),
                            ['@isFinanced'] = tonumber(vehicledata[1].isFinanced),
                            ['@model'] = vehicledata[1].model,
                            ['@vehicle_state'] = vehicledata[1].vehicle_state,
                            ['@fuel'] = tonumber(vehicledata[1].fuel),
                            ['@name'] = vehicledata[1].name,
                            ['@engine_damage'] = tonumber(vehicledata[1].engine_damage),
                            ['@body_damage'] = tonumber(vehicledata[1].body_damage),
                            ['@degredation'] = vehicledata[1].degredation,
                            ['@current_garage'] = vehicledata[1].current_garage,
                            ['@financed'] = tonumber(vehicledata[1].financed),
                            ['@last_payment'] = tonumber(vehicledata[1].last_payment),
                            ['@license_plate'] = result[1].license_plate,
                            ['@payments_left'] = tonumber(vehicledata[1].payments_left),
                            ['@server_number'] = tonumber(vehicledata[1].server_number),
                            ['@data'] = vehicledata[1].data,
                            ['@repoed'] = tonumber(vehicledata[1].repoed), 
                            ['@paymentDue'] = tonumber(vehicledata[1].paymentDue),
                            ['@lastroadtax_payment'] = tonumber(vehicledata[1].lastroadtax_payment),
                            ['@roadtax'] = tonumber(vehicledata[1].roadtax),
                            ['@roadtaxDue'] = tonumber(vehicledata[1].roadtaxDue),
                            ['@display'] = 0,
                            ['@cid'] = tonumber(result[1].cid)
                        })
                        Citizen.Wait(100)
                        exports.ghmattimysql:execute("DELETE FROM secondhand_car_stock WHERE `license_plate` = ?", {plate})
                        Citizen.Wait(100)
                        exports.ghmattimysql:execute("UPDATE characters_cars SET `sale` = @sale WHERE `license_plate` = @license_plate", {
                            ['@license_plate'] = plate,
                            ['@sale'] = 1,
                        })
                        TriggerClientEvent('infinite-autospot:swap:cl', src, nil, 3)
                    else
                        TriggerClientEvent('DoLongHudText', src, "I couldn't find the vehicle", 2)
                    end
                else
                    TriggerClientEvent('DoLongHudText', src, "I couldn't find the vehicle", 2)
                end
            end)
        else
            TriggerClientEvent('DoLongHudText', src, "You do not have enough money on you to purchase this vehicle", 2)
        end
    end)
end)

RegisterServerEvent('infinite-autospot-check:sv')
AddEventHandler('infinite-autospot-check:sv', function(cid, price)
    local src = source
    Citizen.Wait(10000)
    local cunt = 0
    while not IsFound do
        Citizen.Wait(1000)
        cunt = cunt + 1
        if cunt >= 10 then
            return
        end
    end
    exports.ghmattimysql:execute('SELECT `cash` FROM characters WHERE id = ?', {tonumber(cid)}, function(result)
        if result[1] ~= nil then
            exports.ghmattimysql:execute("UPDATE characters SET cash = @cash WHERE id = @id", {
                ['@cash'] = tonumber(math.ceil(result[1].cash + price)),
                ['@id'] = cid
            })
        end
    end)
end)

RegisterServerEvent('infinite-autos:pay-customer')
AddEventHandler('infinite-autos:pay-customer', function(cid, cost, plate)
    local src = source
    local user = exports["irp-framework"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    IsFound = true
    if plate ~= nil then
        exports.ghmattimysql:execute('SELECT `license_plate` FROM secondhand_car_stock WHERE license_plate = ?', {plate}, function(result)
            if result[1] ~= nil then
                user:addMoney(cost)
            end
        end)
    else
        DropPlayer(src, 'InfiniteRP Anticheat Has Caught You In 4K') -- reasoning later
    end          
end)

RegisterServerEvent('infinite-autospot:declinevehicle')
AddEventHandler('infinite-autospot:declinevehicle', function(plate)
    local src = source
    exports.ghmattimysql:execute("DELETE FROM secondhand_car_stock WHERE `license_plate` = ?", {plate})
    Citizen.Wait(1000)
    TriggerClientEvent('DoLongHudText', src, "You have declined the vehicle offer!")
    TriggerClientEvent('infinite-autospot:swap:cl', src, nil, 3)
end)

RegisterServerEvent('infinite-autospot:swapveh:sv')
AddEventHandler('infinite-autospot:swapveh:sv', function()
    local src = source
    exports.ghmattimysql:execute('SELECT `model`, `license_plate`, `display` FROM sendhand_cars', function(result)
        if result[1] ~= nil then
            for i = 1, #result do
                if tonumber(result[i].display) ~= 0 then
                    TriggerClientEvent('irp-context:sendMenu', src, {
                        {
                            id = i,
                            header = 'Vehicle Name: ' .. result[i].model .. ' | License Plate: ' .. result[i].license_plate,
                            txt = '> Swap Vehicle',
                            params = {
                                event = "infinite-autospot:swapveh",
                                args = result[i].license_plate,
                                args2 = 1
                            }
                        }
                    })                   
                end
            end
        else
            TriggerClientEvent('DoLongHudText', src, 'You don\'t own any vehicles to switch out yet', 2)
        end
    end)
end)

RegisterServerEvent('infinite-autospot:add-display:vehicle:sv')
AddEventHandler('infinite-autospot:add-display:vehicle:sv', function()
    local src = source
    exports.ghmattimysql:execute('SELECT `model`, `license_plate`, `display` FROM sendhand_cars', function(result)
        if result[1] ~= nil then
            for i = 1, #result do
                if tonumber(result[i].display) ~= 1 then 
                    TriggerClientEvent('irp-context:sendMenu', src, {
                        {
                            id = i,
                            header = 'Vehicle Name: ' .. result[i].model .. ' | License Plate: ' .. result[i].license_plate,
                            txt = '> Add Vehicle',
                            params = {
                                event = "infinite-autospot:adddisplay",
                                args = result[i].license_plate
                            }
                        }
                    })
                end
            end
        end
    end)     
end)

RegisterServerEvent('infinite-autospot:update:db')
AddEventHandler('infinite-autospot:update:db', function(plate)
    local src = source
    exports.ghmattimysql:execute("UPDATE sendhand_cars SET `display` = @display WHERE `license_plate` = @license_plate", {
        ['@license_plate'] = plate,
        ['@display'] = 1,
    })
    Citizen.Wait(100)
    TriggerClientEvent('infinite-autospot:swap:cl', src, nil, 3)
end)

RegisterServerEvent('infinite-autospot:query:swap')
AddEventHandler('infinite-autospot:query:swap', function(plate)
    local src = source
    exports.ghmattimysql:execute('SELECT `model`, `license_plate`, `display` FROM sendhand_cars', function(result)
        for i = 1, #result do
            if result[i].license_plate ~= plate and tonumber(result[i].display) ~= 1 then
                TriggerClientEvent('irp-context:sendMenu', src, {
                    {
                        id = i,
                        header = 'Vehicle Name: ' .. result[i].model .. ' | License Plate: ' .. result[i].license_plate,
                        txt = 'Swap',
                        params = {
                            event = "infinite-autospot:swapveh",
                            args = result[i].license_plate,
                            args2 = 2
                        }
                    }
                })
            end
        end
    end)
end)

RegisterServerEvent('infinite-autospot:actualquery:swap')
AddEventHandler('infinite-autospot:actualquery:swap', function(plateone, platetwo)
    local src = source
    exports.ghmattimysql:execute("UPDATE sendhand_cars SET `display` = @display WHERE `license_plate` = @license_plate", {
        ['@license_plate'] = plateone,
        ['@display'] = 0,
    })
    Citizen.Wait(100)
    exports.ghmattimysql:execute("UPDATE sendhand_cars SET `display` = @display WHERE `license_plate` = @license_plate", {
        ['@license_plate'] = platetwo,
        ['@display'] = 1,
    })
    TriggerClientEvent('infinite-autospot:swap:cl', src, nil, 3)
    TriggerClientEvent('DoLongHudText', src, 'You have successfully switched vehicles')
end)

RegisterServerEvent('infinite-autos:vehicleprice')
AddEventHandler('infinite-autos:vehicleprice', function(value, arg)
    local src = source
    exports.ghmattimysql:execute('SELECT `price` FROM sendhand_cars WHERE `license_plate` = ?', {value}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('infinite-autos:vehicleprice:cl', src, result[1].price, value, arg)
        end
    end)
end)

RegisterServerEvent('infinite-auotspot:sellveh:sv')
AddEventHandler('infinite-auotspot:sellveh:sv', function(plate, playerid)
    -- Person Selling Vehicle    
    local src = source
    local user = exports["irp-framework"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()

    -- Person Buying Vehicle
    local playerid = tonumber(playerid)
    local user2 = exports["irp-framework"]:getModule("Player"):GetUser(playerid)
    local character2 = user2:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT `price` FROM sendhand_cars WHERE `license_plate` = ?', {plate}, function(result)
        if result[1] ~= nil then
            if tonumber(user2:getCash()) >= tonumber(result[1].price) then
                user2:removeMoney(tonumber(result[1].price))
                exports.ghmattimysql:execute("UPDATE characters_cars SET `sale` = @sale, `cid` = @cid WHERE `license_plate` = @license_plate", {
                    ['@license_plate'] = plate,
                    ['@sale'] = 0,
                    ['@cid'] = character2.id,
                })
                Citizen.Wait(100)
                exports.ghmattimysql:execute("DELETE FROM sendhand_cars WHERE `license_plate` = ?", {plate})
                TriggerClientEvent('DoLongHudText', user2.source, 'Congratulations, you have bought a new vehicle for: $' .. result[1].price .. ', thanks for coming to Auto Spot!')
                Citizen.Wait(100)
                TriggerClientEvent('DoLongHudText', user.source, 'You have sold a vehicle for: $' .. result[1].price .. ', good doing business with ya, we have witheld some money tax-wise.')
                Citizen.Wait(1000)
                TriggerClientEvent('infinite-autospot:swap:cl', -1, nil, 3)
            else
                TriggerClientEvent('DoLongHudText', user2.source, 'You do not have enough money on you to purchase this vehicle', 2)
                Citizen.Wait(100)
                TriggerClientEvent('DoLongHudText', user.source, 'Customer does not have enough money to purchase this vehicle', 2)
            end
        else
            TriggerClientEvent('DoLongHudText', src, 'Unable to obtain vehicle', 2)
        end
    end)
end)

RegisterServerEvent('infinite-autospot:edit-price')
AddEventHandler('infinite-autospot:edit-price', function(plate, price)
    local src = source
    exports.ghmattimysql:execute('SELECT `price` FROM sendhand_cars WHERE `license_plate` = ?', {plate}, function(result)
        if result[1] ~= nil then
            exports.ghmattimysql:execute("UPDATE sendhand_cars SET `price` = @price WHERE `license_plate` = @license_plate", {
                ['@license_plate'] = plate,
                ['@price'] = tonumber(price),
            })
            TriggerClientEvent('infinite-autospot:updateui', src, price)
        else
            TriggerClientEvent('DoLongHudText', src, "Failed to find vehicle, please leave area and come back", 2)
        end
    end)
end)

RegisterServerEvent('infinite-autospot:testdrive-vehicle')
AddEventHandler('infinite-autospot:testdrive-vehicle', function(plate, arg)
    local src = source
    exports.ghmattimysql:execute('SELECT `model`, `license_plate`, `data` FROM sendhand_cars WHERE `license_plate` = ?', {plate}, function(vehicles)
        TriggerClientEvent('infinite-autospot:testdrive:cl', src, vehicles[1], arg)
    end)
end)