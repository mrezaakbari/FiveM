------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
local HasAlreadyEnteredMarker = false
local LastPad                 = nil
local LastAction              = nil
local LastPadData             = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = nil
local ClickedInsideMarker     = false
ESX                           = nil
local PlayerData			  = {}
local allBlip                 = {}
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
end)

-- Draw marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for pad, padData in pairs(Config.Pads) do
			if GetDistanceBetweenCoords(coords, padData.Marker.x, padData.Marker.y, padData.Marker.z,  true) < Config.DrawDistance then
				DrawMarker(Config.Marker.Type, padData.Marker.x, padData.Marker.y, padData.Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local playerPed      = PlayerPedId()
		local coords         = GetEntityCoords(playerPed)
		local isInMarker, currentPad, currentAction, currentPadData = false, nil, nil, nil

		for pad,padData in pairs(Config.Pads) do
			if GetDistanceBetweenCoords(coords, padData.Marker.x, padData.Marker.y, padData.Marker.z, true) < (Config.Marker.x * 1.5) then
				isInMarker, currentPad, currentAction, currentPadData, currentPadAuth = true, pad, 'pad.' .. string.lower(pad), padData , padData.auth
			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPad ~= currentPad or LastAction ~= currentAction)) then
			if (LastPad ~= nil and LastAction ~= nil) and (LastPad ~= currentPad or LastAction ~= currentAction) then
				TriggerEvent('prc_teleportveh:hasExitedMarker', LastPad, LastAction)
				
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastPad, LastAction, LastPadData = currentPad, currentAction, currentPadData

			TriggerEvent('prc_teleportveh:hasEnteredMarker', currentPad, currentPadData)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false

			TriggerEvent('prc_teleportveh:hasExitedMarker', LastPad, LastAction)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil and isAuth() then

			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, 38) then
				if ClickedInsideMarker == false then
					ClickedInsideMarker = true
					
					local targetPed = GetPlayerPed(-1)
					if (IsPedInAnyVehicle(targetPed))then
						targetPed = GetVehiclePedIsUsing(targetPed)
					end
						
					local ground
					local groundFound = false
					local x = CurrentActionData.padData.TeleportPoint.x
					local y = CurrentActionData.padData.TeleportPoint.y
					local z = CurrentActionData.padData.TeleportPoint.h

					for height=1.0,800.0,4.0 do
						RequestCollisionAtCoord(x, y, height)
						Wait(0)
						SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
						ground,z = GetGroundZFor_3dCoord(x,y,height)
						if(ground) then
							groundFound = true
							break;
						end
					end
					if(not groundFound)then
						z = 1000
						GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- Parachute
						SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
					end
					--[[
					local teleArray = {
						{
							["color"] = "5020550",
							["title"] = "Player Teleported",
							["description"] = "ID: **("..PlayerData.source..")**\nPlayer Name: **"..PlayerData.name.."**",
							["footer"] = {
							["text"] = "Persian City Log System",
							["icon_url"] = "https://cdn.discordapp.com/attachments/713473884770271283/714586011136688128/co_owner_01.png",
							}
						}
					}
					print("$$$$$$$$$$$$ Fix This Discord Log $$$$$$$$$")
					TriggerEvent('DiscordBot:ToDiscord', 'teleport', SystemName, teleArray,'system', source, false, false)
					]]
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)
------------------------------------------------------------------
--                          Client Event Handler
------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.gang.name == 'the_sex' then
		blipManager()
	else
		removeBlip()
	end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
	if PlayerData.gang.name == 'the_sex' then
		blipManager()
	else
		removeBlip()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
  PlayerData.job = Job
end)

RegisterNetEvent('prc_teleportveh:hasEnteredMarker')
AddEventHandler('prc_teleportveh:hasEnteredMarker', function(currentPad, padData)
	CurrentAction = 'pad.' .. string.lower(currentPad)
	CurrentActionMsg = padData.Text
	CurrentActionData = { padData = padData }
end)

RegisterNetEvent('prc_teleportveh:hasExitedMarker')
AddEventHandler('prc_teleportveh:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	
	CurrentAction = nil
	ClickedInsideMarker = false
end)
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
function isAuth()
	for i in ipairs(currentPadAuth) do
		if PlayerData.job.name == currentPadAuth[i] or PlayerData.gang.name == currentPadAuth[i] then
			return true
		end
	end
	return false
end

function blipManager()
	for _, blip in pairs(allBlip) do
	  RemoveBlip(blip)
	end
	allBlip = {}
	for pad, padData in pairs(Config.Pads) do
		local blipCoord = AddBlipForCoord(padData.Marker.x, padData.Marker.y)
		table.insert(allBlip, blipCoord)
		SetBlipSprite (blipCoord, 543)
		SetBlipDisplay(blipCoord, 4)
		SetBlipScale  (blipCoord, 0.85)
		SetBlipAsShortRange(blipCoord, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Gang Teleport')
		EndTextCommandSetBlipName(blipCoord)
	end
end

function removeBlip()
	for _, blip in pairs(allBlip) do
		RemoveBlip(blip)
	  end
end