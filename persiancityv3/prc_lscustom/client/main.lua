------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
local Vehicles = {}
local PlayerData = {}
local myCar = {}
local oldCar
local globlalvehicle = 0
local PrcZone
local PrcDutyType
local waitClick = false
local IsDead = false
local grages = {
	vector3(-338.16,-136.73,39.01), -- grage 1
	vector3(-211.11,-1324.39,30.89), -- grage 2
	vector3(1174.94,2640.46,37.75) -- grage 3
}
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while true do
		Wait(0)
		if waitClick and PrcZone ~= nil and IsControlJustReleased(0, 38) and not IsDead then
		  if PrcZone == "mechanicgrage1" or PrcZone == "mechanicgrage2" or PrcZone == "mechanicgrage3" then
			  local playerPed = GetPlayerPed(-1)
			  local vehicle = GetVehiclePedIsIn(playerPed, false)
			  orderMechanic(vehicle, PrcZone)
		  end
		  exports["prc_helpnui"]:HideHelpPrompet()
		  PrcZone = nil
		  PrcDutyType = nil
		  waitClick = false
		end
  	end
end)
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_lscustom:DontInstallMod')
AddEventHandler('esx_lscustom:DontInstallMod', function()
	myCar = oldCar
	ESX.Game.SetVehicleProperties(globlalvehicle, myCar)
	oldCar = nil
end)

RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function(vehicle)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('prcmarker:EnterMarker',function(zone)
	if not IsDead then
		if zone == "mechanicgrage1" or zone == "mechanicgrage2" or zone == "mechanicgrage3" then
			local playerPed = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local pedSeat = GetPedInVehicleSeat(vehicle, -1)
			if vehicle ~= nil and IsPedInAnyVehicle(playerPed, false) and pedSeat == playerPed then
				exports["prc_helpnui"]:ShowHelpPrompet('[E] To Request Mechanic')
				PrcZone = zone
				waitClick = true
			end
		else
			return
		end
	end
end)
  
AddEventHandler('prcmarker:ExitMarker',function(zone)
	if zone == "mechanicgrage1" or zone == "mechanicgrage2" or zone == "mechanicgrage3" and PrcZone ~= nil then
		exports["prc_helpnui"]:HideHelpPrompet()
		PrcZone = nil
		waitClick = false
	else
		return
	end
end)
------------------------------------------------------------------
--                          Commands
------------------------------------------------------------------
RegisterCommand('custom', function()
	local playerPed = GetPlayerPed(-1)
	local coords   = GetEntityCoords(playerPed)
	if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' and PlayerData.job.grade >= 1  then
		if checkGrage(coords) then
			globlalvehicle = ESX.Game.GetVehicleInDirection(4)
			if globlalvehicle == 0 then
				globlalvehicle = GetVehiclePedIsIn(playerPed, false)
			end
			if globlalvehicle == 0 then
				exports['mythic_notify']:DoHudText('inform', 'Point To The Car', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
				return
			end
			myCar = ESX.Game.GetVehicleProperties(globlalvehicle)

			ESX.TriggerServerCallback('esx_lscustom:IsRequstedVehicle', function(bool)
				if bool then
					NetworkRequestControlOfEntity(globlalvehicle)

					local timeout = 2000
					while timeout > 0 and not NetworkHasControlOfEntity(globlalvehicle) do
						Wait(100)
						timeout = timeout - 100
					end

					ESX.UI.Menu.CloseAll()
					GetAction({value = 'main'}, globlalvehicle)
					lsMenuIsShowed = true
				else
					exports['mythic_notify']:DoHudText('inform', 'No Request For This Car', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
				end
			end, VehToNet(globlalvehicle))
		else
			exports['mythic_notify']:DoHudText('inform', 'Cant Custom Here', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
		end
	else
		exports['mythic_notify']:DoHudText('inform', 'problem in job', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
	end
end, false)

RegisterCommand('finishorder', function()
	local playerPed = GetPlayerPed(-1)
	local coords   = GetEntityCoords(playerPed)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if AlreadyCalledMechanic and vehicle ~= nil then
		if checkGrage(coords) then
			finishOrderMechanic(vehicle)
		else
			exports['mythic_notify']:DoHudText('inform', 'Cant finish order Here', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
		end
	end
end, false)

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
function InstanMod(vehicle)
	oldCar = myCar
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	myCar.model = oldCar.model
	myCar.plate = oldCar.plate
end

function OpenLSMenu(elems, menuName, menuTitle, parent, vehicle)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		title    = menuTitle,
		align    = 'top-left',
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end

		for k,v in pairs(Config.Menus) do

			if k == data.current.modType or isRimMod then

				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					exports['mythic_notify']:DoHudText('inform', _U('already_own', data.current.label), { ['background-color'] = '#FFA500', ['color'] = '#fffff' })
				else
					local vehiclePrice = 10000000

					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							vehiclePrice = Vehicles[i].price
							break
						end
					end

					if isRimMod then
						price = math.floor(vehiclePrice * data.current.price / 10)
						InstanMod(vehicle)
						TriggerServerEvent('esx_lscustom:buyMod', price, VehToNet(vehicle))
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 50)
						InstanMod(vehicle)
						TriggerServerEvent('esx_lscustom:buyMod', price, VehToNet(vehicle))
					-- elseif v.modType == 17 then
					-- 	price = math.floor(vehiclePrice * v.price[1] / 100)
					-- 	TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate)
					-- 	InstanMod(vehicle)
					else
						price = math.floor(vehiclePrice * v.price / 50)
						InstanMod(vehicle)
						TriggerServerEvent('esx_lscustom:buyMod', price, VehToNet(vehicle))
					end
				end
				
				menu.close()
				found = true
				break
			end

		end

		if not found then
			GetAction(data.current, vehicle)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
		if parent == nil  then
			myCar = {}
		end
	end, function(data, menu) -- on change
		UpdateMods(data.current, vehicle)
	end, function()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
	end)
end

function UpdateMods(data, vehicle)
	if data.modType then
		local props = {}
		
		if data.wheelType then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end

		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data, vehicle)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 10000000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuName  = k
			menuTitle = v.label
			parent    = v.parent

			if v.modType then
				
				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 50)
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 50)
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- NEON
					local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						price = math.floor(vehiclePrice * v.price / 50)
						_label = _U('neon') .. ' - <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 50)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(vehiclePrice * v.price / 50)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 50)
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 50)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level', j+1) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price[j+1] / 50)
							_label = _U('level', j+1) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor(vehiclePrice * v.price[1] / 100) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 50)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent, vehicle)
