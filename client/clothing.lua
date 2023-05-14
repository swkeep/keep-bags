BodyAttachment = {
    boneInfo = {
        ["right_hand"] = {
            boneIndex = 57005,
            activeProp = nil,
            slotIndex = -1,
            hide_when_using_weapon = true
        },
    },
    apparence = {}
}

-- init
for key, cloth in pairs(GetAllValidClothings()) do
    BodyAttachment.boneInfo[key] = {
        activeProp = nil,
        slotIndex = -1,
    }
    if key == 'bag' then
        BodyAttachment.boneInfo[key]['boneIndex'] = 24818
    end
end
--

local function LoadAnimationDictionary(animationDict)
    while not HasAnimDictLoaded(animationDict) do
        RequestAnimDict(animationDict)
        Wait(10)
    end
end

local function LoadPropModel(modelName)
    while not HasModelLoaded(GetHashKey(modelName)) do
        RequestModel(GetHashKey(modelName))
        Wait(10)
    end
end

local function AttachPropToBone(modelName, bone, position)
    local playerPed = PlayerPedId()
    local modelHash = GetHashKey(modelName)
    local playerCoords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, bone)
    local xPos, yPos, zPos = table.unpack(playerCoords)
    local activeProp = nil

    LoadPropModel(modelName)

    activeProp = CreateObject(modelHash, xPos, yPos, zPos + 0.2, true, true, true)
    AttachEntityToEntity(activeProp, playerPed, boneIndex, position.x, position.y, position.z, position.xRotation, position.yRotation, position.zRotation, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(modelHash)

    return activeProp
end

local function setCloth(cloth_type, cloth)
    if not cloth.item then
        print("Oh no! It seems like you forgot to define an item in your backpack config!")
        return
    end

    if not cloth.texture then
        print("Ahem! You have forgotten to define a texture in your backpack config!")
        return
    end
    -- print(('set to %s item = %s texture = %s'):format(cloth_type, cloth.item, cloth.texture))
    local outfit = {
        outfitData = { [cloth_type] = { item = cloth.item or -1, texture = cloth.texture or 0 } }
    }
    TriggerEvent('qb-clothing:client:loadOutfit', outfit)
    return true
end

-- Attaches a prop/cloth to the specified bone in the body
function BodyAttachment:attachToBone(bone, backpack_conf, slot)
    if self.apparence[bone] then
        --  I still don't know what I should do here! If they change their clothes, it will break.
        --  I think I should add an event into the clothing script,
        --  but the issue is that people are using different ones!
    else
        self.apparence[bone] = CurrentAppearance()[bone]
    end
    if backpack_conf.texture or backpack_conf.item then
        local cloth = backpack_conf
        -- then it means this is a cloth type
        local boneIndex = self.boneInfo[bone]
        if not boneIndex.activeProp or boneIndex.activeProp.item ~= cloth.item or boneIndex.activeProp.texture ~= cloth.texture then
            boneIndex.activeProp = cloth
            boneIndex.slotIndex = slot

            setCloth(bone, cloth)
        end
    elseif backpack_conf.model then
        local animationDict = backpack_conf.animation.dict
        local animationName = backpack_conf.animation.anim
        local model = backpack_conf.model

        -- Check if another prop is attached to the same bone
        if self.boneInfo[bone] and self.boneInfo[bone].activeProp then
            if self.boneInfo[bone].model == model then
                return
            end
            self:removeFromBone(bone)
        end

        LoadAnimationDictionary(animationDict)
        ClearPedTasks(PlayerPed)
        TaskPlayAnim(PlayerPed, animationDict, animationName, 2.0, 2.0, -1, 51, 0, false, false, false)
        RemoveAnimDict(animationDict)
        Wait(50)

        -- Attach the prop to the specified bone
        local boneIndex = self.boneInfo[bone].boneIndex
        local attachingPosition = backpack_conf.animation.attaching_position

        self.boneInfo[bone].model = model
        self.boneInfo[bone].slotIndex = slot
        self.boneInfo[bone].activeProp = AttachPropToBone(model, boneIndex, attachingPosition)
    end
end

-- Removes the prop attached to the specified bone
function BodyAttachment:removeFromBone(bone)
    local boneInfo = self.boneInfo[bone]
    if not boneInfo or not boneInfo.activeProp then
        return
    end

    local prop = boneInfo.activeProp
    if type(prop) == 'table' and prop.item and prop.texture then
        if self.apparence[bone] then
            setCloth(bone, { item = self.apparence[bone].drawableId, texture = self.apparence[bone].textureId })
        else
            setCloth(bone, { item = -1, texture = 0 })
        end
    else
        DeleteObject(prop)
        StopAnimTask(PlayerPed, 'missheistdocksprep1hold_cellphone', 'static', 1.0)
    end

    boneInfo.activeProp = nil
    boneInfo.slotIndex = -1
end

-- Removes all attached porps/clothes
function BodyAttachment:clearAll()
    for bone_name, value in pairs(self.boneInfo) do
        BodyAttachment:removeFromBone(bone_name)
    end
    self.apparence = {}
end

-- Set the clothing for the given backpack
function SetBackpackClothing(updated_backpacks)
    local gender = GetPedGender(PlayerPed)
    local boneIndexes = {}
    local backpack_conf

    for _, slot in ipairs(updated_backpacks.index) do
        local id = updated_backpacks.slots[slot]
        local bk = updated_backpacks.items[id]

        backpack_conf = GetBackpackConfig(bk.name)

        if backpack_conf then
            if backpack_conf.cloth then
                local cloth_conf = gender == 'male' and backpack_conf.cloth.male or backpack_conf.cloth.female
                local boneIndex, cloth = next(cloth_conf)

                if IsClothingValid(boneIndex) and not boneIndexes[boneIndex] then
                    boneIndexes[boneIndex] = true
                    BodyAttachment:attachToBone(boneIndex, cloth, bk.slot)
                end
            elseif backpack_conf.prop then
                local prop = backpack_conf.prop
                local boneIndex = prop.animation.bone

                if not boneIndexes[boneIndex] then
                    boneIndexes[boneIndex] = true
                    BodyAttachment:attachToBone(boneIndex, prop, bk.slot)
                end
            end
        end
    end

    if updated_backpacks.count == 0 then
        BodyAttachment:clearAll()
    end
end

local function hideAttachmentsWhenUsingWeapon()
    local lastWeapon = nil

    while true do
        local playerPed = PlayerPed
        local weapon = GetSelectedPedWeapon(playerPed)

        if weapon ~= lastWeapon then
            local alpha = weapon ~= -1569615261 and 0 or 255

            for _, bone in pairs(BodyAttachment.boneInfo) do
                if type(bone.activeProp) == "number" and bone.hide_when_using_weapon then
                    SetEntityAlpha(bone.activeProp, alpha, true)
                end
            end

            lastWeapon = weapon
        end

        Wait(2000)
    end
end

local function reattachEntitiesOnChange()
    local refresh_triggered = false

    while true do
        for _, bone in pairs(BodyAttachment.boneInfo) do
            if refresh_triggered then break end
            if type(bone.activeProp) == "number" and DoesEntityExist(bone.activeProp) then
                if not IsEntityAttached(bone.activeProp) then
                    refresh_triggered = true
                end
            end
        end

        if refresh_triggered then
            Load()
            refresh_triggered = false
        end

        Wait(5000)
    end
end

CreateThread(hideAttachmentsWhenUsingWeapon)
CreateThread(reattachEntitiesOnChange)