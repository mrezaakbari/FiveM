------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
TriggerEvent("esx:getShMRezaaredObjMRezaect", function(obj) 
	ESX = obj
end)

RegisterServerEvent("ESX_ReportMenu:SendAdmins")
AddEventHandler("ESX_ReportMenu:SendAdmins", function(source, msg)
    Sendlog(source, msg)
    TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.permission_level > 2 )then
                    TriggerClientEvent('chat:addMessage', k, {
                        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;border: 1px solid none;"><i class="far fa-newspaper"></i> New Report :<br>  {0}</div>',
                        args = { "(^2" .. GetPlayerName(source) .." | "..source.."^0) " .. msg }
                    })
				end
			end)
		end
    end)
end)
------------------------------------------------------------------
--                          Function
------------------------------------------------------------------
Sendlog = function(source, msg)
    local steamIdentifier, discordIdentifier, playerIP
    local identifiers = GetPlayerIdentifiers(source)

    for _, identifier in ipairs(identifiers) do
        if identifier:find("steam:") then
            steamIdentifier = identifier:sub(7)
        elseif identifier:find("discord:") then
            discordIdentifier = identifier:sub(9)
        elseif identifier:find("ip:") then
            playerIP = identifier:sub(4)
        end
    end

    if not steamIdentifier then
        print("Steam identifier not found for source:" .. source)
        return
    end

    local date 			= os.date('*t')
    local formattedDate = string.format("%02d.%02d.%d - %02d:%02d:%02d", date.day, date.month, date.year, date.hour, date.min, date.sec)
    local playerName 	= GetPlayerName(source)
    local message 		= string.format("```css\n[ Name : %s | ID : %d ]\n[ Identifier : %s ]\n[ Report : %s ]\n[ Time : `%s` ]\n``` <@!%s>", playerName, source, steamIdentifier, msg, formattedDate, discordIdentifier or "unknown")
    TriggerEvent('DiscordBot:ToDiscord', 'report', playerName, message, 'user', source, true, false)
end
