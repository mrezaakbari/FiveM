------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
local markers = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local debugEnable               = false
local activeMarkerBlip          = true
local DrawDistance              = 9
local color                     = {r= 255, g= 255, b =0}
------------------------------------------------------------------
--                          exports
------------------------------------------------------------------
exports('AddMarkerZone', function(name, cx, cy, cz, sx, sy, sz, flag)
    if name and cx and cy and cz and sx and sy and sz then
        local marker = {title = name, coords = vector3(cx,cy,cz), size = {x = sx, y = sy, z = sz}, hasMarker = flag}
        RegisterMarker(marker)
        --print(marker.coords)
    end
end)

exports('RemoveMarkerZone', function(name)
    UnRegisterMarker(name)
end)
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
function RegisterMarker(data)
    if CheckDubli(data.title, markers) then
        print('invalid register Marker '.. data.title)
    else
        table.insert( markers, data)
    end
end

function UnRegisterMarker(name)
    if name then
        for k,v in pairs(markers) do
            if k.title == name then
                table.remove( markers, data, nil)
            end
        end
    end
end

function CheckDubli(name, array)
    for k,v in pairs(array) do
        if (v.title == name) then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        local letSleep = true
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for _, info in pairs(markers) do
            if activeMarkerBlip and (#(coords - info.coords) < info.size.x) then
                local x,y,z = table.unpack(info.coords)
                DrawMarker(27, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, info.size.x, info.size.y, info.size.z, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end
        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker = false
        local currnetZone = nil

        for k,v in pairs(markers) do
            if (#(coords - v.coords) <= v.size.x) then
                isInMarker = true
                currnetZone = v.title
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currnetZone) then
            HasAlreadyEnteredMarker = true
            LastZone = currnetZone
            if debugEnable then
                print('prc base : Enter To Marker: '..LastZone)
            end
            TriggerEvent('prcmarker:EnterMarker', LastZone)
        end
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            if debugEnable then
                print('prc base : Exit From Marker: '.. LastZone)
            end
            TriggerEvent('prcmarker:ExitMarker', LastZone)
        end

        if not isInMarker then
            Citizen.Wait(500)
        end
    end
end)