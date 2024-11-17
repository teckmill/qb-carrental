local QBCore = exports['qb-core']:GetCoreObject()

-- Helper function to create menu items
local function CreateMenuItem(data)
    return {
        header = data.header,
        txt = data.text or "",
        params = {
            event = data.event,
            args = data.args or {}
        }
    }
end

-- Main rental menu
function OpenRentalMenu()
    local menuItems = {
        {
            header = "🚗 Vehicle Rentals",
            isMenuHeader = true
        }
    }

    -- Add category options
    for k, v in pairs(Config.RentalCategories) do
        table.insert(menuItems, CreateMenuItem({
            header = "📋 " .. v.label,
            text = "Deposit Required: $" .. v.deposit,
            event = "qb-carrentals:client:showVehicleMenu",
            args = {
                category = k
            }
        }))
    end

    -- Add close button
    table.insert(menuItems, {
        header = "❌ Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    })

    exports['qb-menu']:openMenu(menuItems)
end

-- Vehicle selection menu
RegisterNetEvent('qb-carrentals:client:showVehicleMenu', function(data)
    local category = Config.RentalCategories[data.category]
    local menuItems = {
        {
            header = "← Go Back",
            txt = "Return to categories",
            params = {
                event = "qb-carrentals:client:openMainMenu"
            }
        }
    }

    -- Add vehicle options
    for _, vehicle in ipairs(category.vehicles) do
        table.insert(menuItems, CreateMenuItem({
            header = vehicle.label,
            text = "Price: $" .. vehicle.price .. " | Deposit: $" .. category.deposit,
            event = "qb-carrentals:client:showDurationMenu",
            args = {
                vehicle = vehicle.model,
                price = vehicle.price,
                deposit = category.deposit
            }
        }))
    end

    exports['qb-menu']:openMenu(menuItems)
end)

-- Duration selection menu
RegisterNetEvent('qb-carrentals:client:showDurationMenu', function(data)
    local menuItems = {
        {
            header = "← Go Back",
            txt = "Return to vehicle selection",
            params = {
                event = "qb-carrentals:client:showVehicleMenu"
            }
        }
    }

    -- Add duration options
    for _, duration in ipairs(Config.RentalDurations) do
        local totalPrice = data.price * duration.hours
        table.insert(menuItems, CreateMenuItem({
            header = duration.label,
            text = "Total: $" .. totalPrice .. " + $" .. data.deposit .. " deposit",
            event = "qb-carrentals:client:rentVehicle",
            args = {
                vehicle = data.vehicle,
                price = totalPrice,
                deposit = data.deposit,
                duration = duration.hours
            }
        }))
    end

    exports['qb-menu']:openMenu(menuItems)
end)

-- Return to main menu
RegisterNetEvent('qb-carrentals:client:openMainMenu', function()
    OpenRentalMenu()
end)
