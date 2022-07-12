# keep-backpack

- A backpacks script that allow players carry more items within their inventory.

# Dependencies

- qb-core
- progressbar

# How to Install

- step0: Add images inside `inventoryimages` to `qb-inventory/html/images`
- step1: Add Below code to `qb-core/shared/items.lua`

```lua
["backpack1"] = {
     ["name"] = "backpack1",
     ["label"] = "Backpack 1",
     ["weight"] = 10000,
     ["type"] = "item",
     ["image"] = "backpack_girl.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = false,
     ["combinable"] = nil,
     ["description"] = "Backpack"
},
["backpack2"] = {
     ["name"] = "backpack2",
     ["label"] = "Backpack 2",
     ["weight"] = 10000,
     ["type"] = "item",
     ["image"] = "backpack_boy.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = false,
     ["combinable"] = nil,
     ["description"] = "Backpack"
},
["briefcase"] = {
     ["name"] = "briefcase",
     ["label"] = "Briefcase",
     ["weight"] = 10000,
     ["type"] = "item",
     ["image"] = "briefcase.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = false,
     ["combinable"] = nil,
     ["description"] = "Briefcase"
},
["paramedicbag"] = {
     ["name"] = "paramedicbag",
     ["label"] = "Paramedic bag",
     ["weight"] = 10000,
     ["type"] = "item",
     ["image"] = "paramedic_bag.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = false,
     ["combinable"] = nil,
     ["description"] = "Paramedic bag"
},
```

- step2 (important): fix for exploit (backpack in backpack)
- open qb-inventory/server/main.lua
- find this event 'inventory:server:SaveInventory'
- find 'elseif type == "stash" then' it should look like this:

```lua
elseif type == "stash" then
     SaveStashItems(id, Stashes[id].items)
elseif type == "drop" then
```

- change code inside it to look like this

```lua
elseif type == "stash" then
     local indexstart, indexend = string.find(id, 'Backpack_')
     if indexstart and indexend then
          TriggerEvent('keep-backpack:server:saveBackpack', source, id, Stashes[id].items, function(close)
               Stashes[id].isOpen = close
          end)
          return
     end
     SaveStashItems(id, Stashes[id].items)
elseif type == "drop" then
```
