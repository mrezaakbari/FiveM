------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
local report
local can = true
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
local function CloseMenu()
    return true
end

local function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    blockinput = false

    if UpdateOnscreenKeyboard() == 1 then
        return GetOnscreenKeyboardResult()
    else
        return nil
    end
end
------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------
-- Initialize ESX only once
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)
-- Anti Spam Time
Citizen.CreateThread(function()
    while true do
        if not can then
            Citizen.Wait(Config_RPS.AntiSpamTime)
            can = true
        end
    end
end)
-- Main Code
Citizen.CreateThread(function()
    JayMenu.CreateMenu("CommonMenu", "~w~Report Menu", CloseMenu)
    JayMenu.SetSubTitle("CommonMenu", "~r~~h~Select")

    for _, v in ipairs(Config_RPS.ReportCats) do
        JayMenu.CreateSubMenu(v[1], "CommonMenu", v[2])
        JayMenu.SetSubTitle(v[1], v[2])
    end

    while true do
        Citizen.Wait(0)  -- Increased wait time
        if JayMenu.IsMenuOpened("CommonMenu") then
            for _, v in ipairs(Config_RPS.ReportCats) do
                JayMenu.MenuButton("~w~~b~" .. v[2], v[1])
            end
            JayMenu.Display()
        end
        for _, v in ipairs(Config_RPS.ReportCats) do
            if JayMenu.IsMenuOpened(v[1]) then
                if v[1] == "REPORT_MORE" then
                    if JayMenu.Button("~g~~h~Report type", "~g~~h~" .. v[2]) then end
                    if JayMenu.Button("~y~~h~Type your report") then
                        report = KeyboardInput("Enter Report", "", 1000)
                    end
                    if JayMenu.Button("~r~~h~Send Report") then
                        if report then
                            TriggerServerEvent("ESX_ReportMenu:SendAdmins", GetPlayerServerId(PlayerId()), report)
                            TriggerEvent('chat:addMessage', {
                                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: none; border-radius: 3px; border: 1px solid yellow;"><i class="far fa-water"></i> Report System:<br>  {0}</div>',
                                args = { "^2Report Shoma Baraye Staff Ersal Shod "}
                            })
                            report = nil
                            JayMenu.CloseMenu()
                        else
                            ESX.ShowNotification("~r~Report Khali Ast")
                        end
                    end
                else
                    if JayMenu.Button("~g~~h~Report type", "~g~~h~" .. v[2]) then end
                    if JayMenu.Button("~r~~h~Send Report") then
                        TriggerServerEvent("ESX_ReportMenu:SendAdmins", GetPlayerServerId(PlayerId()), v[2])
                        TriggerEvent('chat:addMessage', {
                            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color : none; border-radius: 3px; border: 1px solid none;"><i class="far fa-newspaper"></i> Report System <br>  {0}</div>',
                            args = { "^2Report Shoma Baraye Admin Sabt shod !"}
                        })
                        JayMenu.CloseMenu()
                    end
                end
                JayMenu.Display()
            end
        end
    end
end)
------------------------------------------------------------------
--                          Commands
------------------------------------------------------------------
RegisterCommand("report", function(source, args)
    if can then
        JayMenu.OpenMenu("CommonMenu")
        can = false
    else
        ESX.ShowNotification("Baraye Har Report Bayad 2 Daghighe Sabr Konid")
    end
end, false)