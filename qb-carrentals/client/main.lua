local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local activeRentals = {}
local rentalBlips = {}

-- Debug function
local function Debug(message)
    if Config.Debug then
        print('^3[qb-carrentals] ^7' .. message)
    end
end

-- Generate rental plate
local function GenerateRentalPlate()
    local plate = 'RENT' .. math.random(1000, 9999)
    Debug('Generated plate: ' .. plate)
    return plate
end

-- Create blips for rental and return locations
local function CreateLocationBlips()
    Debug('Creating location blips')
    
    -- Create rental location blips
    for k, v in pairs(Config.RentalLocations) do
        -- Rental location blip
        local rentalBlip = AddBlipForCoord(v.rental.coords.x, v.rental.coords.y, v.rental.coords.z)
        SetBlipSprite(rentalBlip, v.rental.blipId or 226)
        SetBlipDisplay(rentalBlip, 4)
        SetBlipScale(rentalBlip, v.rental.blipScale or 0.7)
        SetBlipColour(rentalBlip, v.rental.blipColor or 3)
        SetBlipAsShortRange(rentalBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.rental.label or "Vehicle Rental")
        EndTextCommandSetBlipName(rentalBlip)
        table.insert(rentalBlips, rentalBlip)
        
        -- Return location blip
        if v.return_location and v.return_location.coords then
            local returnBlip = AddBlipForCoord(v.return_location.coords.x, v.return_location.coords.y, v.return_location.coords.z)
            SetBlipSprite(returnBlip, 225)
            SetBlipDisplay(returnBlip, 4)
            SetBlipScale(returnBlip, 0.7)
            SetBlipColour(returnBlip, 1)
            SetBlipAsShortRange(returnBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Return Rental Vehicle")
            EndTextCommandSetBlipName(returnBlip)
            table.insert(rentalBlips, returnBlip)
        end
    end
    
    -- Create return-only location blips
    if Config.ReturnLocations then
        for _, coords in pairs(Config.ReturnLocations) do
            local returnBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(returnBlip, 225)
            SetBlipDisplay(returnBlip, 4)
            SetBlipScale(returnBlip, 0.7)
            SetBlipColour(returnBlip, 1)
            SetBlipAsShortRange(returnBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Return Rental Vehicle")
            EndTextCommandSetBlipName(returnBlip)
            table.insert(rentalBlips, returnBlip)
        end
    end
end

-- Create rental locations with qb-target
CreateThread(function()
    for k, v in pairs(Config.RentalLocations) do
        local coords = v.rental.coords
        
        -- Create target zone for rental location
        exports['qb-target']:AddBoxZone(
            'rental_' .. k,
            vector3(coords.x, coords.y, coords.z),
            2.0, 2.0,
            {
                name = 'rental_' .. k,
                heading = v.rental.heading or 0.0,
                debugPoly = Config.Debug,
                minZ = coords.z - 1.0,
                maxZ = coords.z + 1.0
            },
            {
                options = {
                    {
                        type = 'client',
                        event = 'qb-carrentals:client:openMenu',
                        icon = 'fas fa-car',
                        label = 'Rent Vehicle'
                    }
                },
                distance = 2.5
            }
        )

        -- Create return target zone
        if v.return_location and v.return_location.coords then
            local returnCoords = v.return_location.coords
            exports['qb-target']:AddBoxZone(
                'return_' .. k,
                vector3(returnCoords.x, returnCoords.y, returnCoords.z),
                3.0, 3.0,
                {
                    name = 'return_' .. k,
                    heading = v.return_location.heading or 0.0,
                    debugPoly = Config.Debug,
                    minZ = returnCoords.z - 1.0,
                    maxZ = returnCoords.z + 1.0
                },
                {
                    options = {
                        {
                            type = 'client',
                            event = 'qb-carrentals:client:returnVehicle',
                            icon = 'fas fa-undo',
                            label = 'Return Rental Vehicle'
                        }
                    },
                    distance = 3.0
                }
            )
        end
    end

    -- Create additional return-only locations if configured
    if Config.ReturnLocations then
        for k, coords in pairs(Config.ReturnLocations) do
            exports['qb-target']:AddBoxZone(
                'return_extra_' .. k,
                vector3(coords.x, coords.y, coords.z),
                3.0, 3.0,
                {
                    name = 'return_extra_' .. k,
                    heading = coords.w or 0.0,
                    debugPoly = Config.Debug,
                    minZ = coords.z - 1.0,
                    maxZ = coords.z + 1.0
                },
                {
                    options = {
                        {
                            type = 'client',
                            event = 'qb-carrentals:client:returnVehicle',
                            icon = 'fas fa-undo',
                            label = 'Return Rental Vehicle'
                        }
                    },
                    distance = 3.0
                }
            )
        end
    end
end)

-- Draw floating indicators for rental and return locations
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        
        -- Rental location indicators
        for _, v in pairs(Config.RentalLocations) do
            -- Rental point indicator
            local rentalCoords = v.rental.coords
            local rentalDist = #(pos - vector3(rentalCoords.x, rentalCoords.y, rentalCoords.z))
            
            if rentalDist < 30.0 then
                sleep = 0
                DrawMarker(36, -- Car icon marker
                    rentalCoords.x, 
                    rentalCoords.y, 
                    rentalCoords.z + 1.0, 
                    0.0, 0.0, 0.0, 
                    0.0, 0.0, 0.0, 
                    1.0, 1.0, 1.0, 
                    0, 122, 255, 100, -- Light blue color
                    false, true, 2, nil, nil, false
                )
            end
            
            -- Return point indicator
            if v.return_location and v.return_location.coords then
                local returnCoords = v.return_location.coords
                local returnDist = #(pos - vector3(returnCoords.x, returnCoords.y, returnCoords.z))
                
                if returnDist < 30.0 then
                    sleep = 0
                    DrawMarker(36, -- Car icon marker
                        returnCoords.x, 
                        returnCoords.y, 
                        returnCoords.z + 1.0, 
                        0.0, 0.0, 0.0, 
                        0.0, 0.0, 0.0, 
                        1.0, 1.0, 1.0, 
                        255, 0, 0, 100, -- Red color for return
                        false, true, 2, nil, nil, false
                    )
                end
            end
        end
        
        -- Additional return-only location indicators
        if Config.ReturnLocations then
            for _, coords in pairs(Config.ReturnLocations) do
                local dist = #(pos - vector3(coords.x, coords.y, coords.z))
                
                if dist < 30.0 then
                    sleep = 0
                    DrawMarker(36, -- Car icon marker
                        coords.x, 
                        coords.y, 
                        coords.z + 1.0, 
                        0.0, 0.0, 0.0, 
                        0.0, 0.0, 0.0, 
                        1.0, 1.0, 1.0, 
                        255, 0, 0, 100, -- Red color for return
                        false, true, 2, nil, nil, false
                    )
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Open rental menu
local function OpenRentalMenu()
    Debug('Opening rental menu')
    local categories = {}
    
    -- Convert config categories to format expected by NUI
    if Config.Categories then
        for k, v in pairs(Config.Categories) do
            categories[#categories + 1] = {
                name = k,
                label = v.label,
                description = v.description or ""
            }
        end
    else
        Debug('No vehicle categories found in Config.Categories!')
        return
    end
    
    -- Get loyalty data from server
    QBCore.Functions.TriggerCallback('qb-carrentals:server:getLoyaltyData', function(loyaltyData)
        Debug('Opening menu with loyalty data: ' .. json.encode(loyaltyData))
        -- Send data to NUI
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openMenu",
            categories = categories,
            loyalty = loyaltyData
        })
    end)
