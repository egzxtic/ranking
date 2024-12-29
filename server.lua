ESX = exports['es_extended']:getSharedObject()

function getPlayerRanking(identifier)
    local result = MySQL.Sync.fetchAll('SELECT ranking FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    if result[1] then
        return result[1].ranking
    else
        return nil
    end
end

function checkRank(playerId, callback)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        local license = xPlayer.getIdentifier()

        MySQL.Async.fetchScalar('SELECT ranga FROM users WHERE identifier = @identifier', {
            ['@identifier'] = license
        }, function(rank)
            if rank then
                callback(rank)
                print(rank)
            end
        end)
    else
        print('ERROR1: Nie znaleziono xPlayer')
    end
end
exports('checkRank', checkRank)

RegisterServerEvent('ranking:server:getRanking')
AddEventHandler('ranking:server:getRanking', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        local license = xPlayer.getIdentifier()
        local ranking = getPlayerRanking(license)
        local rank = 'BRAK'

        for playerRanking, r in pairs(Config.rangi) do
            if ranking >= playerRanking then
                rank = r
            else
                break
            end
        end

        MySQL.Async.execute('UPDATE users SET ranga = @ranga WHERE identifier = @identifier', {
            ['@ranga'] = rank,
            ['@identifier'] = license
        }, function(rowsChanged)
            if rowsChanged > 0 then else
                print('ERROR1')
            end
        end)
    else
        print('ERROR2: Nie znaleziono xPlayer')
    end
end)

RegisterServerEvent('ranking:server:updateRanking')
AddEventHandler('ranking:server:updateRanking', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local name = xPlayer.getName()

    if xPlayer then
        local license = xPlayer.getIdentifier()
        local ranking = getPlayerRanking(license)
        local rank = 'BRAK'

        for playerRanking = 2200, 0, -100 do
            if ranking >= playerRanking then
                rank = Config.rangi[playerRanking]
                break
            end
        end

        MySQL.Async.execute('UPDATE users SET ranga = @ranga WHERE identifier = @identifier', {
            ['@ranga'] = rank,
            ['@identifier'] = license
        }, function(rowsChanged)
            if rowsChanged > 0 then else
                print('ERROR2')
            end
        end)

        TriggerClientEvent('ranking:client:menu', playerId, ranking, rank, name)
    else
        print('ERROR3: Nie znaleziono xPlayer')
    end
end)