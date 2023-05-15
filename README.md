# keep-bags

![Keep-bags](.github/images/keep-bags.jpg)

keep-bags is a script designed to enhance the inventory management experience for players. With a range of key features.

## Key Features

- **Expanded Inventory Capacity**: Players can carry more materials and items within their inventory, allowing for greater flexibility and resource management.

- **Props**: The script provides realistic visuals by displaying bag props on the player's back or hands, indicating that they are equipped with a bag.

- **Blacklisted Items**: A flexible option allows you to specify blacklisted items, ensuring that certain items cannot be stored in the bag. This feature helps maintain balance and prevents abuse.

- **Smooth Animation**: Opening and closing animations provide an immersive and visually appealing experience when accessing the backpack. These animations enhance realism and immersion within the game.

- **Locking System**: Bags can be equipped with a locking system, offering an additional layer of security for valuable items.

- **Prevents Exploits**: The script actively prevents the "bag in bag" exploit, ensuring fair gameplay and maintaining the integrity of the inventory system.

## ❤️ Support Development

If you enjoy my work and would like to show your appreciation, please consider making a donation to support the ongoing development of the script. Your contribution goes a long way in helping me add more exciting features and improvements. 🚀

- Click Here -> [ko-fi](https://ko-fi.com/swkeep)

Thank you for your generosity and support! 🙏

### Support

- [Discord](https://discord.gg/ccMArCwrPV)

# Preview

Check out Keep-bags preview for a better understanding of the mod's functionality.

## [Click HERE (Youtube)](https://youtu.be/4FCx1_pOTpE)

# Resource Usage

![Keep-bags](.github/images/test.png)

- i renamed the script from keep-backpack to keep-bags ;)

# Dependencies

- qb-core/esx
- qb-inventory/ox_inventory
- ox_lib (required on esx/optional for qbcore)
- [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance)
- rpemotes/dpemotes/scully_emotemenu
- **[keep-harmony](https://swkeep.tebex.io/package/5592482)**

# How to Install

Follow the steps mentioned below to install keep-bags:

- Before installing, if you're updating from an old version (keep Backpack).
- Make sure you revert the changes on QB inventory so that Bags are saved to the database.

## step 1:

- Add images inside `inventoryimages` to `qb-inventory/html/images`

## step 2:

- Add Below code to `qb-core/shared/items.lua`

```lua
["backpack1"] = {
     ["name"] = "backpack1",
     ["label"] = "Backpack",
     ["weight"] = 7500,
     ["type"] = "item",
     ["image"] = "backpack1.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack2"] = {
     ["name"] = "backpack2",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack2.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack3"] = {
     ["name"] = "backpack3",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack3.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack4"] = {
     ["name"] = "backpack4",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack4.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack5"] = {
     ["name"] = "backpack5",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack5.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack6"] = {
     ["name"] = "backpack6",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack6.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["backpack7"] = {
     ["name"] = "backpack7",
     ["label"] = "Backpack",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "backpack7.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish backpack"
},
["duffle1"] = {
     ["name"] = "duffle1",
     ["label"] = "Duffle bag",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "duffle1.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish duffle bag"
},
["duffle2"] = {
     ["name"] = "duffle2",
     ["label"] = "Duffle bag",
     ["weight"] = 15000,
     ["type"] = "item",
     ["image"] = "duffle2.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A stylish duffle bag"
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
     ["description"] = "A portable rectangular case used for carrying important documents, files, or other personal belongings."
},
["paramedicbag"] = {
     ["name"] = "paramedicbag",
     ["label"] = "Paramedic bag",
     ["weight"] = 5000,
     ["type"] = "item",
     ["image"] = "paramedicbag.png",
     ["unique"] = true,
     ["useable"] = true,
     ["shouldClose"] = true,
     ["combinable"] = nil,
     ["description"] = "A medical bag used by paramedics, containing essential supplies for emergency care."
},
["policepouches"] = {
    ["name"] = "policepouches",
    ["label"] = "Police Pouch",
    ["weight"] = 5000,
    ["type"] = "item",
    ["image"] = "policepouches.png",
    ["unique"] = true,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "A pouch used by police officers to store and carry essential supplies such as handcuffs, pepper spray, and other tactical equipment."
},
["policepouches1"] = {
    ["name"] = "policepouches1",
    ["label"] = "Police Pouch",
    ["weight"] = 5000,
    ["type"] = "item",
    ["image"] = "policepouches1.png",
    ["unique"] = true,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "A larger version of the police pouch used to store additional tactical gear and equipment."
},
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

## ESX (ox_inventory)

```lua
["backpack1"] = {
     label = "backpack1",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack2"] = {
     label = "backpack2",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack3"] = {
     label = "backpack3",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack4"] = {
     label = "backpack4",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack5"] = {
     label = "backpack5",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack6"] = {
     label = "backpack6",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["backpack7"] = {
     label = "backpack7",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish backpack"
},
["duffle1"] = {
     label = "Duffle bag",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish duffle bag"
},
["duffle2"] = {
     label = "Duffle bag",
     weight = 15,
     stack = false,
     close = true,
     description = "A stylish duffle bag"
},
["briefcase"] = {
     label = "Briefcase",
     weight = 10,
     stack = false,
     close = true,
     description = "A portable rectangular case used for carrying important documents, files, or other personal belongings."
},
["paramedicbag"] = {
     label = "Paramedic bag",
     weight = 5,
     stack = false,
     close = true,
     description = "A medical bag used by paramedics, containing essential supplies for emergency care."
},
["policepouches"] = {
     label = "Police Pouch",
     weight = 5,
     stack = false,
     close = true,
     description = "A pouch used by police officers to store and carry essential supplies such as handcuffs, pepper spray, and other tactical equipment."
},
["policepouches1"] = {
     label = "Police Pouch",
     weight = 5,
     stack = false,
     close = true,
     description = "A larger version of the police pouch used to store additional tactical gear and equipment."
},

["briefcaselockpicker"] = {
     label = "Briefcase Lockpicker",
     weight = 0.5,
     stack = true,
     close = true,
     description = "Briefcase Lockpicker"
}
```

- done