end

function checkGrage(playerCoord)
	for i,v in ipairs(grages) do
		if GetDistanceBetweenCoords(playerCoord.x,playerCoord.y,playerCoord.z, v.x,v.y,v.z, true) < 12 then
			return true
		end
	end
	return false
end

function paySuccess(vehicle)
	ESX.UI.Menu.CloseAll()
	AlreadyCalledMechanic = false
	local newcar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	ESX.Game.SetVehicleProperties(vehicle, newcar)	
	FreezeEntityPosition(vehicle, false)
	TriggerServerEvent('esx_lscustom:VehiclesInWatingList', VehToNet(vehicle), false)
	DefaultCar = nil
end

function orderMechanic(vehicle, zone)
	ESX.TriggerServerCallback('esx_lscustom:checkStatus', function(ordered)
		if not ordered then
			AlreadyCalledMechanic = true
			FreezeEntityPosition(vehicle, true)
			TriggerServerEvent('esx_phone:send', 'mechanic', 'Salam Man be Yek Mechanic Niyaz daram, Toye '..zone..' Mechanici montazeram', nil)
			local DefaultCar = ESX.Game.GetVehicleProperties(vehicle)
			TriggerServerEvent('esx_lscustom:VehiclesInWatingList', VehToNet(vehicle), true, DefaultCar)
		end
	end, VehToNet(vehicle))
end

function finishOrderMechanic(vehicle)
	ESX.TriggerServerCallback('esx_lscustom:checkStatus', function(ordered)
		if ordered then
			ESX.TriggerServerCallback('esx_lscustom:PriceOfBill', function(price)
				if price > 0 then
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Pay',
					{
						title 	 = 'Pardakht Hazine',
						align    = 'center',
						question = 'Hazine Mashin shoma $'..ESX.Math.GroupDigits(price) .. ' shode ast, Az kodam ravesh mikhahid in pool ra pardakht konid?',
						elements = {
							{label = 'Naghd', value = 'cash'},
							{label = 'Cart', value = 'bank'},
							{label = 'Enseraf', value = 'cancel'}
						}
					}, function(data, menu)
						if data.current.value == 'cash' then
							ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
								if success then
									paySuccess(vehicle)
									exports['mythic_notify']:DoHudText('inform', 'Pay Mechanic:'..price, { ['background-color'] = '#0000FF', ['color'] = '#fffff' })
									AlreadyCalledMechanic = false
								else
									exports['mythic_notify']:DoHudText('inform', 'No More Cash', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
								end
							end, VehToNet(vehicle), false)
						elseif data.current.value == 'bank' then
							ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
								if success then
									paySuccess(vehicle)
									exports['mythic_notify']:DoHudText('inform', 'Pay Mechanic: '..price, { ['background-color'] = '#0000FF', ['color'] = '#fffff' })
									AlreadyCalledMechanic = false
								else
									exports['mythic_notify']:DoHudText('inform', 'No More Bank Money', { ['background-color'] = '#FF0000', ['color'] = '#fffff' })
								end
							end, VehToNet(vehicle), true)
						elseif data.current.value == 'cancel' then
							ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
								if prop then
									ESX.Game.SetVehicleProperties(vehicle, prop)
								end
							end, VehToNet(vehicle))
							TriggerServerEvent('esx_lscustom:VehiclesInWatingList', VehToNet(vehicle), false)
							FreezeEntityPosition(vehicle, false)
							DefaultCar = nil
							menu.close()
							AlreadyCalledMechanic = false
						end
					end)
				else
					AlreadyCalledMechanic = false
					FreezeEntityPosition(vehicle, false)
					TriggerServerEvent('esx_lscustom:VehiclesInWatingList', VehToNet(vehicle), false)
					DefaultCar = nil
				end
			end, VehToNet(vehicle))
		end
	end, VehToNet(vehicle))
end

function checkRadio(job)
	if job == "mechanic" then
		exports["rp-radio"]:GivePlayerAccessToFrequency(3)
	else
		exports["rp-radio"]:RemovePlayerAccessToFrequency(3)
	end
end