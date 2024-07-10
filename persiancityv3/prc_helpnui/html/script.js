// ------------------------------------------------------------------
// --                  Developed By MReza                          --
// --               For Persian City Fivem Server                  --
// --                 Discord: mrezaa                              --
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// --                          Event Listeners
// ------------------------------------------------------------------
window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'updateHelp':
            $("body").css("display", event.data.show ? "block" : "none");
            $(`.bar`).removeClass('animate__backOutLeft');
            $(`.bar`).addClass('animate__backInLeft');
            $("#textinfo").html(event.data.text);
            break;
        case 'hideHelp':
            $(`.bar`).removeClass('animate__backInLeft');
            $(`.bar`).addClass('animate__backOutLeft');
            break;
    }
});