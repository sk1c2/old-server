---------------------------------------------------------------------------
-- Spawn Spikestrip Command --
---------------------------------------------------------------------------

RegisterServerEvent('prp-spikes:placeSpike')
AddEventHandler('prp-spikes:placeSpike', function(src, amount)
    local src = source
    local amount = 1
    SpawnSpikestrips(src, amount)
end)  
function SpawnSpikestrips(src, amount)
    if SpikeConfig.IdentifierRestriction then
        local player_identifier = PlayerIdentifier(SpikeConfig.Identifier, src)
        for a = 1, #SpikeConfig.IdentifierList do
            if SpikeConfig.IdentifierList[a] == player_identifier then
                TriggerClientEvent("Spikes:SpawnSpikes", src, {amount = amount, isRestricted = SpikeConfig.PedRestriction, pedList = SpikeConfig.PedList})
                break
            end
        end
    else
        TriggerClientEvent("Spikes:SpawnSpikes", src, {amount = amount, isRestricted = SpikeConfig.PedRestriction, pedList = SpikeConfig.PedList})
    end
end

---------------------------------------------------------------------------
-- Delete Spikestrips --
---------------------------------------------------------------------------
RegisterServerEvent("Spikes:TriggerDeleteSpikes")
AddEventHandler("Spikes:TriggerDeleteSpikes", function(netid)
    TriggerClientEvent("Spikes:DeleteSpikes", -1, netid)
end)

---------------------------------------------------------------------------
-- Get Player Identifier --
---------------------------------------------------------------------------
function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end
