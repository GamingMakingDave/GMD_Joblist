ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('GMD_Joblists:GetAllPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerJob = xPlayer.job.name
    local matchingPlayers = {}
    local totalPlayers = 0
    local loadedPlayers = 0

    local function checkAllPlayersLoaded()
        if loadedPlayers >= totalPlayers then
            cb(matchingPlayers)
        end
    end

    local function addPlayer(playerName, phoneNumber)
        table.insert(matchingPlayers, {
            name = playerName,
            phone = phoneNumber
        })
        loadedPlayers = loadedPlayers + 1
        checkAllPlayersLoaded()
    end

    for _, playerId in ipairs(GetPlayers()) do
        local targetPlayer = ESX.GetPlayerFromId(playerId)

        if targetPlayer and targetPlayer.job.name == PlayerJob then
            totalPlayers = totalPlayers + 1
            if Config.PhoneScript == 'defaultESXPhone' then
                MySQL.Async.fetchAll('SELECT '..Config.MobileNumberEntry..' FROM '..Config.MobileNumberDB..' WHERE identifier = @identifier', {
                    ['@identifier'] = targetPlayer.identifier
                }, function(result)
                    local phoneNumber = 'N/A'
                    if result[1] then
                        phoneNumber = result[1][Config.MobileNumberEntry]
                    end
                    addPlayer(targetPlayer.getName(), phoneNumber)
                end)
            elseif Config.PhoneScript == 'qs-phone' then
                MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = targetPlayer.identifier
                }, function(result)
                    if result[1] then
                        local charinfo = json.decode(result[1].charinfo)
                        local phoneNumber = charinfo.phone or "Keine Telefonnummer gefunden"
                        local playerName = targetPlayer.getName()
                        local playerJob = targetPlayer.job.name
                        
                        addPlayer(targetPlayer.getName(), phoneNumber)
                    end
                end)   
            end
        end
    end
    checkAllPlayersLoaded()
end)

ESX.RegisterServerCallback('GMD_Joblists:hasItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(Config.ItemName) ~= nil and xPlayer.getInventoryItem(Config.ItemName).count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

if Config.UseItem then
    ESX.RegisterUsableItem(Config.ItemName, function(source)
        TriggerClientEvent('GMD_Joblists:jobTabletUse', source)
    end)
end