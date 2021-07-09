local MinCashReward = 5000
local MaxCashReward = 10000
local MinMethReward = 20
local MaxMethReward = 50

local Police = {}
local PoliceCount = 0

function RewardPlayers(playerA, PlayerB)
	-- Player A
	TriggerClientEvent('prp-banned:getID', source, 'vanmeth', math.random(MinMethReward, MaxMethReward))
	TriggerClientEvent('prp-banned:getID', source, 'pseudoephedrine', math.random(1,15))
	-- Player B
end

function NotifyPolice(pos)
	for k,v in pairs(Police) do
		TriggerClientEvent('urp_meth:NotifyCops', v, pos)
	end
end

RegisterNetEvent('urp_meth:RemovePolice')
AddEventHandler('urp_meth:RemovePolice', function()
	RemovePolice()
end)

RegisterNetEvent('urp_meth:AddPolice')
AddEventHandler('urp_meth:AddPolice', function()
	JoinPolice()
end)

RegisterNetEvent('urp_meth:BeginCooking')
AddEventHandler('urp_meth:BeginCooking', function(target)
	TriggerClientEvent('urp_meth:BeginCooking', target, source)
end)

RegisterNetEvent('urp_meth:FinishCook')
AddEventHandler('urp_meth:FinishCook', function(target, result, msg)
	TriggerClientEvent('urp_meth:FinishCook', target, result, msg)
end)

RegisterNetEvent('urp_meth:SyncSmoke')
AddEventHandler('urp_meth:SyncSmoke', function(netId)
	TriggerClientEvent('urp_meth:SyncSmoke', -1, netId)
end)

RegisterNetEvent('urp_meth:NotifyPolice')
AddEventHandler('urp_meth:NotifyPolice', function(loc)
	Citizen.CreateThread(function()
		NotifyPolice(loc)
	end)
end)

RegisterNetEvent('urp_meth:RemoveTruck')
AddEventHandler('urp_meth:RemoveTruck', function(netId)
	TriggerClientEvent('urp_meth:RemoveSmoke', -1, netId)
end)

RegisterNetEvent('urp_meth:RewardPlayers')
AddEventHandler('urp_meth:RewardPlayers', function(driver)
	RewardPlayers(source, driver)
end)

RegisterServerEvent('urp_meth:methHint')
AddEventHandler('urp_meth:methHint', function(cid, hint)
	exports.ghmattimysql:execute('UPDATE __characters SET `methint` = ? WHERE `id` = ?', {hint, cid})
end)
