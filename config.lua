Config = {}

-- Maximum inventory slots for players (inventory slots)
Config.max_inventory_slots = 41

Config.clothingScript = 'qb-clothing' -- illenium-appearance or qb-clothing oe esx (skinchanger)
-- When set to skinchanger, it only supports 'bag' as a clothing option and nothing else!

-- Default durations (in seconds)
Config.duration = {
     open = 1,    -- Time to open a bag
     lockpick = 5 -- Time to lockpick a bag
}

-- Prevent players from carrying multiple backpacks
-- They will stuck in one place until they put the extra bags away
Config.notAllowedToCarryMultipleBackpacks = true
-- Maximum allowed backpacks per player
Config.maxAllowedBackpacks = 2

-- Whitelist for lockpicking access
Config.lockpick_whitelist = {
     active = true,
     jobs = { 'police' }, -- Jobs with lockpicking access
     citizenid = {}
}

-- Backpack configurations
Config.Bags = {
     {
          item = 'backpack1',
          slots = 15,
          size = 100000,
          cloth = {
               male = {
                    ["bag"] = { item = 36, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 1, texture = 0 }
               }
          },
          -- If active, the backpack only accepts items listed here and returns other items to the player
          whitelist = {
               'iron',
               'steel'
          },
          duration = {
               opening = 1,
               lockpicking = 5
          }
     },
     {
          item = 'backpack2',
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 36, texture = 1 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
          -- If active, the backpack accepts all items except those listed here
          blacklist = {
               'water',
               'steel'
          }
     },
     {
          item = 'duffle1',
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 82, texture = 4 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               }
          }
     },
     {
          item = 'paramedicbag',
          slots = 10,
          size = 50000,
          prop = GetProp('paramedicbag') -- Use props from shared/props.lua
     },
     {
          item = 'briefcase',
          slots = 5,
          size = 10000,
          locked = true,
          prop = GetProp('suitcase2') -- Use props from shared/props.lua
     },
     {
          item = 'policepouches',
          slots = 6,
          size = 200000,
          cloth = {
               male = {
                    ["accessory"] = { item = 146, texture = 0 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               }
          }
     },
     {
          item = 'policepouches1',
          slots = 12,
          size = 400000,
          cloth = {
               male = {
                    ["accessory"] = { item = 147, texture = 0 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               }
          }
     }
}
