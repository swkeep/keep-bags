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
     QBCore.Functions.Progressbar("keep_gunrack_opening", 'Open', duration * 1000,
          false, false, {
               disableMovement = true,
               disableCarMovement = false,
               disableMouse = false,
               disableCombat = true
          }, {}, {}, {}, function()
          open_stash(backpack_metadata)
     end)
end)

local _slow_player = false
local function slow_player()
     if not Config.player_slow_on_weight_change.active then return end
     _slow_player = true
     local Clipset = 'move_p_m_zero_slow'
     RequestAnimSet(Clipset)
     while _slow_player do
          SetPedMovementClipset(PlayerPedId(), Clipset, true)
          Wait(0)
     end
     ResetPedMovementClipset(PlayerPedId(), true)
     _slow_player = true
end

local function close_stash(ID)
     QBCore.Functions.TriggerCallback('keep-backpack:server:UpdateWeight', function(weight)
          if weight > Config.player_slow_on_weight_change.weight then
               slow_player()
          else
               _slow_player = false
          end
     end, ID)
     TriggerEvent('animations:client:EmoteCommandStart', { "c" })
end

RegisterNetEvent("keep-backpack:client:close", function(ID)
     local duration = Config.duration.close
     QBCore.Functions.Progressbar("keep_backpack_close", 'Close', duration * 1000,
          false, false, {
               disableMovement = true,
               disableCarMovement = false,
               disableMouse = false,
               disableCombat = true
          }, {}, {}, {}, function()
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
                    text = 'Enter your password'
               },
          }
     })
     if inputData then
          if not inputData.pass then return end
          TriggerServerEvent('keep-backpack:server:add_password', { ID = ID, password = inputData.pass })
     end
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
     AttachEntityToEntity(active_prop, playerped, bone_index, position.x, position.y, position.z, position.x_rotation,
          position.y_rotation, position.z_rotation, true, true, false, true, 1, true)
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
          local playerped = PlayerPedId()
          LoadAnim(dict)
          ClearPedTasks(playerped)
          print(dict, anim)
          TaskPlayAnim(playerped, dict, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
          RemoveAnimDict(dict)
          Wait(250)
          self.bones[Bone].slot = slot
          self.bones[Bone].current_active_porp = AttachProp(model, self.bones[Bone].bone,
               backpack.prop.animation.attaching_position)
     end
end

function BODY:remove(Bone)
     if self.bones[Bone] and self.bones[Bone].current_active_porp then
          -- local playerped = PlayerPedId()
          DeleteObject(self.bones[Bone].current_active_porp)
          self.bones[Bone].current_active_porp = nil
          self.bones[Bone].slot = -1
          -- StopAnimTask(playerped, 'missheistdocksprep1hold_cellphone', 'static', 1.0)
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

--
local function getHotbarItems()
     local items = QBCore.Functions.GetPlayerData().items
     local tmp = {}
     for i = 1, 5, 1 do
          tmp[i] = items[i]
     end
     return tmp
end

function StartThread()
     if started then return end
     started = true
     CreateThread(function()
          while true do
               local hotbar_items = getHotbarItems()
               for i = 1, 5, 1 do
                    if hotbar_items[i] then
                         local backpack = getBackpack(hotbar_items[i].name)
                         if backpack then
                              BODY:attach(backpack, i)
                         end
                    else
                         BODY:cleanUpProps(i)
                    end
               end
               Wait(1000)
          end
     end)
end
