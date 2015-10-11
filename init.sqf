DEBUG_OUTPUT = true;
ADL_DEBUG = compile preprocessFileLineNumbers "fnc_debug.sqf";
ADL_DRAW_CHART = compile preprocessFileLineNumbers "fnc_drawChart.sqf";
ADL_PL_POS = compile preprocessFileLineNumbers "fnc_setPlayerPos.sqf";
FNC_SCR_CAP = compile preprocessFileLineNumbers "fnc_makeScreen.sqf";
FNC_SHOW_BOUNDINGBOX = compile preprocessFileLineNumbers "fnc_showBoundingBox.sqf";
FNC_ROTATE = compile preprocessFileLineNumbers "fnc_rotate.sqf";
FNC_ROTATE_SIMPLE = compile preprocessFileLineNumbers "fnc_rotate_simple.sqf";

FNC_REPLACE = compile preprocessFileLineNumbers "fnc_replace.sqf";
FNC_CONV_ARRAY_LIST = compile preprocessFileLineNumbers "fnc_arrayToList.sqf";

ADL_CLEAN_UP = compile preprocessFileLineNumbers "fnc_cleanUp.sqf";
ADL_SPAWN_OBJ = compile preprocessFileLineNumbers "fnc_spawnObject.sqf";
ADL_SPAWN_MAN = compile preprocessFileLineNumbers "fnc_spawnMan.sqf";
ADL_SPAWN_WHOLDER = compile preprocessFileLineNumbers "fnc_spawnWHolder.sqf";
ADL_SPAWN_MAN_WHOLDER = compile preprocessFileLineNumbers "fnc_spawnManAndWHolder.sqf";
ADL_EXCLUDE = compile preprocessFileLineNumbers "exclude_classes.sqf";

PIC_PATH = "C:\Users\Shura\Pictures\cfgConfig\";
PIC_EXT = ".png";

GEN_cfgVehicles = false;
GEN_cfgWeapons = true;

//only mods ? which modfolder(s) named like installed
GET_CONFIG_BY_MOD = true;
ACTIVE_MODLIST =  ['@arc_gerup'];
//enable screen shots
ENABLE_SCREEN = true;

//exclude objects from array in "exclude_classes.sqf"
EXCLUDE_OBJECTS = false;

//exit after count
DEBUG_EXIT = false;
DEBUG_COUNT = 25;

//turn off environment
enableEnvironment false;

waitUntil {!isNil "bis_fnc_init"};
removeAllWeapons player;
//showHUD false; //stance wird noch immer gezeigt
sleep (3);

setWind [-25, 0, true]; //for flags
0 setWindDir 270;

player allowDamage false;
player enableSimulation false;

//wait until tfar
sleep 5;

if (GEN_cfgVehicles) then {
  //cfgVehicle
  script_handler = [] spawn compile preprocessFileLineNumbers "fnc_getConfigVehicle.sqf";
  waitUntil { scriptDone script_handler };
};
if (GEN_cfgWeapons) then {
  //cfgWeapons
  script_handler = [] spawn compile preprocessFileLineNumbers "fnc_getConfigWeapon.sqf";
  waitUntil { scriptDone script_handler };
};
