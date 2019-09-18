// HOW MANY DECIMALS, IN RANGE. :) Free to edit!
var rangeDecimals = 1;

$(document).ready(function(){
    window.addEventListener('message', function(event) {

        if (event.data.action == 'open') {
            $('#lasergun').show();
            $('#speed').text("NAN");
        } else if (event.data.action == 'close') {
            $('#lasergun').hide();
        }

        $('#speed').text(event.data.speed);
        $('#range').text(round(event.data.range, rangeDecimals));
    });
});


function round(value, precision) {
    var multiplier = Math.pow(10, precision || 0);
    return Math.round(value * multiplier) / multiplier;
}