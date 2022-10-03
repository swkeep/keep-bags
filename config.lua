Config = Config or {}

local animations = {
     backpack = {
          dict = 'amb@world_human_hiker_standing@female@base',
          anim = 'base',
          bone = 'Back',
          attaching_position = {
               x = -0.15,
               y = -0.15,
               z = -0.05,
               x_rotation = -5.0,
               y_rotation = 90.0,
               z_rotation = 0.0,
          }
     },
     backpack2 = {
          dict = 'amb@world_human_hiker_standing@female@base',
          anim = 'base',
          bone = 'Back',
          attaching_position = {
               x = 0.07,
               y = -0.15,
               z = -0.05,
               x_rotation = 0.0,
               y_rotation = 90.0,
               z_rotation = 175.0,
          }
     },
     suitcase2 = {
          dict = 'missheistdocksprep1hold_cellphone',
          anim = 'static',
          bone = 'RightHand',
          attaching_position = {
               x = 0.10,
               y = 0.0,
               z = 0.0,
               x_rotation = 0.0,
               y_rotation = 280.0,
               z_rotation = 53.0,
          }
     },
     paramedicbag = {
          dict = 'missheistdocksprep1hold_cellphone',
          anim = 'static',
          bone = 'RightHand',
          attaching_position = {
               x = 0.29,
               y = -0.05,
               z = 0.0,
               x_rotation = -25.0,
               y_rotation = 280.0,
               z_rotation = 75.0,
          }
     },
}

local props = {
     backpack = {
          model = 'sf_prop_sf_backpack_01a',
          animation = animations.backpack
     },
     backpack2 = {
          model = 'prop_michael_backpack',
          animation = animations.backpack2
     },
     suitcase = {
          model = 'prop_ld_suitcase_01',
          animation = animations.suitcase2
     },
     suitcase2 = {
          model = 'prop_security_case_01',
          animation = animations.suitcase2
     },
     paramedicbag = {
          model = 'xm_prop_smug_crate_s_medical',
          animation = animations.paramedicbag
     }
}

-- which slots are your hot bar
Config.Hotbar = {
     1, 2, 3, 4, 5, 41
}

-- which slots that packe bagpack in back or hand
Config.backpackslots = {
     -- added all slots bcoz players keeps backpack in other slot to hide from body
     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

Config.disallowmultiple = true -- true/false. true = disallow players to carry multiple backpacks at a time in inventory. appltied on only backpac1 and backpack2

Config.duration = {
     open = 1, --sec
     close = 1
}

-- (important) do not use both prop and cloth at same time just one.

Config.items = {
     ['backpack1'] = {
          usable = false, -- true/false = false = not creation of usable item. if false then bag can only open using /backpack command. also change this in qb-core/shared/item.lua file
          slots = 10,
          size = 100000,

          male = {
               ["bag"] = { item = 17, texture = 4 } -- change item and texture as per your clothing pack
          },

          female = {
               ["bag"] = { item = 10, texture = 6 } -- change item and texture as per your clothing pack
          }

     },
     ['backpack2'] = {
          usable = false, -- true/false = false = not creation of usable item. if false then bag can only open using /backpack command. also change this in qb-core/shared/item.lua file
          slots = 10,
          size = 100000,

          male = {
               ["bag"] = { item = 17, texture = 4 } -- change item and texture as per your clothing pack
          },

          female = {
               ["bag"] = { item = 10, texture = 6 } -- change item and texture as per your clothing pack
          }
     },
     ['briefcase'] = {
          usable = true,
          slots = 5,
          size = 10000,
          locked = 'password',
          prop = props.suitcase2
     },
     ['paramedicbag'] = {
          usable = true,
          slots = 10,
          size = 50000,
          prop = props.paramedicbag
     },
}

Config.Blacklist_items = {
     active = true,
     list = {
          'weapon_rpg'
     }
}

Config.whitelist = {
     lockpick = {
          active = true,
          jobs = { 'police' },
          citizenid = {}
     }
}
