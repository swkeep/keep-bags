local Harmony                            = exports['keep-harmony']:GetCoreObject()

local backpacks                          = {
    index = {},
    slots = {},
    id = {},
    items = {},
    count = 0
}

-----
local max_inventory_slots                = Config.max_inventory_slots
local notAllowedToCarryMultipleBackpacks = Config.notAllowedToCarryMultipleBackpacks
local maxAllowedBackpacks                = Config.maxAllowedBackpacks
-----

function GetCurrentBackpacks()
    return backpacks
end

function UpdateCurrentBackpacks(new_data)
    backpacks = new_data
end

-- Check if any backpack items were removed or added
function CheckForChanges(updated_backpacks)
    for id, slot in pairs(backpacks.id) do
        if not updated_backpacks.id[id] then
            local gender = GetPedGender(PlayerPedId())
            local bk = backpacks.items[id]
            local backpack_conf = GetBackpackConfig(bk.name)

            if backpack_conf then
                if backpack_conf['cloth'] then
                    backpack_conf = backpack_conf['cloth']

                    local boneIndex, cloth
                    if gender == 'male' then
                        boneIndex, cloth = next(backpack_conf.male)
                    else
                        boneIndex, cloth = next(backpack_conf.female)
                    end

                    if IsClothingValid(boneIndex) then
                        BodyAttachment:removeFromBone(boneIndex)
                    end
                elseif backpack_conf['prop'] then
                    local prop = backpack_conf['prop']
                    local boneIndex = prop['animation']['bone']

                    BodyAttachment:removeFromBone(boneIndex)
                end
            end
            return true
        end
    end

    for id, slot in pairs(updated_backpacks.slots) do
        if not backpacks.slots[slot] then
            return true
        end
    end

    return false -- No changes were detected
end

-- Check the updated inventory data for backpack items and update the backpacks table
function UpdateBackpacksData(updated_inventory_data)
    if not updated_inventory_data then return {} end
    local updated_backpacks = {
        index = {},
        slots = {},
        id = {},
        items = {},
        count = 0
    }

    for i = 1, max_inventory_slots do
        local item = updated_inventory_data[i]

        if item and IsBackpack(item) then
            local metadata = Harmony.Item.Metadata.Get(item)
            local hasId = Harmony.Item.Metadata.HasId(metadata)

            if metadata and hasId then
                updated_backpacks.slots[item.slot] = metadata.id
                updated_backpacks.id[metadata.id] = item.slot
                updated_backpacks.index[#updated_backpacks.index + 1] = item.slot
                updated_backpacks.items[metadata.id] = item
                updated_backpacks.count = updated_backpacks.count + 1
            end
        end
    end

    return updated_backpacks
end

function HandleBackpackLimits()
    local total = backpacks.count
    if notAllowedToCarryMultipleBackpacks and total > maxAllowedBackpacks then
        FreezePlayer()
        Harmony.Player.Notify(Locale.get('errors.max_backpacks'):format(maxAllowedBackpacks))
    else
        UnfreezePlayer()
    end
end
