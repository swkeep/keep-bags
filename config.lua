Config                                    = Config or {}

Config.max_inventory_slots                = 41

Config.duration                           = {
     open = 1,  -- sec
     close = 1, -- Do not lower the closing duration to less than 2 seconds
     lockpick = 5
}

Config.notAllowedToCarryMultipleBackpacks = true
Config.maxAllowedBackpacks                = 4

Config.lockpick_whitelist                 = {
     active = true,
     jobs = { 'police' },
     citizenid = {}
}

-- (important) do not use both prop and cloth at same time just one.
Config.Backpacks                          = {
     ['backpack1'] = {
          slots = 10,
          size = 100000,
          cloth = {
               male = {
                    ["bag"] = { item = 36, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
          whitelist = {
               ['iron'] = true
          },
     },
     ['backpack2'] = {
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
          blacklist = {
               ['iron'] = true
          },
     },
     ['backpack3'] = {
          slots = 30,
          size = 300000,
          cloth = {
               male = {
                    ["bag"] = { item = 36, texture = 3 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['backpack4'] = {
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 36, texture = 3 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['backpack5'] = {
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 69, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['backpack6'] = {
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 69, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['backpack7'] = {
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 69, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['duffle1'] = {
          slots = 20,
          size = 200000,
          cloth = {
               male = {
                    ["bag"] = { item = 82, texture = 4 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               }
          },
     },
     ['duffle2'] = {
          slots = 40,
          size = 400000,
          cloth = {
               male = {
                    ["bag"] = { item = 82, texture = 0 }
               },
               female = {
                    ["bag"] = { item = 85, texture = 13 }
               }
          },
     },
     ['briefcase'] = {
          slots = 5,
          size = 10000,
          locked = true,
          prop = GetProp('suitcase2'),
     },
     ['paramedicbag'] = {
          slots = 10,
          size = 50000,
          prop = GetProp('paramedicbag'),
     },

     -- police

     ['policepouches'] = {
          slots = 6,
          size = 200000,
          cloth = {
               male = {
                    ["accessory"] = { item = 146, texture = 0 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               },
          },
          whitelist = {
               ['weapon_pistol'] = true
          },
     },
     ['policepouches1'] = {
          slots = 12,
          size = 400000,
          cloth = {
               male = {
                    ["accessory"] = { item = 147, texture = 0 }
               },
               female = {
                    ["accessory"] = { item = 123, texture = 0 }
               },
          },
          whitelist = {
               ['weapon_pistol'] = true
          },
     },
}
