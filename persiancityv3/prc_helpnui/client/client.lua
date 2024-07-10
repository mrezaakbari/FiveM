------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          exports
------------------------------------------------------------------
exports('ShowHelpPrompet', function(text)
    SendNUIMessage({
        action = 'updateHelp',
        show = true,
        text = text
    })
end)

exports('HideHelpPrompet', function(text)
    SendNUIMessage({
        action = 'hideHelp',
        show = false,
    })
end)