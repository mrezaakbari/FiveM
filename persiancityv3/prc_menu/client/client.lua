------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------

------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local IsPaused = false

------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource ~= GetCurrentResourceName() then
		return
  end
  CloseNui()
end)

------------------------------------------------------------------
--                          NUI Call backs
------------------------------------------------------------------
RegisterNUICallback('disablenuifocus', function(data)
  CloseNui()
end)

RegisterNUICallback('togglephone', function(data)
  CloseNui()
  Citizen.Wait(1)
  openPhone()
end)

RegisterNUICallback('toggleinventory', function(data)
  CloseNui()
  Citizen.Wait(1)
  openInventory()
end)

RegisterNUICallback('togglebilling', function(data)
  CloseNui()
  Citizen.Wait(1)
  openBiling()
end)

RegisterNUICallback('toggleemote', function(data)
  CloseNui()
  Citizen.Wait(1)
  openEmote()
end)

RegisterNUICallback('toggletrunk', function(data)
  CloseNui()
  Citizen.Wait(1)
  openTrunkInventory()
end)
RegisterNUICallback('toggleidcard', function(data)
  CloseNui()
  Citizen.Wait(1)
  sendIdCard()
end)

------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------

Citizen.CreateThread(function()
  local playerPed = GetPlayerPed(-1)
  while true do
    if IsControlJustPressed(0, 289)then
      OpenUserNui()
    end
    Citizen.Wait(0)
  end
end)

------------------------------------------------------------------
--                        Close Nui Functions
------------------------------------------------------------------

function CloseNui()
  SendNUIMessage(
    {
      menu = false
    }
  )
  DeactiveCrossHair()
  SetNuiFocus(false, false)
end

------------------------------------------------------------------
--                        Open Nui User / Car
------------------------------------------------------------------

function OpenUserNui(Entity)
  SendNUIMessage(
    {
      menu = 'user',
      idEntity = Entity
    }
  )
  SetNuiFocus(true, true)
end

function OpenCarNui(Entity)
  SendNUIMessage(
    {
      menu = 'vehicle',
      idEntity = Entity
    }
  )
  SetNuiFocus(true, true)
end

------------------------------------------------------------------
--                  Active / Deactive Cross Hair
------------------------------------------------------------------

function ActiveCrossHair()
  SendNUIMessage({
    crosshair = true
  })
end

function DeactiveCrossHair()
  SendNUIMessage({
    crosshair = false
  })
end
------------------------------------------------------------------
--                        User Nui Functions
------------------------------------------------------------------

function openInventory()
  exports['esx_inventoryhud']:OpenPlayerInventoryNui()
end

function openTrunkInventory()
  exports['esx_inventoryhud_trunk']:OpenTrunkInventoryNui()
end

function openEmote()
  exports['ptbp-emotes']:openemotemenu()
end

function openPhone()
  --print("Fix this shit in gc phone")
  exports['gcphone']:OpenPhoneNui()
end

function sendIdCard()
  exports['prc_statusnui']:ShowIdCard()
end

function openBiling()
  exports['esx_billing']:OpenBilingMenu()
end
