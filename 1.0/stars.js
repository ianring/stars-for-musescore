function init() {};
function run() {

    obj = null;

    if (cursor.isRest()) {
        obj = cursor.rest();
    } 

    if (cursor.isChord() ) {
        obj = cursor.chord();
    }

    var ticklength = obj.tickLen

    var tick = cursor.tick();

    var elongations = {
        '960': 1200,
        '480': 600,
        '240': 300,
        '120': 150
    };


/*
* tick values
* -----------
* starred semibreve (whole)			2400
* starred minim (half)				1200
* starred crotchet (quarter)			600
* starred quaver (eighth)			300
* starred semiquaver (sixteenth)		150
* starred demi-semiquaver (32nd)		75
* starred hemi-demi-semiquaver (64th)	
*/



};
function close() {};
var mscorePlugin = 
{
    majorVersion: 1,
    minorVersion: 1,
    init: init,
    run: run,
    onClose: close,
    menu: 'Plugins.Stars'
};

mscorePlugin;

