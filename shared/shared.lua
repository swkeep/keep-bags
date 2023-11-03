local backpacksConfig = {}

for name, value in pairs(Config.Bags) do
     local conf = value

     if conf.whitelist then
          local list = {}
          for key, item_name in pairs(conf.whitelist) do
               list[item_name] = true
          end

          conf.whitelist = list
     elseif conf.blacklist then
          local list = {}
          for key, item_name in pairs(conf.blacklist) do
               list[item_name] = true
          end
          conf.blacklist = list
     end

     backpacksConfig[name] = conf
end

-- check if an items is a backpack
function IsBackpack(backpack)
     return (backpacksConfig[backpack.name] ~= nil)
end

-- get backpack config by name
function GetBackpackConfig(backpack_name)
     return backpacksConfig[backpack_name]
end
