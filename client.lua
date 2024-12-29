ESX = exports['es_extended']:getSharedObject()

RegisterCommand('ranking', function(source, args, rawCommand)
    TriggerServerEvent('ranking:server:updateRanking', source)
end)
RegisterKeyMapping('ranking', 'rankingSystem', 'keyboard', 'TAB')

RegisterNetEvent('ranking:client:menu')
AddEventHandler('ranking:client:menu', function(ranking, ranga, name)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ranking', {
        title = string.format('RANKING: %s', name),
        align    = 'center',
        elements = {
            {label = string.format('RANKING: %s', ranking), name = 'ranking1'},
            {label = string.format('RANGA: %s', ranga), name = 'ranking2'},
        }
    }, function(data, menu)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)