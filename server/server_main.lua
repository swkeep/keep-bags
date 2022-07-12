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

local function save_weight(Player, item, weight)
     if Player.PlayerData.items[item.slot] then
          Player.PlayerData.items[item.slot].weight = weight
     end
     Player.Functions.SetInventory(Player.PlayerData.items, true)
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
          MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items'
               , {
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

local function isBlacklisted(item)
     if not Config.Blacklist_items.active then return false end
     for _, item_name in pairs(Config.Blacklist_items.list) do
          print(item.name, item_name)
          if item.name == item_name then
               return true
          end
     end
     return false
end

local function getNonBackpackItems(source, items)
     local Player = QBCore.Functions.GetPlayer(source)
     local non_bacpack_items = {}
     for key, item in pairs(items) do
          local is_B_Pack = isBackPack(item)
          local is_B_Listed = isBlacklisted(item)
          if is_B_Pack or is_B_Listed then
               Player.Functions.AddItem(item.name, 1, nil, item.info)
               TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item.name], "add")
               if is_B_Pack then
                    TriggerClientEvent('QBCore:Notify', source, "You can not have a backpack in another backpack!",
                         "error")
               end
               if is_B_Listed then
                    TriggerClientEvent('QBCore:Notify', source, "You can not put this item inside your backpack!",
                         "error")
               end
          else
               non_bacpack_items[#non_bacpack_items + 1] = item
          end
     end
     return non_bacpack_items
end

RegisterNetEvent('keep-backpack:server:saveBackpack', function(source, stashId, items, cb)
     local non_bacpack_items = getNonBackpackItems(source, items)
     SaveStashItems(stashId, non_bacpack_items)
     cb(true)
end)

local function getBackpackWeight(ID)
     local total_weight = 0
     local stash = 'Backpack_' .. ID
     local result = MySQL.Sync.fetchScalar("SELECT items FROM stashitems WHERE stash= ?", { stash })
     result = json.decode(result)
     for _, value in ipairs(result) do
          total_weight = total_weight + (value.weight * value.amount)
     end
     return total_weight
end

------------------------------------------ create items -------------------------------------------------

local function isOnHotbar(slot)
     return (slot >= 1 and slot <= 5)
end

for item_name, value in pairs(Config.items) do
     QBCore.Functions.CreateUseableItem(item_name, function(source, item)
          local Player = QBCore.Functions.GetPlayer(source)
          if not Player then return end
          local metadata = {}
          if item.info == '' or (type(item.info) == "table" and item.info.ID == nil) then
               metadata.ID = RandomID(6)
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

          if isOnHotbar(item.slot) then
               TriggerClientEvent('keep-backpack:client:enter_password', source, metadata)
          else
               TriggerClientEvent('QBCore:Notify', source, 'Backpack is not on your hand!', "error")
          end
     end)
end

RegisterNetEvent('keep-backpack:server:add_password', function(data)
     local Player = QBCore.Functions.GetPlayer(source)
     local backpack = get_backpack(Player, data.ID)
     if backpack then
          save_password(Player, backpack.item, data.password)
          TriggerClientEvent('QBCore:Notify', source, 'Added password', "success")
          return
     else
          TriggerClientEvent('QBCore:Notify', source, 'Failed to add password', "error")
     end
end)

RegisterNetEvent('keep-backpack:server:open_backpack', function(backpack_metadata)
     local Player = QBCore.Functions.GetPlayer(backpack_metadata.source)
     local backpack = get_backpack(Player, backpack_metadata.ID)
     local safe_data = {
          ID = backpack.item.info.ID,
          setting = backpack.setting
     }

     if not backpack_metadata.locked then
          TriggerClientEvent('keep-backpack:client:open', backpack_metadata.source, safe_data)
          return
     end

     if backpack.item.info.password == backpack_metadata.password then
          TriggerClientEvent('keep-backpack:client:open', backpack_metadata.source, safe_data)
          return
     else
          TriggerClientEvent('QBCore:Notify', backpack_metadata.source, 'Wrong password', "error")
          return
     end
end)

QBCore.Functions.CreateCallback('keep-backpack:server:UpdateWeight', function(source, cb, ID)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
     local backpack = get_backpack(Player, ID)

     if backpack then
          local weight = backpack.setting.weight + math.ceil(getBackpackWeight(ID) * backpack.setting.weight_multiplier)
          save_weight(Player, backpack.item, weight)
          cb(weight)
          return
     end
     cb(false)
end)
