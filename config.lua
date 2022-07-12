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

Config.duration = {
     open = 1, --sec
     close = 1
}

Config.player_slow_on_weight_change = {
     active = true,
     weight = 15000
}

Config.items = {
     ['backpack1'] = {
          slots = 5,
          size = 100000,
          weight = 10000,
          weight_multiplier = 0.8, -- less value means items has less weight in backpack
          prop = props.backpack
     },
     ['backpack2'] = {
          slots = 5,
          size = 100000,
          weight = 10000,
          weight_multiplier = 0.8,
          prop = props.backpack2
     },
     ['briefcase'] = {
          slots = 3,
          size = 10000,
          weight = 10000,
          weight_multiplier = 0.8,
          locked = 'password',
          prop = props.suitcase2
     },
     ['paramedicbag'] = {
          slots = 10,
          size = 50000,
          weight = 10000,
          weight_multiplier = 0.8,
          prop = props.paramedicbag
     },
}

Config.Blacklist_items = {
     active = true,
     list = {
          'weapon_rpg'
     }
}
