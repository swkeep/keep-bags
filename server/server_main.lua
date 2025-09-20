--                _
--               | |
--   _____      _| | _____  ___ _ __
--  / __\ \ /\ / / |/ / _ \/ _ \ '_ \
--  \__ \\ V  V /|   <  __/  __/ |_) |
--  |___/ \_/\_/ |_|\_\___|\___| .__/
--                             | |
--                             |_|
-- https://github.com/swkeep
if IsHarmonyStarted() then return end

local resource_name = GetCurrentResourceName()
local Harmony = exports["keep-harmony"]:GetCoreObject()
local Shared = exports["keep-harmony"]:Shared()
local CreateUseableItem = Harmony.Item.CreateUseableItem
local RandomId = Shared.Util.randomId
local CustomDJB2 = Shared.CustomDJB2
local Backpack = { data = {} }
------------------------------------------ Functions -------------------------------------------------

local function getItemAmount(item)
     if item.amount then
          return item.amount
     elseif item.count then
          return item.count
     else
          return 0
     end
end

local function retrievalAddItem(source, Player, item)
     local identifier = Harmony.Player.Identifier(Player)

     local r = RetrievalManager:new(source, identifier)
     r:addItem(item.name, item.amount or item.count, item.info or item.metadata)
end

local function giveItemToPlayer(source, Player, item, success, fail)
     local itemMetadata = Harmony.Item.Metadata.Get(item) or {}
     local amount = getItemAmount(item)

     Harmony.Player.GiveItem(source, Player, item.name, amount, nil, itemMetadata, nil, function()
          retrievalAddItem(source, Player, item)
     end)
end

local function filter(tbl, predicate)
     local result = {}
     for k, v in pairs(tbl) do
          if predicate(v) then
               result[k] = v
          end
     end
     return result
end

local function tableSize(table)
     local count = 0
     for _ in pairs(table) do
          count = count + 1
     end
     return count
end

local function isMultipleBackpacksNotAllowed()
     return Config.not_allowed_to_carry_multiple_backpacks or false
end

local function hasTooManyBackpacks(Player, item)
     if not isMultipleBackpacksNotAllowed() then
          return false
     end

     local backpacks = Player.Functions.GetItemsByName(item.name)
     local numBackpacksOfType = tableSize(backpacks)

     return numBackpacksOfType > Config.maximum_allowed
end

local function checkForNestedBackpacks(stash_items, backpack_id, source, Player)
     local has_backpack_inception = false
     for key, item in pairs(stash_items) do
          if IsBackpack(item) then
               local metadata = Harmony.Item.Metadata.Get(item)

               if metadata.id == backpack_id then
                    Harmony.Player.Notify(source, Locale.get('errors.backpack_self_insertion'), 'primary')
                    giveItemToPlayer(source, Player, item)
                    stash_items[key] = nil
                    has_backpack_inception = true
                    break
               end
          end
     end

     return has_backpack_inception
end

local function checkForOtherBackpacks(stash_items, source, Player)
     local has_other_backpacks = false
     local backpack_items = filter(stash_items, IsBackpack)

     for key, item in pairs(backpack_items) do
          Harmony.Player.Notify(source, Locale.get('errors.backpack_rule_breaker'), 'primary')
          giveItemToPlayer(source, Player, item)
          stash_items[key] = nil
          has_other_backpacks = true
     end

     return has_other_backpacks
end

local function filterValidItems(stash_items, backpack_conf)
     local valid_items
     if backpack_conf.whitelist then
          valid_items = filter(stash_items, function(item)
               return backpack_conf.whitelist[string.lower(item.name)]
          end)
     elseif backpack_conf.blacklist then
          valid_items = filter(stash_items, function(item)
               return not backpack_conf.blacklist[string.lower(item.name)]
          end)
     else
          valid_items = stash_items
     end

     return valid_items
end

