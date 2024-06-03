local resource_name = GetCurrentResourceName()
local Harmony       = exports["keep-harmony"]:GetCoreObject()
local npc           = Config.npc
local ped

local Menu          = {}

function Menu.retrieve_main(items)
    local menu = {
        {
            header = 'Close',
            leave = true
        },
        {
            header = 'Back',
            back = true,
            action = function()
                Menu.landing()
            end
        },
        {
            header = 'Item Retrieval',
            subheader = 'Choose an option to retrieve items',
            is_header = true,
            disabled = true,
            icon = 'fa fa-shopping-cart',
        },
        {
            header = "Retrieve All",
            subheader = 'Retrieve all available items',
            disabled = #items == 0,
            action = function()
                TriggerServerEvent('keep-bags:server:retrieval:claimAll')
            end,
            icon = 'fa fa-download',
        }
    }

    for _, item in pairs(items) do
        local subheader = "Available in: " .. item.available_at .. ", Expire At: " .. item.expire_at

        menu[#menu + 1] = {
            header = "Retrieve `" .. item.name .. "` (" .. item.quantity .. ")",
            subheader = subheader,
            disabled = item.available_at ~= 'Available',
            action = function()
                TriggerServerEvent('keep-bags:server:retrieval:claim', item.id)
            end,
            icon = 'fa fa-cube',
        }
    end

    Harmony.Menu.Open(menu)
end

function Menu.expired_items(items)
    local menu = {
        {
            header = 'Close Menu',
            leave = true
        },
        {
            header = 'Back',
            back = true,
            action = function()
                Menu.landing()
            end
        },
        {
            header = 'Expired Items',
            subheader = 'List of items that have expired (past week)',
            is_header = true,
            disabled = true,
            icon = 'far fa-calendar',
        }
    }

    for _, item in pairs(items) do
        menu[#menu + 1] = {
            header = item.name .. " (" .. item.quantity .. ")",
            subheader = "Expires At: " .. item.expire_at,
            disabled = true,
            icon = 'fas fa-exclamation-triangle',
        }
    end

    Harmony.Menu.Open(menu)
end

function Menu.landing()
    local menu = {
        {
            header = 'Close',
            leave = true
        },
        {
            header = 'Item Retrieval',
            subheader = 'Choose an option to retrieve items',
            is_header = true,
            disabled = true,
            icon = 'fas fa-shopping-cart',
        },
        {
            header = "Retrieve",
            subheader = 'Retrieve all available items',
            action = function()
                TriggerServerEvent('keep-bags:server:retrieval:showItems')
            end,
            icon = 'fas fa-box-open',
        },
        {
            header = "Expired Items",
            subheader = 'List of expired items in past week',
            action = function()
                TriggerServerEvent('keep-bags:server:retrieval:showExpiredItems')
            end,
            icon = 'far fa-calendar',
        },
    }

    Harmony.Menu.Open(menu)
end

RegisterNetEvent('keep-bags:client:retrieval:showItems', function(items)
    Menu.retrieve_main(items)
end)

RegisterNetEvent('keep-bags:client:retrieval:showExpiredItems', function(items)
    Menu.expired_items(items)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= resource_name then return end
end)

local function createTarget()
    if ped and DoesEntityExist(ped) then return end

    ped = Harmony.Ped.Create(npc.model, npc.position, {}, {
        scenario = 'WORLD_HUMAN_DRINKING',
        invincible = true,
        freeze = true,
        blockevents = true,
        networked = false
    })

    SetEntityAsMissionEntity(ped, true, true)

    Harmony.Target.onEntity(ped, {
        {
            icon = "fas fa-box",
            label = "Retrieve",
            action = function()
                Menu.landing()
            end
        }
    }, 2.0)

    -- exports["qb-target"]:AddTargetEntity(ped, {
    --     options = {
    --         {
    --             icon = "fas fa-box",
    --             label = "Retrieve",
    --             action = function()
    --                 Menu.landing()
    --             end
    --         }
    --     },
    --     distance = 1.0
    -- })
end

AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= resource_name) then return end
    Wait(1000)

    createTarget()
end)

Harmony.onPlayer.Load(function()
    Wait(1000)

    createTarget()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= resource_name then return end
    if DoesEntityExist(ped) then DeleteEntity(ped) end
end)
