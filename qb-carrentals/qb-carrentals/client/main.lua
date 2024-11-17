-- Near line 128, make sure OpenRentalMenu is defined
local function OpenRentalMenu()
    -- Add your menu opening logic here
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openRental",
        -- Add any other data you need to send to the NUI
    })
end

-- Around line 848, ensure the rental object exists before accessing it
-- Add this check before accessing rental
if not rental then
    rental = {}  -- or initialize it with proper default values
end
rental.someField = someValue  -- Replace with actual field access

-- Around line 870, similar fix
if not rental then
    rental = {}  -- or initialize it with proper default values
end
rental.someOtherField = someOtherValue  -- Replace with actual field access 