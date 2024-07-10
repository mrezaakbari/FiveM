------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
RegisterNetEvent("prc:statusping")
AddEventHandler("prc:statusping", function()
    TriggerClientEvent('prc:statusupdateping', source, GetPlayerPing(source))
end)