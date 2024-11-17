local QBCore = exports['qb-core']:GetCoreObject()

-- Active rentals table
local activeRentals = {}

-- Debug function
local function Debug(message)
    if Config.Debug then
        print('^3[qb-carrentals] ^7' .. message)
    end
end

-- Initialize player loyalty data
local playerLoyalty = {}

local function InitializePlayerLoyalty(citizenid)
    if not playerLoyalty[citizenid] then
        playerLoyalty[citizenid] = {
            points = 0,
            total_rentals = 0,
            lifetime_spent = 0
        }
    end
end

-- Calculate loyalty discount
local function CalculateLoyaltyDiscount(citizenid)
    if not Config.LoyaltyProgram.enabled then return 0 end
    
    local points = playerLoyalty[citizenid].points
    local discount = 0
    
    for _, tier in ipairs(Config.LoyaltyProgram.discount_tiers) do
        if points >= tier.points_required then
            discount = tier.discount
        end
    end
    
    return discount
end

-- Calculate special discounts
local function CalculateSpecialDiscounts(citizenid, duration, vehicle_type)
    local discount = 0
    
    -- New customer discount
    if Config.Discounts.new_customer.enabled and playerLoyalty[citizenid].total_rentals == 0 then
        discount = math.max(discount, Config.Discounts.new_customer.discount)
    end
    
    -- Weekly special
    if Config.Discounts.weekly_special.enabled and Config.Discounts.weekly_special.vehicle_type == vehicle_type then
        discount = math.max(discount, Config.Discounts.weekly_special.discount)
    end
    
    -- Bulk rental discount
    if Config.Discounts.bulk_rental.enabled and duration >= Config.Discounts.bulk_rental.days_required then
        discount = math.max(discount, Config.Discounts.bulk_rental.discount)
    end
    
    return discount
end

-- Add loyalty points
local function AddLoyaltyPoints(citizenid, rentalPrice)
    if not Config.LoyaltyProgram.enabled then return end
    
    local points = Config.LoyaltyProgram.points_per_rental
    points = points + (rentalPrice * Config.LoyaltyProgram.points_per_dollar)
    
    playerLoyalty[citizenid].points = playerLoyalty[citizenid].points + math.floor(points)
    playerLoyalty[citizenid].total_rentals = playerLoyalty[citizenid].total_rentals + 1
    playerLoyalty[citizenid].lifetime_spent = playerLoyalty[citizenid].lifetime_spent + rentalPrice
end

-- Process rental damage
local function ProcessRentalDamage(source, plate, damageAmount)
    local rental = activeRentals[plate]
    if not rental then return 0 end
    
    local insuranceCoverage = Config.Insurance[rental.insurance].damage_coverage
    local finalDamage = damageAmount * (1 - insuranceCoverage)
    
    return finalDamage
end

-- Extend rental duration
local function ExtendRental(source, plate, additionalDuration)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local rental = activeRentals[plate]
    if not rental then 
        TriggerClientEvent('QBCore:Notify', source, 'Vehicle not found in rental system', 'error')
        return false 
    end
    
    if rental.extensions >= Config.ExtendedRental.max_extensions then
        TriggerClientEvent('QBCore:Notify', source, 'Maximum extensions reached for this rental', 'error')
        return false
    end
    
    local extensionFee = rental.basePrice * Config.ExtendedRental.extension_fee_multiplier
    if Player.Functions.RemoveMoney('bank', extensionFee) then
        rental.duration = rental.duration + additionalDuration
        rental.extensions = rental.extensions + 1
        TriggerClientEvent('QBCore:Notify', source, 'Rental extended successfully', 'success')
        return true
    else
        TriggerClientEvent('QBCore:Notify', source, 'Insufficient funds for rental extension', 'error')
        return false
    end
end

-- Register server callbacks
QBCore.Functions.CreateCallback('qb-carrentals:server:getLoyaltyInfo', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(nil) end
    
    InitializePlayerLoyalty(Player.PlayerData.citizenid)
    cb(playerLoyalty[Player.PlayerData.citizenid])
end)

