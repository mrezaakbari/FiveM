------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
local PlayerData              = {}
local toggleActive = false
isSpawnd = false
------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        if toggleActive and isSpawnd  then
            TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                    SendNUIMessage({
                        action = "updateStatusHud",
                        hunger = hunger.getPercent(),
                        thirst = thirst.getPercent(),
                    })
                end)
            end)
            TriggerServerEvent("prc:statusping")
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if isSpawnd then
            if toggleActive then
                if IsPauseMenuActive() then
                    hideHud()
                end
            else
                if not IsPauseMenuActive()then
                    Citizen.Wait(500)
                    showHud()
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        if toggleActive and isSpawnd then
            local player = PlayerPedId()
            SendNUIMessage({
                action = 'updateStatusHud',
                health = (GetEntityHealth(player) - 100),
                armour = GetPedArmour(player),
            })
        end
        Citizen.Wait(200)
    end
end)
------------------------------------------------------------------
--                          exports
------------------------------------------------------------------
exports("ShowIdCard", function() ShowIdCard() end)
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
AddEventHandler('onClientResourceStop', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    hideHud()
end)
------------------------------------------------------------------
--                          Server Event Handler
------------------------------------------------------------------
RegisterNetEvent('esx:playerSpawned')
AddEventHandler('esx:playerSpawned', function()
    Citizen.Wait(5000)
    isSpawnd = true
    updateHud()
    Citizen.Wait(50)
    showHud()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData.job = xPlayer.job
    PlayerData.gang = xPlayer.gang
    PlayerData.name = xPlayer.name
    PlayerData.money = xPlayer.money
    Citizen.Wait(50)
    updateHud()
    toggleActive = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    SendNUIMessage({
        action = "updateJob",
        data = PlayerData.job
    })
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang 
    SendNUIMessage({
        action = "updateGang",
        data = PlayerData.gang
    })
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    SendNUIMessage({
        action = "updateCash",
        cash = MakeDigit(money)
    })
end)

RegisterNetEvent('prc_status:toggleui')
AddEventHandler('prc_status:toggleui', function(show)
    if show == true then
        showHud()
    else
        hideHud()
    end
end)

RegisterNetEvent("prc:statusupdateping")
AddEventHandler("prc:statusupdateping", function(val) 
    updatePing(val)
end)
------------------------------------------------------------------
--                        User Commands
------------------------------------------------------------------
RegisterCommand('toggleHud', function(source, args, rawCommand)
    if not isSpawnd then isSpawnd = true end
    if not toggleActive then
        updateHud()
        Citizen.Wait(50)
        showHud()
    else
        hideHud()
    end
end)

RegisterCommand('myinfo', function(source, args, rawCommand)
    ShowIdCard()
end)
------------------------------------------------------------------
--                        Functions
------------------------------------------------------------------
function ShowIdCard()
    if PlayerData.job.name ~= 'unemployed' and PlayerData.gang.name ~= 'nogang' then
        TriggerEvent('chat:addMessage',
        {
            template = '<div class="chat-message server"><b>{0} Info:</b><br>Id : {1}<br>Job: {2}<br>Job Rank: {3}<br>Gang: {4}<br>Gang Rank: {5}</div>',
            args = { PlayerData.name, GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))), PlayerData.job.name , PlayerData.job.grade_label, PlayerData.gang.name , PlayerData.gang.grade_label }
        })
    elseif PlayerData.job.name == 'unemployed' and PlayerData.gang.name ~= 'nogang' then
        TriggerEvent('chat:addMessage',
        {
            template = '<div class="chat-message server"><b>{0} Info:</b><br>Id : {1}<br>Gang: {2}<br>Gang Rank: {3}</div>',
            args = {PlayerData.name, GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))), PlayerData.gang.name , PlayerData.gang.grade_label }
        })
    elseif PlayerData.job.name ~= 'unemployed' and PlayerData.gang.name == 'nogang' then
        TriggerEvent('chat:addMessage',
        {
            template = '<div class="chat-message server"><b>{0} Info:</b><br>Id : {1}<br>Job: {2}<br>Job Rank: {3}</div>',
            args = {PlayerData.name, GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))), PlayerData.job.name , PlayerData.job.grade_label}
        })
    else
        TriggerEvent('chat:addMessage',
        {
            template = '<div class="chat-message server"><b>{0} Info:</b><br>Id : {1}</div>',
            args = {PlayerData.name, GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))}
        })
    end
    
end

function showHud()
    SendNUIMessage({
        action = "toggleHud",
        show = true
    })
    toggleActive = true
end

function hideHud()
    SendNUIMessage({
        action = "toggleHud",
        show = false
    })
    toggleActive = false
end

function updatePing(val)
    SendNUIMessage({
        action = "updatePing",
        ping = val
        
    })
end

function updateHud()
    SendNUIMessage({
        action = "updateHudData",
        data = PlayerData,
        playerName = string.gsub(PlayerData.name, "_", " "),
        playerCash = MakeDigit(PlayerData.money),
        id = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
    })
end

function MakeDigit(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
	return ('$' .. left..(num:reverse():gsub('(%d%d%d)','%1' .. ','):reverse())..right)
end