RegisterServerEvent('UpdateFurniture')
AddEventHandler('UpdateFurniture', function(house_id,house_model,modifiedObjects)
    local src = source
    exports.ghmattimysql:execute('UPDATE __housedata SET `furniture`= ? WHERE `house_id`= ? AND `house_model`= ?', {json.encode(modifiedObjects), house_id, house_model})
end)