end

-- Spawn rental vehicle
local function SpawnRentalVehicle(data)
    Debug('Spawn data received: ' .. json.encode(data))
    
    -- Get location data
    local locationId = 1 -- Default to first location if not specified
    local location = Config.RentalLocations[locationId]
    if not location then 
        QBCore.Functions.Notify('Invalid rental location!', 'error')
        return 
    end
    
    -- Get vehicle data
    local model = data.vehicle
    if not model then
        QBCore.Functions.Notify('Invalid vehicle model!', 'error')
        return
    end
    
    -- Load the model
    QBCore.Functions.LoadModel(model)
    
    local spawnCoords = location.spawn.coords
    local heading = location.spawn.heading
    local plate = GenerateRentalPlate()
    
    Debug('Attempting to spawn vehicle: ' .. model)
    Debug('At coordinates: ' .. json.encode(spawnCoords))
    
    QBCore.Functions.SpawnVehicle(model, function(vehicle)
        if not vehicle or vehicle == 0 then
            QBCore.Functions.Notify('Failed to spawn vehicle!', 'error')
            return
        end
        
        SetEntityHeading(vehicle, heading)
        SetVehicleNumberPlateText(vehicle, plate)
        exports['LegacyFuel']:SetFuel(vehicle, 100.0)
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
        SetVehicleEngineOn(vehicle, false, false, true)
        
        -- Set as rental vehicle
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDirtLevel(vehicle, 0.0)
        
        -- Store rental data
        activeRentals[plate] = {
            vehicle = vehicle,
            model = model,
            price = data.totalPrice,
            deposit = data.deposit,
            insurance = data.insurance,
            startTime = GetGameTimer(),
            duration = data.duration * 24 * 60 * 60 * 1000 -- Convert days to milliseconds
        }
        
        -- Process rental payment and data
        TriggerServerEvent('qb-carrentals:server:rentVehicle', {
            plate = plate,
            price = data.totalPrice,
            deposit = data.deposit,
            insurance = data.insurance,
            duration = data.duration
        })
        
        Debug('Vehicle spawned successfully with plate: ' .. plate)
        QBCore.Functions.Notify('Vehicle rented successfully! Plate: ' .. plate, 'success')
        
        -- Teleport player into vehicle
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end, spawnCoords, true)
end

