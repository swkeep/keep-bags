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
     fishicebox = {
          dict = 'missheistdocksprep1hold_cellphone',
          anim = 'static',
          bone = 'RightHand',
          attaching_position = {
               x = 0.6,
               y = 0.0,
               z = 0.0,
               x_rotation = 0.0,
               y_rotation = 270.0,
               z_rotation = 0.0,
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
     },
     fishicebox = {
          model = 'prop_coolbox_01',
          animation = animations.fishicebox
     },
}

-- which slots are your hot bar
Config.Hotbar = {
     1, 2, 3, 4, 5, 41
}

Config.duration = {
     open = 1, --sec
     close = 1
}

Config.not_allowed_to_carry_multiple_backpacks = true
Config.maximum_allowed = 2

-- (important) do not use both prop and cloth at same time just one.

Config.items = {
     ['backpack1'] = {
          slots = 10,
          size = 100000,
          male = {
               ["bag"] = { item = 85, texture = 12 }
          },

          female = {
               ["bag"] = { item = 45, texture = 0 }
          }
     },
     ['backpack2'] = {
          slots = 20,
          size = 200000,
          male = {
               ["bag"] = { item = 85, texture = 12 }
          },
          female = {
               ["bag"] = { item = 85, texture = 13 }
          }
     },
     ['briefcase'] = {
          slots = 5,
          size = 10000,
          locked = 'password',
          prop = props.suitcase2,
          remove_when_using_weapon = true
     },
     ['paramedicbag'] = {
          slots = 10,
          size = 50000,
          prop = props.paramedicbag
     },
     ['fishicebox'] = {
          slots = 40,
          size = 200000,
          prop = props.fishicebox
     },
}

Config.Blacklist_items = {
     active = true,
     list = {
          'weapon_rpg'
     },
     -- backpack2 = {
     --      ['lockpick'] = true
     -- }
}

Config.Whitelist_items = {
     paramedicbag = {
          ['firstaid'] = true,
          ['bandage'] = true,
          ['ifaks'] = true,
          ['painkillers'] = true,
          ['walkstick'] = true,
     },
     fishicebox = {
          ['stingray'] = true,
          ['flounder'] = true,
          ['codfish'] = true,
          ['mackerel'] = true,
          ['bass'] = true,
          ['fishingtin'] = true,
          ['fishingboot'] = true,
          ['killerwhale'] = true,
          ['dolphin'] = true,
          ['sharkhammer'] = true,
          ['sharktiger'] = true,
     },
}

Config.whitelist = {
     lockpick = {
          active = true,
          jobs = { 'police' },
          citizenid = {}
     }
}
