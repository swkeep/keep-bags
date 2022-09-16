# keep-backpack

![Keep-backpack](https://raw.githubusercontent.com/swkeep/keep-backpack/main/.github/images/backpack.png)

- A backpacks script that allows players to carry more items within their inventory.

# Key Features

- players can carry more materials in their inventory
- backpack props on the player's back or hands
- blacklisted items
- opening/closing animation
- locking system for backpacks
- players can not use backpacks if they are not on their Hotbar
- no backpack in backpack exploit
- (removed) weight and slower movement speed

# Preview

[Keep-backpack](https://youtu.be/7r6rUoMfvV4)

# Dependencies

- qb-core
- qb-inventory
- progressbar

# How to Install

# step0:

- Add images inside `inventoryimages` to `qb-inventory/html/images`

# step1:

- Add Below code to `qb-core/shared/items.lua`

```lua
["backpack1"] = {
     ["name"] = "backpack1",
     ["label"] = "Backpack 1",
     ["weight"] = 7500,
     ["type"] = "item",
     ["image"] = "backpack_girl.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "Backpack"
},
["backpack2"] = {
     ["name"] = "backpack2",
     ["label"] = "Backpack 2",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack_boy.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
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
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "Briefcase"
},
["paramedicbag"] = {
     ["name"] = "paramedicbag",
     ["label"] = "Paramedic bag",
     ["weight"] = 5000,
     ["type"] = "item",
     ["image"] = "paramedic_bag.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "Paramedic bag"
},

-- new item
["briefcaselockpicker"] = {
     ["name"] = "briefcaselockpicker",
     ["label"] = "Briefcase Lockpicker",
     ["weight"] = 500,
     ["type"] = "item",
     ["image"] = "lockpick.png",
     ["unique"] = false,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "Briefcase Lockpicker"
},
```

# step2 (important): fix for exploits

- 1: backpack in backpack
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

# step3 (optional): add backpackshop

- open 'qb-shops/config.lua'
- add new 'products' to 'Config.Products'

```lua
["backpackshop"] = {
     [1] = {
          name = "backpack1",
          price = 5,
          amount = 750,
          info = {},
          type = "item",
          slot = 1,
     },
     [2] = {
          name = "backpack2",
          price = 2500,
          amount = 5,
          info = {},
          type = "item",
          slot = 2,
     },
     [3] = {
          name = "briefcase",
          price = 2500,
          amount = 5,
          info = {},
          type = "item",
          slot = 3,
     },
     [4] = {
          name = "paramedicbag",
          price = 5000,
          amount = 5,
          info = {},
          type = "item",
          slot = 4,
     },
},
```

- now add new shop to 'Config.Locations'

```lua
["backpackshop"] = {
     ["label"] = "24/7 Backpackshop",
     ["coords"] = vector4(-135.68, 6199.79, 32.38, 64.55),
     ["ped"] = 'mp_m_waremech_01',
     ["scenario"] = "WORLD_HUMAN_CLIPBOARD",
     ["radius"] = 1.5,
     ["targetIcon"] = "fas fa-shopping-basket",
     ["targetLabel"] = "Open Shop",
     ["products"] = Config.Products["backpackshop"],
     ["showblip"] = true,
     ["blipsprite"] = 440,
     ["blipcolor"] = 0
},
```

- done

# Support

- [Discord](https://discord.gg/ccMArCwrPV)

# Donation

-