local function notifyAndReturnInvalidItems(stash_items, valid_items, Player, source)
     -- notify and return invalid items to owner
     -- items are sorted by their slotIndex
     for slot, item in pairs(stash_items) do
          if not valid_items[slot] then
               Harmony.Player.Notify(source, Locale.get('errors.backpack_crammed'), 'primary')
               giveItemToPlayer(source, Player, item)
               stash_items[slot] = nil
          end
     end
end

local function get_opening_duration(bag_config)
     return bag_config.duration and bag_config.duration.opening or Config.duration.open
end

local function saveOutfit(bagId, outfit_name, outfit)
     local metadata = json.encode(outfit)

     local exists = MySQL.query.await('SELECT id FROM keep_bags_outfit WHERE identifier = ? AND outfit_name = ?', {
          bagId, outfit_name
     })

     if exists and #exists > 0 then
          local affectedRows = MySQL.update.await('UPDATE keep_bags_outfit SET metadata = ? WHERE id = ?', {
               metadata, exists[1].id
          })
          return affectedRows > 0, "updated"
     else
          local insertId = MySQL.insert.await('INSERT INTO keep_bags_outfit (identifier, outfit_name, metadata) VALUES (?, ?, ?)', {
               bagId, outfit_name, metadata
          })
          return insertId and insertId > 0, "inserted"
     end
end

local function getOutfit(bagId)
     local res = MySQL.query.await('SELECT outfit_name, metadata FROM keep_bags_outfit WHERE identifier = ?', {
          bagId
     })

     for key, value in pairs(res) do
          value.metadata = json.decode(value.metadata)
     end
     return res
end

local function deleteOutfit(bagId, outfit_name)
     return MySQL.query.await('DELETE FROM keep_bags_outfit WHERE identifier = ? AND outfit_name = ?', {
          bagId, outfit_name
     })
end

local function closeBag(source, id)
     local Player = Harmony.Player.Object(source)
     local backpack = Backpack.data[id]
     if not backpack then return end

     local backpack_conf = GetBackpackConfig(backpack['item_name'])
     local stash_items = Harmony.Stash('Bag_', id).Items('inventory')

     checkForNestedBackpacks(stash_items, id, source, Player)
     checkForOtherBackpacks(stash_items, source, Player)
     local valid_items = filterValidItems(stash_items, backpack_conf)
     notifyAndReturnInvalidItems(stash_items, valid_items, Player, source)
     Harmony.Stash('Bag_', id).Save(stash_items)

     Backpack.data[id] = nil
end

local function openBag(src, id, item_name)
     local backpack_conf = GetBackpackConfig(item_name)

     if backpack_conf.outfitbag then
          Harmony.Event.emitNet('client:outfitbag_menu', src, item_name, id, getOutfit(id))
     else
          local stash = Harmony.Stash('Bag_', id)
          local size = backpack_conf.size or 10000
          local slots = backpack_conf.slots or 6
          if stash.Open(src, slots, size, get_opening_duration(backpack_conf)) then
               stash.observer(function()
                    closeBag(src, id)
               end)
          else
               Harmony.Player.Notify(src, 'Bag is already open')
          end
     end
end

AddEventHandler('keep-bags:server:openBag', openBag)

