------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
local Vehicles
local VehiclesInWatingList = {}
TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) ESX = obj end)
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price, vehicle)
	local _source = source
	local k = GetVehicleInList(vehicle) 
	price = tonumber(price)
	if k then
		VehiclesInWatingList[k].price = VehiclesInWatingList[k].price + price
	else
		TriggerClientEvent('esx_lscustom:DontInstallMod', _source)
	end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				exports.ghmattimysql:execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			end
		end
	end)
end)

RegisterServerEvent('esx_lscustom:VehiclesInWatingList')
AddEventHandler('esx_lscustom:VehiclesInWatingList', function(vehicle, add, vehicleProps)
	local _Source = source
	local found = GetVehicleInList(vehicle)

	if add and not found then
		VehiclesInWatingList[vehicle] = {source = _Source, price = 0, props = vehicleProps}
	elseif not add and found then
		VehiclesInWatingList[vehicle] = nil
	end
end)
------------------------------------------------------------------
--                          Server Call back
------------------------------------------------------------------
ESX.RegisterServerCallback('esx_lscustom:getDefaultCar', function(source, cb, vehicle)
	if VehiclesInWatingList[vehicle] then
		cb(VehiclesInWatingList[vehicle].props)
	else
		cb(nil)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:checkStatus', function(source, cb, vehicle)
	local found = GetVehicleInList(vehicle)
	if found then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:PayVehicleOrders', function(source, cb, vehicle, payWithBank)
	xPlayer = ESX.GetPlayerFromId(source)
	local i = GetVehicleInList(vehicle)
	local playerping = GetPlayerPing(source)

	if playerping == nil then
		return
	end
	
	if playerping <= 0 then
		return
	end
	
	if i then
		if payWithBank then
			if xPlayer.bank >= VehiclesInWatingList[i].price then
				xPlayer.removeBank(VehiclesInWatingList[i].price)
				cb(true)
			else
				cb(false)
			end
		else
			if xPlayer.money >= VehiclesInWatingList[i].price then
				xPlayer.removeMoney(VehiclesInWatingList[i].price)
				cb(true)
			else
				cb(false)
			end

		end
	else
		cb(true)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:PriceOfBill', function(source, cb, vehicle)
	local i = GetVehicleInList(vehicle)
	if i then
		cb(VehiclesInWatingList[i].price)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:IsRequstedVehicle', function(source, cb, cVehicle)
	local i = GetVehicleInList(cVehicle)
	if i then
		TriggerClientEvent('esx:showNotification', VehiclesInWatingList[i].source, 'Mashin Shoma Dar Hale tamir mibashad')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)
------------------------------------------------------------------
--                          function
------------------------------------------------------------------
function GetVehicleInList(vehicle) 
	if VehiclesInWatingList[vehicle] then
		return vehicle
	end
	return nil
end