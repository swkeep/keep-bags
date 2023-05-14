local Harmony = exports["keep-harmony"]:GetCoreObject()
local Shared = exports["keep-harmony"]:Shared()
local CreateUseableItem = Harmony.Item.CreateUseableItem

local function isWhitelisted(Player)
    if not Config.lockpick_whitelist.active then return true end

    local cid = Player.PlayerData.citizenid
    local jobname = Player.PlayerData.job.name

    for _, w_cid in ipairs(Config.lockpick_whitelist.citizenid) do
        if w_cid == cid then return true end
    end

    for _, w_job in ipairs(Config.lockpick_whitelist.jobs) do
        if w_job == jobname then return true end
    end

    return false
end

local function use_lockpick(source, item)
    local Player = Harmony.Player.Object(source)
    if not Player or not isWhitelisted(Player) then return end

    local items = {}

    for item_name, value in pairs(Config.Backpacks) do
        if value.locked then
            local found_items = Harmony.Item.Search_by.Name(Player, item_name)
            if found_items then
                table.move(found_items, 1, #found_items, #items + 1, items)
            end
        end
    end

    Harmony.Event.emitNet('client:lockpick:menu', source, items)
end

Harmony.Event.onNet('server:lockpick:open', function(source, item_name, id)
    local Player = Harmony.Player.Object(source)
    local backpack_item = Harmony.Item.Search_by.Id(Player, item_name, id)
    local hasItemLockpick = Harmony.Player.HasItem(Player, 'briefcaselockpicker')


    if not IsBackpack(backpack_item) or not hasItemLockpick then return end

    if Harmony.Player.RemoveItem(source, Player, 'briefcaselockpicker') then
        Open_backpack(source, id, item_name)
    end
end)


CreateThread(function()
    CreateUseableItem('briefcaselockpicker', function(source, item_ref)
        use_lockpick(source, item_ref)
    end)
end)