-- NUI Callbacks
RegisterNUICallback('closeMenu', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('getVehicles', function(data, cb)
    local category = data.category
    local vehicles = {}
    
    if Config.Categories and Config.Categories[category] then
        for model, vehicle in pairs(Config.Categories[category].vehicles) do
            vehicles[#vehicles + 1] = {
                model = model,
                name = vehicle.label,
                price = vehicle.price,
                deposit = vehicle.deposit
            }
        end
    end
    
    cb(vehicles)
end)

RegisterNUICallback('rentVehicle', function(data)
    SetNuiFocus(false, false)
    SpawnRentalVehicle(data)
end)

-- Events
RegisterNetEvent('qb-carrentals:client:openMenu', function()
    OpenRentalMenu()
end)

RegisterNetEvent('qb-carrentals:client:returnVehicle', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then 
        QBCore.Functions.Notify('You must be in a vehicle!', 'error')
        return
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    if not activeRentals[plate] then
        QBCore.Functions.Notify('This is not a rental vehicle!', 'error')
        return
    end
    
    -- Calculate rental duration and damage
    local rentalData = activeRentals[plate]
    local currentTime = GetGameTimer()
    local rentalDuration = currentTime - rentalData.startTime
    local vehicleHealth = GetVehicleBodyHealth(vehicle)
    local damagePercent = (1000 - vehicleHealth) / 10
    
    -- Process return with server
    TriggerServerEvent('qb-carrentals:server:returnVehicle', {
        plate = plate,
        damage = damagePercent,
        insurance = rentalData.insurance,
        duration = rentalDuration
    })
    
    -- Delete vehicle and clean up
    DeleteVehicle(vehicle)
    activeRentals[plate] = nil
end)

-- Initialize
CreateThread(function()
    CreateLocationBlips()
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Remove blips
        for _, blip in pairs(rentalBlips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
        
        -- Remove active rentals
        for plate, data in pairs(activeRentals) do
            if DoesEntityExist(data.vehicle) then
                DeleteVehicle(data.vehicle)
            end
        end
    end
end)
