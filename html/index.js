$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://lp_vehcontrol/exit', JSON.stringify({}));
            return
        }
    };

    //Türen
    $("#doorsFrontLeft").click(function () {
        $.post('http://lp_vehcontrol/openfleft', JSON.stringify({}));
        return
    })
    $("#doorsFrontRight").click(function () {
        $.post('http://lp_vehcontrol/openfright', JSON.stringify({}));
        return
    })
    $("#doorsRearLeft").click(function () {
        $.post('http://lp_vehcontrol/openRleft', JSON.stringify({}));
        return
    })
    $("#doorsRearRight").click(function () {
        $.post('http://lp_vehcontrol/openRright', JSON.stringify({}));
        return
    })

    //Fenster
    $("#windowFrontLeft").click(function () {
        $.post('http://lp_vehcontrol/windowone', JSON.stringify({}));
        return
    })
    $("#windowFrontRight").click(function () {
        $.post('http://lp_vehcontrol/windowtwo', JSON.stringify({}));
        return
    })
    $("#windowRearLeft").click(function () {
        $.post('http://lp_vehcontrol/windowthree', JSON.stringify({}));
        return
    })
    $("#windowRearRight").click(function () {
        $.post('http://lp_vehcontrol/windowfour', JSON.stringify({}));
        return
    })

    //Sitze
    $("#seatFrontLeft").click(function () {
        $.post('http://lp_vehcontrol/setone', JSON.stringify({}));
        return
    })
    $("#seatFrontRight").click(function () {
        $.post('http://lp_vehcontrol/settwo', JSON.stringify({}));
        return
    })
    $("#seatRearLeft").click(function () {
        $.post('http://lp_vehcontrol/setthree', JSON.stringify({}));
        return
    })
    $("#seatRearRight").click(function () {
        $.post('http://lp_vehcontrol/setfour', JSON.stringify({}));
        return
    })

    //Extras
    $("#extrasInteriorLight").click(function () {
        $.post('http://lp_vehcontrol/interiorLight', JSON.stringify({}));
        return
    })
    $("#extrasFrontHood").click(function () {
        $.post('http://lp_vehcontrol/extrasFrontHood', JSON.stringify({}));
        return
    })
    $("#extrasRearHood").click(function () {
        $.post('http://lp_vehcontrol/extrasRearHood', JSON.stringify({}));
        return
    })
    $("#extrasRearHood2").click(function () {
        $.post('http://lp_vehcontrol/extrasRearHood2', JSON.stringify({}));
        return
    })
})