// ------------------------------------------------------------------
// --                  Developed By MReza
// --               For Persian City Fivem Server
// --                 Discord: mrezaa
// ------------------------------------------------------------------
var BankCooldown = false;
var CBankCooldown = false;
var JeweleryCd = false;

$(function() {
    // Title Fade
    var ih = 0;
    setInterval(function() {
        $('.header h3').fadeOut();
        $(".header h3:eq(" + ih + ")").fadeIn();
        if (ih == 1) {
            ih = 0;
        } else {
            ih++;
        };
    }, 4000);
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'toggle':
                $("body").css("display", event.data.show ? "block" : "none");
                break;
            case 'close':
                $("body").css("display", "none");
                break;
            case 'updatePlayers':
                $('#Vcount').html(event.data.count);
                break;
            case 'updateQueue':
                $('#Vqueue').html(event.data.count);
                break;
            case 'updateAdmins':
                $('#Vadmins').html(event.data.count);
                break;
            case 'updateId':
                $('#Vid').html(event.data.data);
                break;
            case 'updateInfo':
                if (event.data.data) {
                    var JobData = event.data.data;
                    for (var k in JobData) {
                        $(`.${k} p`).html(JobData[k]);
                        if (k == "police") {
                            Jewelery(JobData[k]);
                            Bank(JobData[k]);
                            CBank(JobData[k]);
                            Shop(JobData[k]);

                        }
                    };
                };
                break;
            case 'updateBanksCd':
                if (event.data.data) {
                    var bdata = event.data.data;
                    if (bdata.lastrobbed) {
                        CBankCooldown = true;
                        BankCooldown = true;
                    } else {
                        if (bdata.CBank != 0 && bdata.CBank < 14400) {
                            CBankCooldown = true;
                            BankCooldown = false;
                        } else {
                            CBankCooldown = false;
                            BankCooldown = false;
                        };
                    };
                };
                break;
            case 'updateJeweleryCd':
                if (event.data.data != 0 && event.data.data < 6600) {
                    JeweleryCd = true;
                } else {
                    JeweleryCd = false;
                }
                break;
            default:
                console.log('[sr_scoreboard]: Unknown Action!');
                break;
        };
    }, false);
});

function Jewelery(cops) {
    if (cops >= 5) {
        if (!JeweleryCd) {
            $(`.jewelery`).css('border', '2px #ffffff solid');
            $(`.jewelery img`).attr('src', './images/Robb/JewelryActive.png');
            $(`.jewelery`).addClass('glow');
        } else {
            $(`.jewelery`).css('border', '2px #701212 solid');
            $(`.jewelery img`).attr('src', './images/Robb/JewelryDown.png');
            $(`.jewelery`).removeClass('glow');
        };
    } else {
        $(`.jewelery`).css('border', '2px #858585 solid');
        $(`.jewelery img`).attr('src', './images/Robb/JewelryDeactive.png');
        $(`.jewelery`).removeClass('glow');
    };
};

function Bank(cops) {
    if (cops >= 8) {
        if (!BankCooldown) {
            $(`.bank`).css('border', '2px #ffffff solid');
            $(`.bank img`).attr('src', './images/Robb/BankActive.png');
            $(`.bank`).addClass('glow');
        } else {
            $(`.bank`).css('border', '2px #701212 solid');
            $(`.bank img`).attr('src', './images/Robb/BankDown.png');
            $(`.bank`).removeClass('glow');
        };
    } else {
        $(`.bank`).css('border', '2px #858585 solid');
        $(`.bank img`).attr('src', './images/Robb/BankDeactive.png');
        $(`.bank`).removeClass('glow');
    };
};

function CBank(cops) {
    if (cops >= 10) {
        if (!CBankCooldown) {
            $(`.centeralbank`).css('border', '2px #ffffff solid');
            $(`.centeralbank img`).attr('src', './images/Robb/CBankActive.png');
            $(`.centeralbank`).addClass('glow');
        } else {
            $(`.centeralbank`).css('border', '2px #701212 solid');
            $(`.centeralbank img`).attr('src', './images/Robb/CBankDown.png');
            $(`.centeralbank`).removeClass('glow');
        };
    } else {
        $(`.centeralbank`).css('border', '2px #858585 solid');
        $(`.centeralbank img`).attr('src', './images/Robb/CBankDeactive.png');
        $(`.centeralbank`).removeClass('glow');
    };
};

function Shop(cops) {
    if (cops >= 2) {
        $(`.shop`).css('border', '2px #ffffff solid');
        $(`.shop img`).attr('src', './images/Robb/ShopActive.png');
        $(`.shop`).addClass('glow');
    } else {
        $(`.shop`).css('border', '2px #858585 solid');
        $(`.shop img`).attr('src', './images/Robb/ShopDeactive.png');
        $(`.shop`).removeClass('glow');
    };
};