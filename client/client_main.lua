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
local started = false

local function open_stash(metadata)
     TriggerEvent('animations:client:EmoteCommandStart', { "kneel3" })

     local settings = { maxweight = metadata.setting.size, slots = metadata.setting.slots }
     TriggerServerEvent("inventory:server:OpenInventory", "stash", "Backpack_" .. metadata.ID, settings)
     TriggerEvent("inventory:client:SetCurrentStash", "Backpack_" .. metadata.ID)

     Wait(2000)
     repeat
          Wait(250)
     until IsNuiFocused() == false
     TriggerEvent("keep-backpack:client:close", metadata.ID)
end

RegisterNetEvent("keep-backpack:client:open", function(backpack_metadata)
     if not backpack_metadata then return end
     local duration = Config.duration.open
     QBCore.Functions.Progressbar("keep_gunrack_opening", 'Open', duration * 1000, false, false, {
          disableMovement = true,
          disableCarMovement = false,
          disableMouse = false,
          disableCombat = true
     }, { animDict = "clothingshirt", anim = "try_shirt_positive_d", flags = 49 }, {}, {}, function()
          open_stash(backpack_metadata)
     end)
end)


local function close_stash(ID)
     TriggerEvent('animations:client:EmoteCommandStart', { "c" })
end

RegisterNetEvent("keep-backpack:client:close", function(ID)
     local duration = Config.duration.close
     QBCore.Functions.Progressbar("keep_backpack_close", 'Close', duration * 1000, false, false, {
          disableMovement = true,
          disableCarMovement = false,
          disableMouse = false,
          disableCombat = true
     }, { animDict = "clothingshirt", anim = "try_shirt_positive_d", flags = 49 }, {}, {}, function()
          close_stash(ID)
     end)
end)

RegisterNetEvent('keep-backpack:client:enter_password', function(backpack_metadata)
     if backpack_metadata.locked then
          local inputData = exports['qb-input']:ShowInput({
               header = 'Password',
               inputs = {
                    {
                         type = 'password',
                         isRequired = true,
                         name = 'pass',
                         text = 'Enter your password'
                    },
               }
          })
          if inputData then
               if not inputData.pass then return end
               backpack_metadata.password = inputData.pass
               TriggerServerEvent('keep-backpack:server:open_backpack', backpack_metadata)
          end
     else
          TriggerServerEvent('keep-backpack:server:open_backpack', backpack_metadata)
     end
end)

RegisterNetEvent('keep-backpack:client:create_password', function(ID)
     local inputData = exports['qb-input']:ShowInput({
          header = 'Password',
          inputs = {
               {
                    type = 'password',
                    isRequired = true,
                    name = 'pass',
                    text = 'Enter new password'
               },
          }
     })
     if inputData then
          if not inputData.pass then return end
          TriggerServerEvent('keep-backpack:server:add_password', { ID = ID, password = inputData.pass })
     end
end)

RegisterNetEvent("keep-backpack:client:lockpick", function(backpack_metadata)
     local duration = Config.duration.close
     QBCore.Functions.Progressbar("keep_backpack_close", 'Lockpicking', 1 * 1000, false, false, {
          disableMovement = true,
          disableCarMovement = false,
          disableMouse = false,
          disableCombat = true
     }, {}, {}, {}, function()
          TriggerServerEvent('keep-backpack:server:open_backpack', backpack_metadata, true)
     end)
end)


AddEventHandler('onResourceStart', function(resourceName)
     -- for test
     StartThread()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
     -- on usage
     StartThread()
end)

---------------------------------------------..

local function getBackpack(item_name)
     for key, value in pairs(Config.items) do
          if item_name == key then
               return value
          end
     end
     return nil
end

function LoadAnim(dict)
     while not HasAnimDictLoaded(dict) do
          RequestAnimDict(dict)
          Wait(10)
     end
end

function LoadPropDict(model)
     while not HasModelLoaded(GetHashKey(model)) do
          RequestModel(GetHashKey(model))
          Wait(10)
     end
end

function AttachProp(model, bone, position)
     local playerped = PlayerPedId()
     local model_hash = GetHashKey(model)
     local playercoord = GetEntityCoords(playerped)
     local bone_index = GetPedBoneIndex(playerped, bone)
     local _x, _y, _z = table.unpack(playercoord)
     local active_prop = nil

     if not HasModelLoaded(model) then
          LoadPropDict(model)
     end

     active_prop = CreateObject(model_hash, _x, _y, _z + 0.2, true, true, true)
     AttachEntityToEntity(active_prop, playerped, bone_index, position.x, position.y, position.z, position.x_rotation, position.y_rotation, position.z_rotation, true, true, false, true, 1, true)
     SetModelAsNoLongerNeeded(model)
     return active_prop
end

BODY = {
     bones = {
          ['RightHand'] = {
               bone = 57005,
               current_active_porp = nil,
               slot = -1,
          },
          ["Back"] = {
               bone = 24818,
               current_active_porp = nil,
               slot = -1,
          },
     }
}

function BODY:attach(backpack, slot)
     local Bone = backpack.prop.animation.bone
     local dict = backpack.prop.animation.dict
     local anim = backpack.prop.animation.anim
     local model = backpack.prop.model
     if self.bones[Bone] and self.bones[Bone].current_active_porp then
          return
     else
          LoadAnim(dict)
          ClearPedTasks(PlayerPedId())
          TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
          RemoveAnimDict(dict)
          Wait(50)
          self.bones[Bone].slot = slot
          self.bones[Bone].current_active_porp = AttachProp(model, self.bones[Bone].bone, backpack.prop.animation.attaching_position)
     end
