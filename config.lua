Config = {}

-- Admin job or ace group (set job to nil to use ace groups)
Config.AdminJob = 'admin' -- set to your admin job name or nil
Config.UseACE = false -- set true to use ACE instead
Config.ACEGroup = 'group.admin'

-- DB settings
Config.UseMySQL = true -- requires oxmysql

-- Default categories
Config.Categories = {
    { id = 'sports', label = 'Sports' },
    { id = 'super', label = 'Super' },
    { id = 'suv', label = 'SUV' },
    { id = 'sedan', label = 'Sedan' },
}

-- Keybinds
Config.KeyToOpenCreator = 'E' -- key when in creator marker

-- Blip
Config.DefaultBlip = { sprite = 523, color = 3, scale = 0.8, text = 'Vehicle Shop' }

-- Test drive settings
Config.TestDrive = {
    enabled = true,
    duration = 120000 -- ms (2 minutes)
}

-- Vehicle preview settings
Config.Preview = {
    headingRotationSpeed = 0.5
}

-- SQL table name
Config.TableName = 'vehicleshop_shops'

-- Rate limiting for server creation events (ms)
Config.RateLimit = 5000

-- Default spawn offset from shop coords
Config.SpawnOffset = vector3(2.0, 2.0, 0.0)

-- QBCore plate format
Config.PlateFormat = 'SHOP%03d'

-- Example vehicles (you can modify or expand)
Config.ExampleVehicles = {
    { model = 'comet2', name = 'Comet S2', price = 75000, category = 'sports' },
    { model = 'adder', name = 'Adder', price = 1000000, category = 'super' },
    { model = 'fq2', name = 'FQ 2', price = 12000, category = 'suv' },
    { model = 'tailgater', name = 'Tailgater', price = 45000, category = 'sedan' },
}