local function backpack_use(source, item_name, backpack_conf, item_ref)
     local Player = Harmony.Player.Object(source)
     if not Player then return end
     local Identifier = Harmony.Player.Identifier(Player)
     local Hash = CustomDJB2(Identifier)
     local metadata = Harmony.Item.Metadata.Get(item_ref)

     if type(metadata) == 'table' and metadata.ID then
          -- check for migration
          metadata = {
               id = metadata.ID,
               password = metadata.password
          }
          item_ref = Harmony.Item.Metadata.Prepare(item_ref, metadata)
          Harmony.Item.Metadata.Save(Player, item_ref)
     end

     if not Harmony.Item.Metadata.HasId(metadata) then
          metadata = {
               id = Hash .. '_' .. RandomId(10),
          }
          item_ref = Harmony.Item.Metadata.Prepare(item_ref, metadata)
          Harmony.Item.Metadata.Save(Player, item_ref)
          Harmony.Player.Notify(source, 'Opening', 'success')
     end

     Backpack.data[metadata.id] = { source = source, item_name = item_name }
     if backpack_conf.locked and not metadata.password then
          Harmony.Event.emitNet('client:set_password', source, metadata.id)
          return
     end

     if hasTooManyBackpacks(Player, item_ref) then
          Harmony.Player.Notify(source, Locale.get('errors.multiple_backpacks'), 'error')
          return
     end

     if backpack_conf.locked then
          Harmony.Event.emitNet('client:enter_password', source, metadata.id)
     else
          openBag(source, metadata.id, item_name)
     end
end

-- events

Harmony.Event.onNet('server:open_with_password', function(source, id, password)
     if not password or password == '' or type(password) ~= 'string' then
          Harmony.Player.Notify(source, Locale.get('errors.try_better_password'), 'error')
          return
     end
     local Player = Harmony.Player.Object(source)
     local backpack = Backpack.data[id]

     if backpack and source == backpack['source'] then
          local backpack_item = Harmony.Item.Search_by.Id(Player, backpack['item_name'], id)
          local metadata = Harmony.Item.Metadata.Get(backpack_item)

          if metadata.password == password then
               openBag(source, id, backpack['item_name'])
          else
               Harmony.Player.Notify(source, Locale.get('errors.wrong_password'), 'error')
          end
     end
end)

Harmony.Event.onNet('server:set_password', function(source, id, password)
     if not password or password == '' or type(password) ~= 'string' then
          Harmony.Player.Notify(source, Locale.get('errors.try_better_password'), 'error')
          return
     end

     local Player = Harmony.Player.Object(source)
     local backpack = Backpack.data[id]

     if backpack and source == backpack['source'] then
          local backpack_item = Harmony.Item.Search_by.Id(Player, backpack['item_name'], id)
          local metadata = Harmony.Item.Metadata.Get(backpack_item)

          metadata.password = password -- who needs encryption am I right?!
          backpack_item = Harmony.Item.Metadata.Prepare(backpack_item, metadata)
          Harmony.Item.Metadata.Save(Player, backpack_item)

          Harmony.Player.Notify(source, Locale.get('success.password_set'), 'success')
     end
end)

Harmony.Event.onNet('server:set_outfit', function(source, item_name, bag_id, name, outfit)
     local player = Harmony.Player.Object(source)
     local item = Harmony.Item.Search_by.Id(player, item_name, bag_id)
     if not item then return end

     saveOutfit(bag_id, name, outfit)
end)

Harmony.Event.onNet('server:delete_outfit', function(source, item_name, bag_id, name)
     local player = Harmony.Player.Object(source)
     local item = Harmony.Item.Search_by.Id(player, item_name, bag_id)
     if not item then return end

     deleteOutfit(bag_id, name)
end)

RegisterNetEvent('keep-harmony:stash:opening->cancel', function(prefix, id)
     if prefix ~= 'Bag_' then return end

     local src = source
     Backpack.data[id] = nil
end)

AddEventHandler('onResourceStart', function(resource)
     if resource ~= resource_name then return end
     Wait(1500)

     exports['keep-harmony']:ShowInformation()
     -- exports['keep-harmony']:UpdateChecker()
end)

AddEventHandler('playerDropped', function(reason)
     local src = source -- Player ID who disconnected

     for key, value in pairs(Backpack.data) do
          if value.source == src then
               closeBag(src, key, {})
               break
          end
     end
end)

-- items

CreateThread(function()
     local bags = GetAllBags()

     for item_name, backpack_conf in pairs(bags) do
          CreateUseableItem(item_name, function(source, item_ref)
               backpack_use(source, item_name, backpack_conf, item_ref)
          end)
     end
end)