end

function BODY:remove(Bone)
     if self.bones[Bone] and self.bones[Bone].current_active_porp then
          DeleteObject(self.bones[Bone].current_active_porp)
          self.bones[Bone].current_active_porp = nil
          self.bones[Bone].slot = -1
          StopAnimTask(PlayerPedId(), 'missheistdocksprep1hold_cellphone', 'static', 1.0)
          return
     end
end

function BODY:cleanUpProps(slot)
     for key, value in pairs(self.bones) do
          if value.slot ~= -1 and value.slot == slot then
               BODY:remove(key)
               return true
          end
     end
     return nil
end

local function isItemBackpack(item_name)
     for name, _ in pairs(Config.items) do
          if name == item_name then
               return true
          end
     end
     return false
end

local function isChanged(oldTable, newTable)
     if TableCompare(oldTable, newTable, false) == false then
          return true
     else
          return false
     end
end

local function dosomething(current, p)
     local dif_ = difference(p, current)

     for _, item in pairs(dif_) do
          if isItemBackpack(item.name) then
               local backpack = getBackpack(item.name)
               if backpack ~= nil then
                    if backpack.prop then
                         BODY:cleanUpProps(item.slot)
                    elseif backpack.male or backpack.female then
                         if BODY.bones['Back'].current_active_porp then
                              local PlayerData = QBCore.Functions.GetPlayerData()
                              if PlayerData.charinfo.gender == 0 then
                                   -- i'm too lazy to add deep copy :)
                                   local outfitData = backpack.male
                                   local type 
                                   for key, _ in pairs(outfitData) do
                                        type = key
                                   end
                                   
                                   TriggerEvent('qb-clothing:client:loadOutfit', {
                                        outfitData = {[type] = {item = -1 ,texture = 0}}
                                   })
                              else
                                   local outfitData = (backpack.female)
                                   local type 
                                   for key, _ in pairs(outfitData) do
                                        type = key
                                   end
                                   TriggerEvent('qb-clothing:client:loadOutfit', {
                                        outfitData = {[type] = {item = -1 ,texture = 0}}
                                   })
                              end
                              BODY:remove('Back')
                         end
                    end
                    local PlayerPed = PlayerPedId()
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    local CurrentWeaponName = QBCore.Shared.Weapons[weapon]
                    if CurrentWeaponName ~= nil then
                         if CurrentWeaponName.name:upper() ~= 'WEAPON_UNARMED' then
                              if backpack.prop then
                                   BODY:cleanUpProps(item.slot)
                              end
                         end
                    end
               end
          end
     end

     for _, item in pairs(current) do
          if item ~= 'empty' and isItemBackpack(item.name) then
               local PlayerPed = PlayerPedId()
               local weapon = GetSelectedPedWeapon(PlayerPed)
               local CurrentWeaponName = QBCore.Shared.Weapons[weapon]
               local backpack = getBackpack(item.name)
               if backpack ~= nil then
                    if CurrentWeaponName ~= nil and CurrentWeaponName.name:upper() ~= 'WEAPON_UNARMED' and
                        backpack.remove_when_using_weapon then
                         if backpack.prop then
                              BODY:cleanUpProps(item.slot)
                         end
                    elseif backpack.prop then
                         BODY:attach(backpack, item.slot)
                    elseif backpack.male or backpack.female then
                         if not BODY.bones['Back'].current_active_porp then
                              local PlayerData = QBCore.Functions.GetPlayerData()
                              if PlayerData.charinfo.gender == 0 then
                                   TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = backpack.male })
                              else
                                   TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = backpack.female })
                              end
                              BODY.bones['Back'].current_active_porp = 54646 -- something random
                              BODY.bones['Back'].slot = item.slot
                         end
                    end
               end
          end
     end
end

local traker = {
     p_state = {},
     c_state = {}
}
function StartThread()
     if started then return end
     started = true
     CreateThread(function()
          while true do
               traker.p_state = shallowcopy(traker.c_state)
               local items = QBCore.Functions.GetPlayerData().items
               for _, hotbar_slot in pairs(Config.Hotbar) do
                    if items[hotbar_slot] then
                         traker.c_state[hotbar_slot] = items[hotbar_slot]
                    else
                         traker.c_state[hotbar_slot] = 'empty'
                    end
               end
               if isChanged(traker.c_state, traker.p_state) then
                    dosomething(traker.c_state, traker.p_state)
               end
               local PlayerPed = PlayerPedId()
               local weapon = GetSelectedPedWeapon(PlayerPed)
               local CurrentWeaponName = QBCore.Shared.Weapons[weapon]
               if CurrentWeaponName ~= nil then
                    if CurrentWeaponName.name:upper() ~= 'WEAPON_UNARMED' then
                         dosomething(traker.c_state, traker.p_state)
                    end
               end
               Wait(2500)
          end
     end)
end

AddEventHandler('onResourceStop', function(resource)
     if resource == GetCurrentResourceName() then
          for index, value in ipairs(Config.Hotbar) do
               BODY:cleanUpProps(index)
          end
     end
end)
