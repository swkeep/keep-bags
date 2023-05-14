local backpacksConfig = {}

for name, value in pairs(Config.Backpacks) do
     backpacksConfig[name] = value
end

-- check if an items is a backpack
function IsBackpack(backpack)
     return (backpacksConfig[backpack.name] ~= nil)
end

-- get backpack config by name
function GetBackpackConfig(backpack_name)
     return backpacksConfig[backpack_name]
end
