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

local Harmony = exports["keep-harmony"]:GetCoreObject()

Harmony.Event.onNet('client:enter_password', function(id)
     local res = Harmony.CreateInput(Locale.get('input.enter_password'), {
          {
               name = 'password',
               type = 'text',
               title = Locale.get('input.password_title'),
               icon = 'fa-solid fa-envelope'
          }
     })
     if res and res['password'] then
          Harmony.Event.emitNet('server:open_with_password', id, res['password'])
     end
end)

Harmony.Event.onNet('client:set_password', function(id)
     local res = Harmony.CreateInput(Locale.get('input.set_password'), {
          {
               name = 'password',
               type = 'text',
               title = Locale.get('input.password_title'),
               icon = 'fa-solid fa-envelope'
          }
     })
     if res and res['password'] then
          Harmony.Event.emitNet('server:set_password', id, res['password'])
     end
end)

Harmony.Event.onNet('client:lockpick:menu', function(items)
     local menu = {
          {
               header = Locale.get('menu.close'),
               leave = true,
          },
          {
               header = Locale.get('menu.lockpick_header'),
               icon = 'fa-solid fa-boxes-packing',
               is_header = true,
               disabled = true
          },
     }

     for key, value in pairs(items) do
          local str = Locale.get('menu.lockpick_item_header'):format(value.label or value.name, value.slot)
          menu[#menu + 1] = {
               header = str,
               icon = 'fa-solid fa-boxes-packing',
               action = function()
                    Harmony.Progressbar(Locale.get('progress.lockpicking'):format(value.slot), Config.duration.lockpick or 1, function()
                         local metadata = Harmony.Item.Metadata.Get(value)

                         Harmony.Event.emitNet('server:lockpick:open', value.name, metadata.id)
                    end, function()
                         Harmony.Player.Notify(Locale.get('errors.cancelled'), 'error')
                    end)
               end
          }
     end

     Harmony.Menu.Translator(menu, Locale.is_rtl())
end)

-- AddEventHandler('harmony:client:stash:closed', function(prefix, id)
--      if prefix ~= 'Bag_' then return end
--      Harmony.Event.emitNet('server:stash:closed', id)
--      Harmony.Emote.Stop()
-- end)

-- AddEventHandler('harmony:client:stash:opening', function(prefix, id)
--      if prefix ~= 'Bag_' then return end
--      Harmony.Emote.Play('kneel3')
-- end)
