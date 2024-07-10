// ------------------------------------------------------------------
// --                  Developed By MReza
// --               For Persian City Fivem Server
// --                 Discord: mrezaa
// ------------------------------------------------------------------
$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'toggleHud':
                $("body").css("display", event.data.show ? "block" : "none");
                break;
            case 'updateStatusHud':
                $("#boxSetHealth").css("width", event.data.health + "%");
                $("#boxSetArmour").css("width", event.data.armour + "%");
                $("#boxSetHunger").css("width", event.data.hunger + "%");
                $("#boxSetThirst").css("width", event.data.thirst + "%");
                break;
            case 'updateHudData':
                $("#playerCash").html(event.data.playerCash);
                $("#playerName").html(event.data.playerName + " | " + event.data.id);
                if (event.data.data.job.name != 'unemployed') {
                    $("#job").css("display", "block");
                    $("#boxSetJob").attr("src", "icons/" + event.data.data.job.name + ".png");
                } else {
                    $("#job").css("display", "none");
                }
                if (event.data.data.gang.name != 'nogang') {
                    $("#gang").css("display", "block");
                } else {
                    $("#gang").css("display", "none");
                }
                break;
            case 'updateCash':
                $("#playerCash").html(event.data.cash);
                break;
            case 'updatePing':
                if (event.data.ping < 95) {
                    $("#ping").css("color", "green");
                } else if (event.data.ping >= 95 && event.data.ping < 150) {
                    $("#ping").css("color", "orange");
                } else {
                    $("#ping").css("color", "darkred");
                }
                $("#ping").html(event.data.ping);
                break;
            case 'updateJob':
                if (event.data.data.name != 'unemployed') {
                    $("#job").css("display", "block");
                    $("#boxSetJob").attr("src", "icons/" + event.data.data.name + ".png");
                } else {
                    $("#job").css("display", "none");
                }
                break;
            case 'updateGang':
                if (event.data.data.name != 'nogang') {
                    $("#gang").css("display", "block");
                } else {
                    $("#gang").css("display", "none");
                }
                break;
            default:
                console.log("Incorect information data");
                break;
        }
    });

    function updateClock() {
        var now = new Date(),
            time = (now.getHours() < 10 ? '0' : '') + now.getHours() + ':' + (now.getMinutes() < 10 ? '0' : '') + now.getMinutes();
        $("#time").html(time);
        setTimeout(updateClock, 1000);
    }

    updateClock();

    function addClassToBody(cl) {
        $("body").addClass(cl);
    }

    function removeClassToBody(cl) {
        $("body").removeClass(cl);
    }
});