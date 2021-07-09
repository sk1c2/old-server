let open = false
let oxygenDisplay = false

window.addEventListener('message', function (event) {
	switch (event.data.action) {
        case 'charLoaded':
            $("body").css({"display" : "block"});
            break;
        case 'updateStatusHud':
            updateStatusLevel(event.data.health, $("#boxSetHealth"));
            updateStatusLevel(event.data.armour, $("#boxSetArmour"));
            updateStatusLevel(event.data.hunger, $("#boxSetHunger"));
            updateStatusLevel(event.data.thirst, $("#boxSetThirst"));
            updateStatusLevel(event.data.stamina, $("#boxSetStamina"));
            updateStatusLevel(event.data.stress, $("#boxSetStress"));
            break;
        case 'setVoice':
            setVoiceDistance(event.data.voice);
            break;
        case 'talking':
            if (event.data.isTalking == 0){
                $("#boxSetProximity").css({"background-color" : "rgb(158, 158, 158)"});
            }else{
                $("#boxSetProximity").css({"background-color" : "rgb(84, 84, 84)"});
            }
            break;
        case 'inWater':
            displayOxygen(event.data.oxygen);
            break;
        case 'outWater':
            hideOxygen();
            break;
        case 'updateCarHud':
            if(event.data.showhud){
                $('.huds').fadeIn();
                setProgressSpeed(event.data.speed,'.progress-speed');
            } else {
                $('.huds').fadeOut();
            }

            // Cruise Control Colour
            if(event.data.cruise){
                $('#cruiseText').css({"color" : "rgba(12, 230, 12, 0.8"});
            }else{
                $('#cruiseText').css({"color" : "#FFFFFF"});
            }

            if(event.data.seatbelt){
                $('#seatbeltText').css({"color" : "rgba(12, 230, 12, 0.8"});
            }else{
                $('#seatbeltText').css({"color" : "rgba(225, 12, 12, 0.8)"});
            }
            // Fuel
            if(event.data.showfuel){
                setProgressFuel(event.data.fuel,'.progress-fuel');

                if((event.data.fuel > 10 && event.data.fuel <= 20) && !$('.fuel').hasClass('orangeStroke')){
                    if($('.fuel').hasClass('redStroke')) {
                        $('.fuel').removeClass('redStroke');
                    }
                    $('.fuel').addClass('orangeStroke');
                } else if(event.data.fuel <= 10 && !$('.fuel').hasClass('redStroke')){
                    if($('.fuel').hasClass('orangeStroke')) {
                        $('.fuel').removeClass('orangeStroke');
                    }
                    $('.fuel').addClass('redStroke');
                } else if($('.fuel').hasClass('orangeStroke') || $('.fuel').hasClass('redStroke')) {
                    $('.fuel.orangeStroke').removeClass('orangeStroke');
                    $('.fuel.redStroke').removeClass('redStroke');
                }
            }
            break;

        default:
    }
});

function updateStatusLevel(value, ele) {
    let height = 38;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("height", eleHeight + "px");
    ele.css("top", leftOverHeight + "px");
};

function displayOxygen(oxygen){
    if (!oxygenDisplay){
        $("#varOxygen").css({"display" : "inline-block"});
        oxygenDisplay = true;
    }
    if (oxygen < 25){
        $('#boxSetOxygen').css({"background" : "rgb(220, 12, 12)"});
    }else{
        $('#boxSetOxygen').css({"background" : "rgb(76, 91, 117)"});
    }
    updateStatusLevel(oxygen, $("#boxSetOxygen"));
};

function hideOxygen(){
    if(oxygenDisplay){
        $("#varOxygen").fadeOut(3000);
        oxygenDisplay = false;
    }
};


/* CAR HUD */
function setProgressFuel(percent, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
  }

  // Speed
function setProgressSpeed(value, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value*100/220;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(value);
}

  // Voice
function setVoiceDistance(value){
    var element = $("#varProximity");
    element.removeClass("status-item--voice-shout");
    element.removeClass("status-item--voice-whisper");

    if (value===33){
        element.addClass("status-item--voice-whisper");
    } else if (value===100){
        element.addClass("status-item--voice-shout");
    }
}