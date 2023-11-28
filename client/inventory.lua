if IsHarmonyStarted() then return end

local Harmony = exports['keep-harmony']:GetCoreObject()
local resource_name = GetCurrentResourceName()
-----
local loggedOut = false
local oldPed = 0
-----
local PlayerPedId = PlayerPedId
--

local function check(updated_inventory_data)
    PlayerPed = PlayerPedId()

    local updated_backpacks = UpdateBackpacksData(updated_inventory_data)
    local changesDetected = CheckForChanges(updated_backpacks)
    UpdateCurrentBackpacks(updated_backpacks)

    if changesDetected then
        SetBackpackClothing(updated_backpacks)
    end

    HandleBackpackLimits()
end

function Load()
    BodyAttachment:clearAll()
    local PlayerData = Harmony.Player.PlayerData()
    if PlayerData then
        check(PlayerData.items)
    end
end

Harmony.onUpdate.items(check)

Harmony.onPlayer.Load(function()
    Wait(5000)

    Load()
end)

Harmony.onPlayer.Logout(function()
    BodyAttachment:clearAll()
    loggedOut = true
    oldPed = PlayerPedId()

    CreateThread(function()
        while loggedOut do
            if oldPed ~= PlayerPedId() then
                Wait(1500)
                Load()
                loggedOut = false
                oldPed = 0
            end
            Wait(1000)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= resource_name then return end
    Wait(1000)

    Load()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= resource_name then return end

    BodyAttachment:clearAll()
    UnfreezePlayer()
end)

-- AddEventHandler('illenium-appearance:client:loadJobOutfit', function()
--     Wait(500)

--     Load()
-- end)

if Config.clothingScript == 'qb-clothing' then
    RegisterNetEvent('qb-clothing:client:reloadOutfits', function(myOutfits)
        Wait(500)

        Load()
    end)

    RegisterNetEvent('qb-clothing:client:loadPlayerClothing', function(myOutfits)
        Wait(1000)

        Load()
    end)

    RegisterNetEvent('qb-clothing:client->open', function(myOutfits)
        BodyAttachment:clearAll()
    end)

    AddEventHandler('qb-clothing:client:onMenuClose', function()
        Wait(500)

        Load()
    end)
else
    RegisterNetEvent('illenium-appearance:client:reloadSkin', function()
        Wait(500)

        Load()
    end)
end
