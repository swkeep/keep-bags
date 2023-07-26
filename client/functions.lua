if IsHarmonyStarted() then return end

local Harmony              = exports['keep-harmony']:GetCoreObject()
local getAppearance        = Harmony.Ped.GetAppearance
local getPedGender         = Harmony.Ped.GetPedGender
local isPlayerFrozen       = false

-- components = 0
--     face
--     mask
--     hair
--     torso
--     pants
--     bag
--     shoes
--     accessory
--     undershirt
--     vest
--     decal
--     torso2
-- props = 1
--     hat
--     glasses
--     ears
--     watch
--     bracelet

local valid_clothing_types = {
    ['vest']      = 0,
    ['accessory'] = 0, --scarf and chains
    ['bag']       = 0,
    ['decal']     = 0,
    ['hat']       = 1,
}

function IsClothingValid(clothing_type)
    return (valid_clothing_types[clothing_type])
end

function GetAllValidClothings()
    return valid_clothing_types
end

function FreezePlayer()
    if not isPlayerFrozen then
        FreezeEntityPosition(PlayerPed, true)
        isPlayerFrozen = true
    end
end

function UnfreezePlayer()
    if isPlayerFrozen then
        FreezeEntityPosition(PlayerPed, false)
        isPlayerFrozen = false
    end
end

function GetPedGender(ped)
    return getPedGender(ped)
end

function CurrentAppearance()
    local ap = getAppearance(PlayerPedId())
    local mergedTable = {}
    for key, component in pairs(ap['components']) do
        mergedTable[key] = component
    end
    for key, prop in pairs(ap['props']) do
        mergedTable[key] = prop
    end
    return mergedTable
end
