if IsHarmonyStarted() then return end

local Harmony = exports["keep-harmony"]:GetCoreObject()
local OutfitMenus = {}

local function getComponentLabel(component_id)
    local labels = {
        [0] = "Face",
        [1] = "Mask",
        [2] = "Hair",
        [3] = "Torso",
        [4] = "Pants",
        [5] = "Bag / Parachute",
        [6] = "Shoes",
        [7] = "Accessory",
        [8] = "Undershirt",
        [9] = "Body Armor",
        [10] = "Decal",
        [11] = "Top"
    }
    return labels[component_id] or ("Component #" .. tostring(component_id))
end

local function getPropLabel(prop_id)
    local labels = {
        [0] = "Hat",
        [1] = "Glasses",
        [2] = "Ears",
        [6] = "Watch",
        [7] = "Bracelet"
    }
    return labels[prop_id] or ("Prop #" .. tostring(prop_id))
end

function OutfitMenus.main(item_name, bag_id, outfits)
    local player_ped_id = PlayerPedId()
    local menu = {
        {
            header = "Close",
            leave = true,
        },
        {
            header = "Outfit Bag",
            icon = 'fa-solid fa-boxes-packing',
            is_header = true,
            disabled = true
        },
        {
            header = "Save Current Outfit",
            subheader = "Store your current outfit into the bag.",
            icon = 'fa-solid fa-shirt',
            action = function()
                local res = Harmony.CreateInput("Enter a name", {
                    {
                        name = 'outfit_name',
                        type = 'text',
                        title = "Outfit Name",
                        icon = 'fa-solid fa-envelope'
                    }
                })
                if res and res['outfit_name'] then
                    Harmony.Event.emitNet("server:set_outfit", item_name, bag_id, res['outfit_name'], {
                        components = exports['illenium-appearance']:getPedComponents(player_ped_id),
                        props = exports['illenium-appearance']:getPedProps(player_ped_id)
                    })
                end
            end
        },
    }

    for _, value in ipairs(outfits) do
        menu[#menu + 1] = {
            header = value.outfit_name,
            icon = 'fa-solid fa-boxes-packing',
            action = function()
                OutfitMenus.outfits(item_name, bag_id, outfits, value)
            end
        }
    end

    Harmony.Menu.Translator(menu, false)
end

function OutfitMenus.props(item_name, bag_id, outfits, outfit)
    local props_menu = {
        {
            header = "Back",
            back = true,
            action = function()
                OutfitMenus.outfits(item_name, bag_id, outfits, outfit)
            end
        },
        {
            header = "Props",
            is_header = true,
            disabled = true
        }
    }

    for _, p in ipairs(outfit.metadata.props or {}) do
        props_menu[#props_menu + 1] = {
            header = getPropLabel(p.prop_id),
            icon = 'fa-solid fa-box',
            action = function()
                exports['illenium-appearance']:setPedProp(PlayerPedId(), p)
                OutfitMenus.outfits(item_name, bag_id, outfits, outfit)
            end
        }
    end

    Harmony.Menu.Translator(props_menu, false)
end

function OutfitMenus.components(item_name, bag_id, outfits, outfit)
    local comps_menu = {
        {
            header = "Back",
            back = true,
            action = function()
                OutfitMenus.outfits(item_name, bag_id, outfits, outfit)
            end
        },
        {
            header = "Components",
            is_header = true,
            disabled = true
        }
    }

    for _, c in ipairs(outfit.metadata.components or {}) do
        if not (c.texture == 0 and c.drawable == 0) then
            comps_menu[#comps_menu + 1] = {
                header = getComponentLabel(c.component_id),
                icon = 'fa-solid fa-tshirt',
                action = function()
                    exports['illenium-appearance']:setPedComponent(PlayerPedId(), c)
                    OutfitMenus.outfits(item_name, bag_id, outfits, outfit)
                end
            }
        end
    end

    Harmony.Menu.Translator(comps_menu, false)
end

function OutfitMenus.outfits(item_name, bag_id, outfits, outfit)
    local outfit_menu = {
        {
            header = "Back",
            back = true,
            action = function()
                OutfitMenus.main(item_name, bag_id, outfits)
            end
        },
        {
            header = "Props",
            icon = 'fa-solid fa-hat-cowboy',
            action = function()
                OutfitMenus.props(item_name, bag_id, outfits, outfit)
            end
        },
        {
            header = "Components",
            icon = 'fa-solid fa-shirt',
            action = function()
                OutfitMenus.components(item_name, bag_id, outfits, outfit)
            end
        },
        {
            header = "Wear Full Outfit",
            icon = 'fa-solid fa-user-check',
            action = function()
                exports['illenium-appearance']:setPedProps(PlayerPedId(), outfit.metadata.props)
                exports['illenium-appearance']:setPedComponents(PlayerPedId(), outfit.metadata.components)
            end
        },
        {
            header = "Delete Outfit",
            icon = 'fa-solid fa-trash',
            action = function()
                Harmony.Event.emitNet("server:delete_outfit", item_name, bag_id, outfit.outfit_name)
            end
        }
    }

    Harmony.Menu.Translator(outfit_menu, false)
end

local function LoadAnimationDictionary(animationDict)
    while not HasAnimDictLoaded(animationDict) do
        RequestAnimDict(animationDict)
        Wait(10)
    end
end

Harmony.Event.onNet('client:outfitBag_menu', function(item_name, bag_id, outfits)
    local player_ped_id = PlayerPedId()

    if GetResourceState("keep-progressbar") == "started" then
        exports['keep-progressbar']:Start({
            label = "Opening Outfit Bag",
            icon = "fa-solid fa-shirt",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            stages = {
                {
                    message = "👜 Reaching for the bag...",
                    duration = 150,
                    animation = {
                        animDict = "anim@heists@ornate_bank@grab_cash",
                        anim = "intro",
                        flags = 1,
                        duration = 1500,
                        blendIn = 2.0,
                        blendOut = 2.0,
                    }
                },
                {
                    message = "👕 Checking contents...",
                    duration = 200,
                    animation = {
                        animDict = "anim@heists@ornate_bank@grab_cash",
                        anim = "grab_idle",
                        flags = 1,
                        duration = 2000,
                        blendIn = 2.0,
                        blendOut = 2.0,
                    }
                },
                {
                    message = "✅ Outfit Bag Opened",
                    duration = 150,
                    animation = {
                        animDict = "anim@heists@ornate_bank@grab_cash",
                        anim = "exit",
                        flags = 1,
                        duration = 1500,
                        blendIn = 2.0,
                        blendOut = 2.0,
                    }
                }
            }
        }, function(cancelled)
            StopAnimTask(player_ped_id, "anim@heists@ornate_bank@grab_cash", "grab", 1.0)
            if not cancelled then
                OutfitMenus.main(item_name, bag_id, outfits)
            else
                Harmony.Player.Notify("Cancelled", 'error')
            end
        end)
    else
        LoadAnimationDictionary("amb@world_human_hiker_standing@female@base")
        TaskPlayAnim(player_ped_id, 'amb@world_human_hiker_standing@female@base', 'base', 2.0, 2.0, -1, 51, 0, false, false, false)

        Harmony.Progressbar("Openning bag", 2, function()
            StopAnimTask(player_ped_id, 'amb@world_human_hiker_standing@female@base', 'base', 1.0)
            OutfitMenus.main(item_name, bag_id, outfits)
        end, function()
            StopAnimTask(player_ped_id, 'amb@world_human_hiker_standing@female@base', 'base', 1.0)
            Harmony.Player.Notify("Cancelled", 'error')
        end)
    end
end)
