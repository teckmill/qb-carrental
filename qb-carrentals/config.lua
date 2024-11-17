Config = {}

Config.Debug = false

-- Additional return-only locations
Config.ReturnLocations = {
    -- Los Santos
    vector4(55.12, -876.45, 30.66, 340.29),      -- Legion Square Parking
    vector4(-339.53, -751.32, 33.97, 180.89),    -- Los Santos Customs
    vector4(401.41, -1631.66, 29.29, 230.47),    -- Davis Parking
    vector4(110.31, -1090.05, 29.29, 270.0),     -- PDM Parking
    vector4(-1184.37, -1509.88, 4.37, 120.78),   -- LSIA Parking
    vector4(-795.96, -2022.65, 9.17, 225.14),    -- LSIA Terminal
    
    -- Paleto & North
    vector4(-17.01, 6323.06, 31.37, 224.86),     -- Paleto Gas Station
    vector4(1695.24, 4785.98, 41.92, 91.28),     -- Sandy Gas Station
    vector4(2588.74, 428.62, 108.46, 92.47),     -- Highway Gas Station
    
    -- East Los Santos
    vector4(1148.78, -789.35, 57.59, 359.24),    -- Mirror Park
    vector4(818.11, -1067.74, 28.19, 274.23),    -- La Mesa
    
    -- West Los Santos
    vector4(-2030.01, -465.97, 11.6, 319.65),    -- Del Perro Beach
    vector4(-1604.04, -831.45, 10.08, 318.94),   -- Vespucci Beach
    
    -- Vinewood & Hills
    vector4(638.7, 206.42, 97.24, 249.21),       -- Vinewood Plaza
    vector4(-681.47, 916.37, 232.09, 103.28)     -- Vinewood Hills
}

Config.RentalLocations = {
    [1] = {
        rental = {
            coords = vector3(-279.67, -888.96, 31.08),
            label = "Premium Car Rentals",
            blipId = 226,
            blipColor = 3,
            blipScale = 0.7
        },
        spawn = {
            coords = vector3(-283.85, -887.41, 31.08),
            heading = 168.97
        },
        return_location = {
            coords = vector3(-283.85, -887.41, 31.08),
            heading = 168.97
        }
    },
    [2] = {
        rental = {
            coords = vector3(-1034.69, -2733.71, 20.17),
            label = "Airport Rentals",
            blipId = 226,
            blipColor = 3,
            blipScale = 0.7
        },
        spawn = {
            coords = vector3(-1030.01, -2732.09, 20.17),
            heading = 237.75
        },
        return_location = {
            coords = vector3(-1023.96, -2732.27, 20.17),
            heading = 237.75
        }
    },
    [3] = {
        rental = {
            coords = vector3(1691.89, 3288.95, 41.15),
            label = "Sandy Shores Rentals",
            blipId = 226,
            blipColor = 3,
            blipScale = 0.7
        },
        spawn = {
            coords = vector3(1695.95, 3283.95, 41.15),
            heading = 37.09
        },
        return_location = {
            coords = vector3(1699.01, 3291.55, 41.15),
            heading = 37.09
        }
    },
    [4] = {
        rental = {
            coords = vector3(361.21, 275.87, 103.11),
            label = "Vinewood Rentals",
            blipId = 226,
            blipColor = 3,
            blipScale = 0.7
        },
        spawn = {
            coords = vector3(364.81, 270.71, 102.65),
            heading = 247.31
        },
        return_location = {
            coords = vector3(370.12, 284.75, 102.55),
            heading = 247.31
        }
    }
}

