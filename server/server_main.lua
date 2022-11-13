--                _
--               | |
--   _____      _| | _____  ___ _ __
--  / __\ \ /\ / / |/ / _ \/ _ \ '_ \
--  \__ \\ V  V /|   <  __/  __/ |_) |
--  |___/ \_/\_/ |_|\_\___|\___| .__/
--                             | |
--                             |_|
-- https://github.com/swkeep

local QBCore = exports['qb-core']:GetCoreObject()

------------------------------------------ Functions -------------------------------------------------

local function save_info(Player, item, ID)
     if Player.PlayerData.items[item.slot] then
          if not (type(Player.PlayerData.items[item.slot].info) == "table") then
               Player.PlayerData.items[item.slot].info = {}
               Player.PlayerData.items[item.slot].info.ID = ID
          else
               Player.PlayerData.items[item.slot].info.ID = ID
          end
     end
     Player.Functions.SetInventory(Player.PlayerData.items, true)
end

local function str_split(inputstr, sep)
     if sep == nil then
          sep = "%s"
     end
     local t = {}
     for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
          table.insert(t, str)
     end
     return t
end

local function save_password(Player, item, password)
     if Player.PlayerData.items[item.slot] then
          Player.PlayerData.items[item.slot].info.password = password
     end
     Player.Functions.SetInventory(Player.PlayerData.items, true)
end

local function get_backpack(Player, ID)
     for key, value in pairs(Config.items) do
          local tmp = Player.Functions.GetItemsByName(key)
          for k, item in pairs(tmp) do
               if item.info.ID == ID then
                    return {
                         item = item,
                         setting = value
                    }
               end
          end
     end
     return
end

local function SaveStashItems(stashId, items)
     if stashId and items then
          for slot, item in pairs(items) do
               item.description = nil
          end
          MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
               ['stash'] = stashId,
               ['items'] = json.encode(items)
          })
     end
end

local function isBackPack(item)
     for item_name, _ in pairs(Config.items) do
          if item.name == item_name then
               return true
          end
     end
     return false
end

local function isBlacklisted(item, backpackName)
     -- if Config.Blacklist_items have backpack config and item is blacklisted in backpack config
     if Config.Blacklist_items[backpackName] and Config.Blacklist_items[backpackName][item.name] then
          return true
     end

     if not Config.Blacklist_items.active then return false end
     for _, item_name in pairs(Config.Blacklist_items.list) do
          if item.name == item_name then
               return true
          end
     end
     return false
end

local function isWhitelisted(item, backpackName)
     -- if Config.Whitelist_items don't have backpack config, then the item is whitlisted by default.
     if not Config.Whitelist_items[backpackName] then return true end
     -- if item is not whitelisted
     if not Config.Whitelist_items[backpackName][item.name] then return false end
     -- item is whitelisted from config
     return true
end

