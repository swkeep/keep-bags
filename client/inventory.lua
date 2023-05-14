local Harmony = exports['keep-harmony']:GetCoreObject()
local QBCore = exports['qb-core']:GetCoreObject()
local resource_name = GetCurrentResourceName()
-----
local loggedOut = false
local oldPed = 0
-----

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
    local items = QBCore.Functions.GetPlayerData().items
    check(items)
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

AddEventHandler('illenium-appearance:client:loadJobOutfit',function ()
    Wait(500)

    Load()
end)

RegisterNetEvent('illenium-appearance:client:reloadSkin',function ()
    Wait(500)

    Load()
end)