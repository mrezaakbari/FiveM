------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
local  IsDead = false
local PrcZone
local waitClick = false
local delVehicle = nil
ESX = nil
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)
-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.blip.Pos.x, Config.Zones.blip.Pos.y, Config.Zones.blip.Pos.z)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.87)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 167) and IsInputDisabled(0) and not IsDead and Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			OpenMobileTaxiActionsMenu()
		end
	end
end)

--zone Control
Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if waitClick and PrcZone ~= nil and IsControlJustReleased(0, 38) and not IsDead then
			if PrcZone == "taxivehiclespawner" then
				OpenVehicleSpawnerMenu()
			elseif PrcZone == "taxivehiclesdeleter" then
				DeleteJobVehicle(delVehicle)
			elseif PrcZone == "taxibossaction" then
				OpenTaxiActionsMenu()
			elseif PrcZone == "taxiclockroom" then
				OpenCloakroom()
			end
			exports["prc_helpnui"]:HideHelpPrompet()
			PrcZone = nil
			waitClick = false
			delVehicle = nil
        end
    end
end)
------------------------------------------------------------------
--                          Server Event Handler
------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
AddEventHandler('prcmarker:EnterMarker',function(zone)
	if ESX.PlayerData.job.name == 'taxi' and not IsDead then
		if zone == "taxivehiclespawner" then
			exports["prc_helpnui"]:ShowHelpPrompet('[E] To Open Vehicle Menu')
			PrcZone = zone
			waitClick = true
		elseif zone == "taxivehiclesdeleter" then
			local playerPed = PlayerPedId()
			local vehicle   = GetVehiclePedIsIn(playerPed, false)
			if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				exports["prc_helpnui"]:ShowHelpPrompet('[E] To Delete Vehicle')
				PrcZone = zone
				waitClick = true
				delVehicle = vehicle
			end
		elseif zone == "taxibossaction" then
			exports["prc_helpnui"]:ShowHelpPrompet('[E] To Open Boss Action Menu')
			PrcZone = zone
			waitClick = true
		elseif zone == "taxiclockroom" then
			exports["prc_helpnui"]:ShowHelpPrompet('[E] To Open Clock Room Menu')
			PrcZone = zone
			waitClick = true
		else
			return
		end
	end
end)

AddEventHandler('prcmarker:ExitMarker',function(zone)
	if ESX.PlayerData.job.name == 'taxi' and not IsDead then
		if zone == "taxivehiclespawner" or zone == "taxivehiclesdeleter" or zone == "taxibossaction" or zone == "taxiclockroom" then
			exports["prc_helpnui"]:HideHelpPrompet()
			PrcZone = nil
			waitClick = false
			delVehicle = nil
		else
			return
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
-- Modify Car Handling
function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 10,
		modBrakes       = 10,
		color1       	= 89,
		windowTint		= 1,
		plate           = "Taxi"..math.random(1,500),
		color2       	= 4,
		modTransmission = 10,
		modSuspension   = 10,
		modArmor        = 10,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end
-- Taxi Cloak room
function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'top-left',
		elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = _U('wear_work'),    value = 'wear_work'},

		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		
		end
	end, function(data, menu)
		menu.close()
	end)
end
-- Vehicle Menu
function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {{model = 'taxi', label = 'Taxi'}}
	if ESX.PlayerData.job.grade >= 1 then
		table.insert(elements, {model = 'superd', label = 'Superd'})
	end
	if ESX.PlayerData.job.grade >= 2 then
		table.insert(elements, {model = 'bmcitaxi', label = 'BMW Taxi'})
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
	{
		title		= _U('spawn_veh'),
		align		= 'top-left',
		elements	= elements
	}, function(data, menu)
		if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
			ESX.ShowNotification(4, _U('spawnpoint_blocked'))
			return
		end

		menu.close()
		ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
			local playerPed = PlayerPedId()
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleMaxMods(vehicle)
			Wait(2000)
			SetVehicleFuelLevel(vehicle, 100.0)
		end)
	end, function(data, menu)
		menu.close()
	end)
end
-- Delete Vehicle
function DeleteJobVehicle(veh)
	local playerPed = PlayerPedId()
	if IsInAuthorizedVehicle() then
		TaskLeaveVehicle(playerPed,veh,64)
		Citizen.Wait(1800)
		ESX.Game.DeleteVehicle(veh)

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'taxi')
		end
	else
		ESX.ShowNotification(_U('only_taxi'))
	end
end
-- Taxi Station Menu
function OpenTaxiActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBosMRezasMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end
-- Taxi Phone Menu
function OpenMobileTaxiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = {
			{label = _U('billing'),   value = 'billing'},
	}}, function(data, menu)
		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification(4, _U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(4, _U('no_players_near'))
					else
						TriggerServerEvent('esx_biMRezalling:sendBill', GetPlayerServerId(closestPlayer), ESX.PlayerData.identifier, 'Taxi Driver( '..string.gsub( ESX.PlayerData.name,"_"," ")..' )', amount)
						ESX.ShowNotification(1,_U('billing_sent'))
					end

				end

			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end
-- Authorized Vehicles
function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end
-- Get Stock
function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Taxi Stock',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(4, _U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_taxijob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end
-- Put Stock
function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard', -- not used
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(4, _U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_taxijob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end