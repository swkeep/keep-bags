# keep-bags

 ![Keep-bags](.github/images/keep-bags.jpg)

<center>

[![Discord](https://img.shields.io/discord/988158464276693012?logo=discord)](https://discord.gg/ccMArCwrPV)
[![Ko-fi](https://img.shields.io/badge/Support-Ko--fi-orange?logo=ko-fi)](https://ko-fi.com/swkeep)

</center>

`keep-bags` enhances player inventory with **expandable backpacks, realistic props, smooth animations, and secure storage places** for players.

## ✨ Features

* **Expanded Inventory**: Carry more items and materials
* **Props**: Realistic bag models on back or hands
* **Blacklisted Items**: Block specific items from being stored
* **Smooth Animations**: Immersive open/close animations
* **Locking System**: Secure your bag with a lock (password)
* **Exploit Prevention**: Prevents "bag in bag" exploits

## 🎥 Preview

[YouTube Preview](https://youtu.be/4FCx1_pOTpE)

## ⚡ Dependencies

* `qb-core` / `esx`
* `qb-inventory` / `ox_inventory`
* `ox_lib` (required for ESX, optional for QB)
* [keep-harmony](https://swkeep.tebex.io/package/5592482)
* [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance) / [qb-clothing](https://github.com/qbcore-framework/qb-clothing) / skinchanger (esx)

## 🛠 Installation

### Step 1

First download `keep-harmony` from here and then install it [Download](https://swkeep.tebex.io/package/5592482).

#### Configure keep-harmony

Set inventory type in `keep-harmony/config.lua`:

```lua
Config.inventory = 'qb-inventory'         -- New QB Inventory (v2)
Config.inventory = 'qb-inventory-legacy'  -- Old QB Inventory (v1)
```

or if you're using ox_inventory

```lua
Config.inventory = 'ox_inventory'
```

### Step 2

Add items to your inventory

<details>
<summary>ox_inventory items</summary>

1. Add images to `ox_inventory/web/images`.
2. Add items to `ox_inventory/data/items.lua`:

```lua
["backpack1"] = { label = "Backpack 1", weight = 15, stack = false, close = true, description = "A stylish backpack" },
["backpack2"] = { label = "Backpack 2", weight = 15, stack = false, close = true, description = "A stylish backpack" },
["duffle1"] = { label = "Duffle Bag", weight = 15, stack = false, close = true, description = "A stylish duffle bag" },
["briefcase"] = { label = "Briefcase", weight = 10, stack = false, close = true, description = "Portable case for documents" },
["paramedicbag"] = { label = "Paramedic Bag", weight = 5, stack = false, close = true, description = "Medical bag for emergency care" },
["policepouches"] = { label = "Police Pouch", weight = 5, stack = false, close = true, description = "Tactical equipment pouch" },
["policepouches1"] = { label = "Police Pouch (Large)", weight = 5, stack = false, close = true, description = "Larger tactical pouch" },
["briefcaselockpicker"] = { label = "Briefcase Lockpicker", weight = 0.5, stack = true, close = true, description = "Lockpicker for briefcases" }
```

</details>

<details>
<summary>qb-inventory items</summary>

1. Add images to `qb-inventory/html/images`.
2. Add items to `qb-core/shared/items.lua`:

```lua
backpack1 = { name = "backpack1", label = "Backpack", weight = 7500, type = "item", image = "backpack1.png", unique = true, useable = true, shouldClose = true, description = "A stylish backpack" },
backpack2 = { name = "backpack2", label = "Backpack", weight = 15000, type = "item", image = "backpack2.png", unique = true, useable = true, shouldClose = true, description = "A stylish backpack" },
duffle1 = { name = "duffle1", label = "Duffle Bag", weight = 15000, type = "item", image = "duffle1.png", unique = true, useable = true, shouldClose = true, description = "A stylish duffle bag" },
briefcase = { name = "briefcase", label = "Briefcase", weight = 10000, type = "item", image = "briefcase.png", unique = true, useable = true, shouldClose = true, description = "Portable case for documents" },
paramedicbag = { name = "paramedicbag", label = "Paramedic Bag", weight = 5000, type = "item", image = "paramedicbag.png", unique = true, useable = true, shouldClose = true, description = "Medical bag for emergency care" },
policepouches = { name = "policepouches", label = "Police Pouch", weight = 5000, type = "item", image = "policepouches.png", unique = true, useable = true, shouldClose = true, description = "Tactical equipment pouch" },
policepouches1 = { name = "policepouches1", label = "Police Pouch (Large)", weight = 5000, type = "item", image = "policepouches1.png", unique = true, useable = true, shouldClose = true, description = "Larger tactical pouch" },
briefcaselockpicker = { name = "briefcaselockpicker", label = "Briefcase Lockpicker", weight = 500, type = "item", image = "lockpick.png", unique = false, useable = true, shouldClose = true, description = "Lockpicker for briefcases" },
```

</details>

### Step 3 (only if you're using `qb-inventory`)

**New QB-Inventory**: add code below to `server/functions.lua` (at the end of the file):

```lua
exports('SetInventoryItems', function (id, items)
    if not Inventories[id] then return end
    Inventories[id].items = items

    items = json.encode(items)
    for _, item in pairs(items) do item.description = nil   end
    MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { id, items, items })

    return Inventories[id].items
end)
```

**Old QB-Inventory**: in `server/main.lua`, update `SaveStashItems()`:

```lua
local function SaveStashItems(stashId, items)
    if Stashes[stashId].label == 'Stash-None' or not items then return end

    for _, item in pairs(items) do item.description = nil   end
    MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items',
        { ['stash'] = stashId, ['items'] = json.encode(items) })

    Stashes[stashId].isOpen = false
    TriggerEvent('keep-harmony:stash->close', stashId)
end
```

Add export some where in that `server/main.lua` (end of the file should work fine):

```lua
exports('GetInventoryData', function(type, id)
    if type == 'stash' then return Stashes[id] end
end)
```

## Optinal

### `qb-clothing` integration

Inside `openMenu` in `client/main.lua`:

```lua
TriggerEvent('qb-clothing:client->open')
```

## ✅ Done

Your `keep-bags` setup is now complete. Enjoy **expanded, immersive, and secure inventory management**!