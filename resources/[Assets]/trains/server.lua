RegisterServerEvent('RequestTrain')
AddEventHandler('RequestTrain', function()
    local source = source
    TriggerClientEvent('AskForTrainConfirmed', source)
end)