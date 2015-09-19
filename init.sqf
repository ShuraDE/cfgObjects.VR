DEBUG_OUTPUT = true;
ADL_DEBUG = compile preprocessFileLineNumbers "fnc_debug.sqf";
ADL_DRAW_CHART = compile preprocessFileLineNumbers "fnc_drawChart.sqf";
ADL_PL_POS = compile preprocessFileLineNumbers "fnc_setPlayerPos.sqf";
FNC_SCR_CAP = compile preprocessFileLineNumbers "fnc_makeScreen.sqf";
FNC_SHOW_BOUNDINGBOX = compile preprocessFileLineNumbers "fnc_showBoundingBox.sqf";
FNC_ROTATE = compile preprocessFileLineNumbers "fnc_rotate.sqf";

FNC_REPLACE = compile preprocessFileLineNumbers "fnc_replace.sqf";

ADL_CLEAN_UP = compile preprocessFileLineNumbers "fnc_cleanUp.sqf";
ADL_SPAWN_OBJ = compile preprocessFileLineNumbers "fnc_spawnObject.sqf";

ADL_EXCLUDE = compile preprocessFileLineNumbers "exclude_classes.sqf";

PIC_PATH = "C:\Users\Shura\Documents\Arma 3\scrcap\cfgConfig\vanilla\";
PIC_EXT = ".png";

//default distance
//PLAYER_DEFAULT_DIST = 10;
 
//exit after count
DEBUG_EXIT = false;
DEBUG_COUNT = 5;

//enable screen shots
ENABLE_SCREEN = false;

//exclude objects from array in "exclude_classes.sqf"
EXCLUDE_OBJECTS = false;

waitUntil {!isNil "bis_fnc_init"};
removeAllWeapons player;
//showHUD false; //stance wird noch immer gezeigt
sleep (3);

setWind [-25, 0, true];
0 setWindDir 270;

player allowDamage false;
player enableSimulation false;

//wait until tfar
sleep 5;

[] spawn compile preprocessFileLineNumbers "fnc_getConfig.sqf";