QBCore.Functions.CreateCallback('qb-carrentals:server:getLoyaltyData', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return cb({}) end

    local citizenid = Player.PlayerData.citizenid
    InitializePlayerLoyalty(citizenid)
    
    local data = {
        points = playerLoyalty[citizenid].points,
        total_rentals = playerLoyalty[citizenid].total_rentals,
        lifetime_spent = playerLoyalty[citizenid].lifetime_spent,
        discount = CalculateLoyaltyDiscount(citizenid)
    }
    
    Debug('Sending loyalty data for ' .. citizenid .. ': ' .. json.encode(data))
    cb(data)
end)

-- Process rental
RegisterNetEvent('qb-carrentals:server:rentVehicle', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    InitializePlayerLoyalty(Player.PlayerData.citizenid)
    
    -- Calculate discounts
    local loyaltyDiscount = CalculateLoyaltyDiscount(Player.PlayerData.citizenid)
    local specialDiscount = CalculateSpecialDiscounts(Player.PlayerData.citizenid, data.duration, data.vehicle_type)
    local totalDiscount = math.max(loyaltyDiscount, specialDiscount)
    
    -- Calculate final price with insurance
    local insuranceMultiplier = 1 + (Config.Insurance[data.insurance or 'none'].price_multiplier or 0)
    local finalPrice = data.price * insuranceMultiplier * (1 - totalDiscount)
    
    if Player.Functions.RemoveMoney('bank', finalPrice) then
        -- Store rental data
        local rentalData = {
            citizenid = Player.PlayerData.citizenid,
            vehicle = data.vehicle,
            basePrice = data.price,
            insurance = data.insurance or 'none',
            startTime = os.time(),
            duration = data.duration or 1,
            extensions = 0,
            deposit = data.deposit or 0
        }
        
        activeRentals[data.plate] = rentalData
        Debug('New rental created - Plate: ' .. data.plate)
        
        -- Add loyalty points
        AddLoyaltyPoints(Player.PlayerData.citizenid, finalPrice)
        
        -- Notify client
        TriggerClientEvent('QBCore:Notify', src, 'Vehicle rented successfully', 'success')
        TriggerClientEvent('qb-carrentals:client:rentalSuccess', src, data.plate, rentalData)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Insufficient funds', 'error')
    end
end)

-- Check if vehicle is a rental
QBCore.Functions.CreateCallback('qb-carrentals:server:checkRental', function(source, cb, plate)
    Debug('Checking rental status for plate: ' .. plate)
    if activeRentals[plate] then
        cb(true, activeRentals[plate])
    else
        cb(false, nil)
    end
end)

-- Return rental vehicle
RegisterNetEvent('qb-carrentals:server:returnVehicle', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local plate = data.plate
    Debug('Processing return for plate: ' .. plate)
    
    if not activeRentals[plate] then
        TriggerClientEvent('QBCore:Notify', src, 'This is not a rental vehicle!', 'error')
        return
    end
    
    local rental = activeRentals[plate]
    if rental.citizenid ~= Player.PlayerData.citizenid then
        TriggerClientEvent('QBCore:Notify', src, 'You did not rent this vehicle!', 'error')
        return
    end
    
    -- Process damage charges
    local damageCharge = ProcessRentalDamage(src, plate, data.damage)
    if damageCharge > 0 then
        Player.Functions.RemoveMoney('bank', damageCharge)
        TriggerClientEvent('QBCore:Notify', src, 'Damage charges: $' .. damageCharge, 'error')
    end
    
    -- Return deposit if applicable
    if rental.deposit and rental.deposit > 0 then
        local refundAmount = rental.deposit - damageCharge
        if refundAmount > 0 then
            Player.Functions.AddMoney('bank', refundAmount)
            TriggerClientEvent('QBCore:Notify', src, 'Deposit refunded: $' .. refundAmount, 'success')
        end
    end
    
    -- Clear rental data
    activeRentals[plate] = nil
    TriggerClientEvent('QBCore:Notify', src, 'Vehicle returned successfully', 'success')
    Debug('Rental cleared for plate: ' .. plate)
end)

RegisterNetEvent('qb-carrentals:server:extendRental', function(data)
    ExtendRental(source, data.plate, data.duration)
end)