Config.Categories = {
    ["economy"] = {
        label = "Economy",
        vehicles = {
            ["asea"] = {
                label = "Asea",
                price = 150,
                deposit = 150,
                fuel_capacity = 45
            },
            ["blista"] = {
                label = "Blista",
                price = 175,
                deposit = 175,
                fuel_capacity = 40
            },
            ["dilettante"] = {
                label = "Dilettante",
                price = 125,
                deposit = 125,
                fuel_capacity = 35
            },
            ["prairie"] = {
                label = "Prairie",
                price = 165,
                deposit = 165,
                fuel_capacity = 42
            },
            ["rhapsody"] = {
                label = "Rhapsody",
                price = 145,
                deposit = 145,
                fuel_capacity = 38
            }
        }
    },
    ["compact"] = {
        label = "Compact",
        vehicles = {
            ["issi2"] = {
                label = "Issi",
                price = 200,
                deposit = 200,
                fuel_capacity = 35
            },
            ["panto"] = {
                label = "Panto",
                price = 185,
                deposit = 185,
                fuel_capacity = 30
            },
            ["brioso"] = {
                label = "Brioso R/A",
                price = 225,
                deposit = 225,
                fuel_capacity = 32
            },
            ["club"] = {
                label = "Club",
                price = 215,
                deposit = 215,
                fuel_capacity = 34
            },
            ["weevil"] = {
                label = "Weevil",
                price = 195,
                deposit = 195,
                fuel_capacity = 33
            }
        }
    },
    ["sedan"] = {
        label = "Sedan",
        vehicles = {
            ["emperor"] = {
                label = "Emperor",
                price = 250,
                deposit = 250,
                fuel_capacity = 55
            },
            ["fugitive"] = {
                label = "Fugitive",
                price = 275,
                deposit = 275,
                fuel_capacity = 60
            },
            ["tailgater"] = {
                label = "Tailgater",
                price = 300,
                deposit = 300,
                fuel_capacity = 65
            },
            ["washington"] = {
                label = "Washington",
                price = 265,
                deposit = 265,
                fuel_capacity = 58
            },
            ["schafter"] = {
                label = "Schafter",
                price = 325,
                deposit = 325,
                fuel_capacity = 70
            }
        }
    },
    ["sport"] = {
        label = "Sports",
        vehicles = {
            ["ninef"] = {
                label = "9F",
                price = 500,
                deposit = 1000,
                fuel_capacity = 80
            },
            ["banshee"] = {
                label = "Banshee",
                price = 450,
                deposit = 900,
                fuel_capacity = 75
            },
            ["carbonizzare"] = {
                label = "Carbonizzare",
                price = 525,
                deposit = 1050,
                fuel_capacity = 82
            },
            ["comet2"] = {
                label = "Comet",
                price = 475,
                deposit = 950,
                fuel_capacity = 78
            },
            ["elegy"] = {
                label = "Elegy RH8",
                price = 485,
                deposit = 970,
                fuel_capacity = 76
            },
            ["feltzer2"] = {
                label = "Feltzer",
                price = 495,
                deposit = 990,
                fuel_capacity = 79
            }
        }
    },
    ["muscle"] = {
        label = "Muscle",
        vehicles = {
            ["dominator"] = {
                label = "Dominator",
                price = 400,
                deposit = 800,
                fuel_capacity = 75
            },
            ["gauntlet"] = {
                label = "Gauntlet",
                price = 385,
                deposit = 770,
                fuel_capacity = 72
            },
            ["phoenix"] = {
                label = "Phoenix",
                price = 375,
                deposit = 750,
                fuel_capacity = 70
            },
            ["ruiner"] = {
                label = "Ruiner",
                price = 390,
                deposit = 780,
                fuel_capacity = 73
            },
            ["vigero"] = {
                label = "Vigero",
                price = 380,
                deposit = 760,
                fuel_capacity = 71
            }
        }
    },
    ["suv"] = {
        label = "SUV",
        vehicles = {
            ["baller"] = {
                label = "Baller",
                price = 400,
                deposit = 400,
                fuel_capacity = 85
            },
            ["granger"] = {
                label = "Granger",
                price = 425,
                deposit = 425,
                fuel_capacity = 90
            },
            ["dubsta"] = {
                label = "Dubsta",
                price = 450,
                deposit = 450,
                fuel_capacity = 95
            },
            ["huntley"] = {
                label = "Huntley S",
                price = 475,
                deposit = 475,
                fuel_capacity = 88
            },
            ["landstalker"] = {
                label = "Landstalker",
                price = 415,
                deposit = 415,
                fuel_capacity = 87
            }
        }
    },
    ["van"] = {
        label = "Vans",
        vehicles = {
            ["minivan"] = {
                label = "Minivan",
                price = 300,
                deposit = 300,
                fuel_capacity = 75
            },
            ["paradise"] = {
                label = "Paradise",
                price = 275,
                deposit = 275,
                fuel_capacity = 70
            },
            ["rumpo"] = {
                label = "Rumpo",
                price = 325,
                deposit = 325,
                fuel_capacity = 80
            },
            ["speedo"] = {
                label = "Speedo",
                price = 290,
                deposit = 290,
                fuel_capacity = 72
            },
            ["surfer"] = {
                label = "Surfer",
                price = 250,
                deposit = 250,
                fuel_capacity = 65
            }
        }
    },
    ["offroad"] = {
        label = "Off-Road",
        vehicles = {
            ["bifta"] = {
                label = "Bifta",
                price = 350,
                deposit = 350,
                fuel_capacity = 55
            },
            ["bodhi2"] = {
                label = "Bodhi",
                price = 325,
                deposit = 325,
                fuel_capacity = 60
            },
            ["brawler"] = {
                label = "Brawler",
                price = 400,
                deposit = 400,
                fuel_capacity = 70
            },
            ["rebel2"] = {
                label = "Rebel",
                price = 375,
                deposit = 375,
                fuel_capacity = 65
            },
            ["sandking"] = {
                label = "Sandking",
                price = 425,
                deposit = 425,
                fuel_capacity = 75
            }
        }
    }
}

