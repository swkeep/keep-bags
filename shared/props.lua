local animations = {
    backpack = {
        dict = 'amb@world_human_hiker_standing@female@base',
        anim = 'base',
        bone = 'bag',
        attaching_position = {
            x = -0.15,
            y = -0.15,
            z = -0.05,
            xRotation = -5.0,
            yRotation = 90.0,
            zRotation = 0.0,
        }
    },
    backpack2 = {
        dict = 'amb@world_human_hiker_standing@female@base',
        anim = 'base',
        bone = 'bag',
        attaching_position = {
            x = 0.07,
            y = -0.15,
            z = -0.05,
            xRotation = 0.0,
            yRotation = 90.0,
            zRotation = 175.0,
        }
    },
    suitcase2 = {
        dict = 'missheistdocksprep1hold_cellphone',
        anim = 'static',
        bone = 'right_hand',
        attaching_position = {
            x = 0.10,
            y = 0.0,
            z = 0.0,
            xRotation = 0.0,
            yRotation = 280.0,
            zRotation = 53.0,
        }
    },
    paramedicbag = {
        dict = 'missheistdocksprep1hold_cellphone',
        anim = 'static',
        bone = 'right_hand',
        attaching_position = {
            x = 0.29,
            y = -0.05,
            z = 0.0,
            xRotation = -25.0,
            yRotation = 280.0,
            zRotation = 75.0,
        }
    },
    fishbox = {
        dict = 'missheistdocksprep1hold_cellphone',
        anim = 'static',
        bone = 'right_hand',
        attaching_position = {
            x = 0.6,
            y = 0.0,
            z = 0.0,
            xRotation = 0.0,
            yRotation = 270.0,
            zRotation = 0.0,
        }
    },
}

local props      = {
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
    fishbox = {
        model = 'prop_coolbox_01',
        animation = animations.fishbox
    },
}

function GetProp(item_name)
    return props[item_name]
end
