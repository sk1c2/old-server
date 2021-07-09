RegisterServerEvent('evidence:pooled')
AddEventHandler('evidence:pooled', function(PooledData)
  local src = source

  -- TriggerClientEvent("CacheEvidence", source)  
  TriggerClientEvent('evidence:pooled', -1, PooledData)
end)

RegisterServerEvent('evidence:clear')
AddEventHandler('evidence:clear', function(Id)
  local src = source

  TriggerClientEvent('evidence:remove:done', source, Id)
end)

RegisterServerEvent('evidence:removal')
AddEventHandler('evidence:removal', function(closestID)
  local src = source

  TriggerClientEvent('evidence:clear:done', source, closestID)
end)