Config.RentalDurations = {
    [1] = {
        label = "1 Hour",
        time = 60,
        discount = 0
    },
    [2] = {
        label = "4 Hours",
        time = 240,
        discount = 10
    },
    [3] = {
        label = "8 Hours",
        time = 480,
        discount = 20
    }
}

Config.RentalBenefits = {
    ["insurance"] = {
        label = "Insurance",
        description = "Covers 50% of damage costs",
        price = 150
    },
    ["fuel"] = {
        label = "Fuel Package",
        description = "Full tank of gas included",
        price = 100
    }
}

-- Insurance Options
Config.Insurance = {
    none = {
        label = "No Insurance",
        price_multiplier = 0,
        damage_coverage = 0,
        description = "No coverage for vehicle damage"
    },
    basic = {
        label = "Basic Insurance",
        price_multiplier = 0.15, -- 15% of rental price
        damage_coverage = 0.5, -- 50% of damage costs covered
        description = "Basic coverage for vehicle damage"
    },
    premium = {
        label = "Premium Insurance",
        price_multiplier = 0.25, -- 25% of rental price
        damage_coverage = 1.0, -- 100% of damage costs covered
        description = "Full coverage for all vehicle damage"
    }
}

-- Loyalty Program
Config.LoyaltyProgram = {
    enabled = true,
    points_per_rental = 10,
    points_per_dollar = 0.1,
    discount_tiers = {
        {
            points_required = 100,
            discount = 0.05 -- 5% discount
        },
        {
            points_required = 250,
            discount = 0.10 -- 10% discount
        },
        {
            points_required = 500,
            discount = 0.15 -- 15% discount
        }
    }
}

-- Extended Rental Options
Config.ExtendedRental = {
    max_extensions = 3,
    extension_fee_multiplier = 0.1 -- 10% fee for extending rental
}

-- Special Discounts
Config.Discounts = {
    new_customer = {
        enabled = true,
        discount = 0.10 -- 10% off first rental
    },
    weekly_special = {
        enabled = true,
        vehicle_type = "random", -- Randomly selected vehicle type gets discount
        discount = 0.20 -- 20% off
    },
    bulk_rental = {
        enabled = true,
        days_required = 7,
        discount = 0.15 -- 15% off rentals 7 days or longer
    }
}

-- Vehicle Condition Tracking
Config.VehicleCondition = {
    check_interval = 60000, -- Check every minute
    damage_thresholds = {
        minor = 900, -- Minor damage below 900 health
        moderate = 700, -- Moderate damage below 700 health
        severe = 400 -- Severe damage below 400 health
    },
    maintenance_cost = {
        minor = 100,
        moderate = 250,
        severe = 500
    }
}

if Config.Debug then
    print('Config loaded successfully')
    print('Number of rental locations: ' .. #Config.RentalLocations)
end
