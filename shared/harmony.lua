local isHarmonyStarted = GetResourceState('keep-harmony'):find('start')
local appearance = GetResourceState('illenium-appearance'):find('start')
local qb_clothing = GetResourceState('qb-clothing'):find('start')
local showen = false
local showen2 = false

function IsHarmonyStarted()
    if not appearance and not qb_clothing and not showen2 then
        warn(
            'You are missing both illenium-appearance and qb-clothing install one of these clothing menus!.\n Install illenium-appearance from here: https://github.com/iLLeniumStudios/illenium-appearance \n Install it from here: https://github.com/qbcore-framework/qb-clothing')
        showen2 = true
    elseif (not appearance and not qb_clothing) and not showen2 then
        warn('You are missing illenium-appearance. Install it from here: https://github.com/iLLeniumStudios/illenium-appearance')
        showen2 = true
    end

    if not isHarmonyStarted and not showen then
        showen = true
        print([[
--------------------------------------------------------------
IMPORTANT: Installation Instructions for Keep-Bags
--------------------------------------------------------------
Before using Keep-Bags, you need to install and set up Keep-Harmony.
Keep-Harmony is a required lib that works in conjunction with Keep-Bags.

Follow these steps to install Keep-Harmony:
Step 1: Download the Keep-Harmony script from the following link:
          Download Link: https://swkeep.tebex.io/package/5592482

Step 2: Install Keep-Harmony using the instructions provided in the documentation:
          Installation Guide: https://swkeep.com/docs/keep-harmony/installation

Step 3 (Important): Once Keep-Harmony is installed, you can proceed to install and use Keep-Bags.
          Make sure you're fixing the loading order within server.cfg

     ## qbcore exmaple:
          ensure qb-core
          ensure ox_lib
          ensure illenium-appearance
          ensure [qb]
          ensure [standalone]
          ensure keep-input
          ensure keep-menu
          ensure keep-harmony
          ensure [voice]
          ensure [defaultmaps]
          ensure keep-bags

     ## ESX Legacy exmaple:
          ensure es_extended
          ensure [core]

          ## ESX Addons
          ensure [standalone]
          ensure [esx_addons]
          ensure [ox]
          ensure illenium-appearance
          ensure keep-harmony
          -- other resources or nothing
          ensure keep-backpack

Important Note: Keep-Bags will not work without Keep-Harmony, so make sure to follow the steps above.

If you have any questions or encounter any issues during the installation process,
feel free to seek help from the official support channel

Discord: https://discord.gg/ccMArCwrPV
--------------------------------------------------------------]])
    end

    if not isHarmonyStarted then return true end
end
