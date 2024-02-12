local resource_name = GetCurrentResourceName()
local Harmony       = exports["keep-harmony"]:GetCoreObject()
local queries       = {
    ['expiredItems'] = 'SELECT * FROM keep_bags_retrieval WHERE characterId = ? AND claimed != 1 AND expire_at > FROM_UNIXTIME(?) AND  expire_at < FROM_UNIXTIME(?)',
    ['retrievableItems'] = 'SELECT * FROM keep_bags_retrieval WHERE characterId = ? AND claimed != 1 AND expire_at > FROM_UNIXTIME(?)',
    ['InsertItems'] = 'INSERT INTO keep_bags_retrieval (name, quantity, metadata, available_at, expire_at, characterId) VALUES (?, ?, ?, ?, ?, ?)',
    ['claimItem'] = 'SELECT * FROM keep_bags_retrieval WHERE id = ? AND characterId = ? AND claimed != 1 and expire_at > FROM_UNIXTIME(?) AND available_at < FROM_UNIXTIME(?)',
    ['claimAllItems'] = 'SELECT * FROM keep_bags_retrieval WHERE characterId = ? AND claimed != 1 and expire_at > FROM_UNIXTIME(?) AND available_at < FROM_UNIXTIME(?)',
    ['updateItem'] = 'UPDATE keep_bags_retrieval SET claimed = 1 WHERE id = ? AND characterId = ?'
}

RetrievalManager    = {}

function RetrievalManager:new(source, characterId)
    local newObj = {
        source = source,
        characterId = characterId
    }
    self.__index = self
    return setmetatable(newObj, self)
end

-- it's good enough right!?
local function humanReadableTimeDifference(currentTime, value)
    local timeDifference = value - currentTime

    if timeDifference >= 3600 then
        local hoursRemaining = math.floor(timeDifference / 3600)
        local remainingSeconds = timeDifference % 3600
        local minutesRemaining = math.floor(remainingSeconds / 60)
        -- local secondsRemaining = remainingSeconds % 60

        return hoursRemaining .. " hours " .. minutesRemaining .. " minutes"
    else
        local minsRemaining = math.ceil(timeDifference / 60)
        local secondsRemaining = math.floor(timeDifference % 60)

        return minsRemaining .. " minutes " .. secondsRemaining .. " seconds"
    end
end

local function getTimeInFuture(hours)
    local currentTimestamp = os.time()
    local futureTimestamp = currentTimestamp + (hours * 3600)
    return os.date("%Y-%m-%d %H:%M:%S", futureTimestamp)
end

function RetrievalManager:getExpiredItems()
    local currentTime = os.time()
    local oneWeekAgo = currentTime - (7 * 24 * 60 * 60) -- to items expired up to 1 week

    local data = MySQL.query.await(queries['expiredItems'], { self.characterId, oneWeekAgo, currentTime })

    for index, value in ipairs(data) do
        value.expire_at = os.date("%Y-%m-%d %H:%M:%S", value.expire_at / 1000)
        value.available_at = 'N/A'
    end

    return data
end

function RetrievalManager:getRetrieval()
    local currentTime = os.time() -- Get current time in seconds

    local data = MySQL.query.await(queries['retrievableItems'], { self.characterId, currentTime })

    for index, value in ipairs(data) do
        value.expire_at = humanReadableTimeDifference(currentTime, value.expire_at / 1000)

        if currentTime >= value.available_at / 1000 then
            value.available_at = 'Available'
        else
            value.available_at = humanReadableTimeDifference(currentTime, value.available_at / 1000)
        end
    end

    return data
end

function RetrievalManager:addItem(itemName, quantity, metadata, availableAt, expireAt)
    availableAt = availableAt or getTimeInFuture(Config.retrieval.available_at)
    expireAt = expireAt or getTimeInFuture(Config.retrieval.expire_at)

    MySQL.query.await(queries['InsertItems'], {
        itemName, quantity, metadata and json.encode(metadata), availableAt, expireAt, self.characterId
    })
end

function RetrievalManager:claimItem(id)
    local currentTime = os.time()
    local item = MySQL.query.await(queries.claimItem, { id, self.characterId, currentTime, currentTime })
    item = item[1]

    if item then
        local player = Harmony.Player.Object(self.source)
        local itemMetadata = item.metadata and json.decode(item.metadata) or {}

        Harmony.Player.GiveItem(self.source, player, item.name, item.quantity, nil, itemMetadata, function()
            Harmony.Player.Notify(self.source, 'Claimed success', 'primary')
            MySQL.query.await(queries['updateItem'], { id, self.characterId })
        end, function()
            Harmony.Player.Notify(self.source, 'Claimed failed', 'primary')
        end)
    else
        Harmony.Player.Notify(self.source, 'Item not found or already claimed', 'primary')
    end
end

-- we can do better! but i doubt many people get here!
function RetrievalManager:claimAllItems()
    local claimed = false
    local currentTime = os.time()
    local unclaimedItems = MySQL.query.await(queries.claimAllItems, { self.characterId, currentTime, currentTime })

    for _, item in ipairs(unclaimedItems) do
        local player = Harmony.Player.Object(self.source)
        local itemMetadata = item.metadata and json.decode(item.metadata) or {}

        Harmony.Player.GiveItem(self.source, player, item.name, item.quantity, nil, itemMetadata, function()
            claimed = true
            MySQL.query.await(queries['updateItem'], { item.id, self.characterId })
        end, function()
            Harmony.Player.Notify(self.source, 'Claimed all items failed', 'primary')
        end)
    end

    if claimed then
        Harmony.Player.Notify(self.source, 'Successfully claimed all items', 'primary')
    else
        Harmony.Player.Notify(self.source, 'No items to claim', 'primary')
    end
end

RegisterNetEvent('keep-bags:server:retrieval:showItems', function()
    local src = source

    local player = Harmony.Player.Object(src)
    local identifier = Harmony.Player.Identifier(player)

    local retrievalManager = RetrievalManager:new(src, identifier)

    TriggerClientEvent('keep-bags:client:retrieval:showItems', src, retrievalManager:getRetrieval())
end)

RegisterNetEvent('keep-bags:server:retrieval:showExpiredItems', function()
    local src = source

    local player = Harmony.Player.Object(src)
    local identifier = Harmony.Player.Identifier(player)

    local retrievalManager = RetrievalManager:new(src, identifier)

    TriggerClientEvent('keep-bags:client:retrieval:showExpiredItems', src, retrievalManager:getExpiredItems())
end)

RegisterNetEvent('keep-bags:server:retrieval:claim', function(id)
    local src = source

    local player = Harmony.Player.Object(src)
    local identifier = Harmony.Player.Identifier(player)

    local retrievalManager = RetrievalManager:new(src, identifier)

    retrievalManager:claimItem(id)
end)

RegisterNetEvent('keep-bags:server:retrieval:claimAll', function()
    local src = source

    local player = Harmony.Player.Object(src)
    local identifier = Harmony.Player.Identifier(player)

    local retrievalManager = RetrievalManager:new(src, identifier)

    retrievalManager:claimAllItems()
end)