local function getNonBackpackItems(source, items, backpack, backpackId)
     local Player = QBCore.Functions.GetPlayer(source)
     local non_bacpack_items = {}

     -- when someone puts backpack inside itself backpack is going to be nil 
     -- for this reason we need to check items again 
     local backpack_type = nil
     if not backpack then 
          for key, item in pairs(items) do
               local is_B_Pack = isBackPack(item)
               if is_B_Pack then
                    if item.info.ID == backpackId then 
                         backpack_type = item.name
                    end
                    Player.Functions.AddItem(item.name, item.amount, nil, item.info)
                    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item.name], "add")
                    TriggerClientEvent('QBCore:Notify', source, "You can not have a backpack in another backpack!", "error")
                    items[key] = nil
               end
          end
     end

     for key, item in pairs(items) do
          if not backpack or not backpack.item then
               backpack = {
                    item = {
                         name = backpack_type
                    }
               }
          end
          local is_Whitelisted = isWhitelisted(item, backpack.item.name )
          local is_B_Listed = isBlacklisted(item, backpack.item.name )
          if is_B_Listed or not is_Whitelisted then
               Player.Functions.AddItem(item.name, item.amount, nil, item.info)
               TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item.name], "add")
               if is_B_Listed or not is_Whitelisted then
                    TriggerClientEvent('QBCore:Notify', source, "You can not put this item inside your backpack!", "error")
               end
          else
               non_bacpack_items[#non_bacpack_items + 1] = item
          end
     end
     return non_bacpack_items
end

RegisterNetEvent('keep-backpack:server:saveBackpack', function(source, stashId, items, cb)
     local Player = QBCore.Functions.GetPlayer(source)

     local stashIdData = str_split(stashId, "_")
     local backpackId = stashIdData[2]
     local backpack = get_backpack(Player, backpackId)

     local non_bacpack_items = getNonBackpackItems(source, items, backpack, backpackId)
     SaveStashItems(stashId, non_bacpack_items)
     cb(true)
end)

------------------------------------------ create items -------------------------------------------------

local function isOnHotbar(slot)
     for _, _slot in pairs(Config.Hotbar) do
          if slot == _slot then
               return true
          end
     end
     return false
end

local function t_size(table)
     local count = 0
     for _ in pairs(table) do count = count + 1 end
     return count
end

local function count_backpacks_of_same_type(Player, item)
     local item_name = item.name
     local backpacks = Player.Functions.GetItemsByName(item_name)
     return t_size(backpacks)
end

local function not_allowed_to_carry_multiple_backpacks()
     if not Config.not_allowed_to_carry_multiple_backpacks then return false end
     return true
end

local function does_have_multiple_backpacks(Player, item)
     if not_allowed_to_carry_multiple_backpacks() then
          if count_backpacks_of_same_type(Player, item) > Config.maximum_allowed then
               return true
          end
          return false
     end
     return false
end

for item_name, value in pairs(Config.items) do
     QBCore.Functions.CreateUseableItem(item_name, function(source, item)
          local Player = QBCore.Functions.GetPlayer(source)
          if not Player then return end
          local metadata = {}
          if item.info == '' or (type(item.info) == "table" and item.info.ID == nil) then
               metadata.ID = RandomID(10)
               save_info(Player, item, metadata.ID)
               if value.locked then
                    TriggerClientEvent('keep-backpack:client:create_password', source, metadata.ID)
               end
               return
          end
          metadata.ID = item.info.ID
          metadata.source = source
          metadata.password = nil
          metadata.locked = value.locked or false

          if does_have_multiple_backpacks(Player, item) then
               TriggerClientEvent('QBCore:Notify', source, 'Action not allowd when carrying multiple backpacks!', "error")
               return
          end

          if isOnHotbar(item.slot) then
               -- fix to create blank password
               if item.info.password == nil or item.info.password == '' then
                    if value.locked then
                         TriggerClientEvent('keep-backpack:client:create_password', source, metadata.ID)
                         return
                    end
               end
               -- fix end
               TriggerClientEvent('keep-backpack:client:enter_password', source, metadata)
          else
               TriggerClientEvent('QBCore:Notify', source, 'Backpack is not on your hand!', "error")
          end
     end)
end

--- lockpick
local function pickable()
     local tmp = {}
     for key, value in pairs(Config.items) do
          if value.locked then
               tmp[#tmp + 1] = key
          end
     end
     return tmp
end

local function isWhitelisted(Player)
     if not Config.whitelist.lockpick.active then return true end
     local cid = Player.PlayerData.citizenid
     local jobname = Player.PlayerData.job.name

     for key, w_cid in pairs(Config.whitelist.lockpick.citizenid) do
          if w_cid == cid then
               return true
          end
     end

     for key, w_job in pairs(Config.whitelist.lockpick.jobs) do
          if w_job == jobname then
               return true
          end
     end
     return false
end

QBCore.Functions.CreateUseableItem('briefcaselockpicker', function(source, item)
     local Player = QBCore.Functions.GetPlayer(source)
     if not Player then return end
     if not isWhitelisted(Player) then
          TriggerClientEvent('QBCore:Notify', source, 'You can not use this item!', "error")
          return
     end
     local picables = pickable()
     for _, name in pairs(picables) do
          local _item = Player.Functions.GetItemByName(name)
          local metadata = {}
          metadata.ID = _item.info.ID
          metadata.source = source
          metadata.password = nil
          metadata.locked = true
          TriggerClientEvent('keep-backpack:client:lockpick', source, metadata)
          Player.Functions.RemoveItem('briefcaselockpicker', 1)
          TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items['briefcaselockpicker'], "remove")
          return
     end
end)

RegisterNetEvent('keep-backpack:server:add_password', function(data)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
     local backpack = get_backpack(Player, data.ID)
     if backpack then
          save_password(Player, backpack.item, data.password)
          TriggerClientEvent('QBCore:Notify', src, 'Added password', "success")
          return
     else
          TriggerClientEvent('QBCore:Notify', src, 'Failed to add password', "error")
     end
end)

RegisterNetEvent('keep-backpack:server:open_backpack', function(backpack_metadata, lockpick)
     local Player = QBCore.Functions.GetPlayer(backpack_metadata.source)
     local backpack = get_backpack(Player, backpack_metadata.ID)
     if not backpack then return end
     local safe_data = {
          ID = backpack.item.info.ID,
          setting = backpack.setting
     }

     if not backpack_metadata.locked then
          TriggerClientEvent('keep-backpack:client:open', backpack_metadata.source, safe_data)
          return
     end

     if (backpack.item.info.password == backpack_metadata.password) or lockpick then
          TriggerClientEvent('keep-backpack:client:open', backpack_metadata.source, safe_data)
          return
     else
          TriggerClientEvent('QBCore:Notify', backpack_metadata.source, 'Wrong password', "error")
          return
     end
end)
