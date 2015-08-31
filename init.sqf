DEBUG_OUTPUT = true;
ADL_DEBUG = compile preprocessFileLineNumbers "fnc_debug.sqf";
ADL_DRAW_CHART = compile preprocessFileLineNumbers "fnc_drawChart.sqf";
ADL_PL_POS = compile preprocessFileLineNumbers "fnc_setPlayerPos.sqf";
FNC_SCR_CAP = compile preprocessFileLineNumbers "fnc_makeScreen.sqf";
FNC_SHOW_BOUNDINGBOX = compile preprocessFileLineNumbers "fnc_showBoundingBox.sqf";



PIC_PATH = "D:\Users\Shura\Pictures\arma\";
PIC_EXT = ".png";

PLAYER_DEFAULT_DIST = 10;

ENABLE_2ND_VEH_TD = true;
ENABLE_SCREEN = false;

waitUntil {!isNil "bis_fnc_init"};
removeAllWeapons player;
//showHUD false; //stance wird noch immer gezeigt
sleep (3);

player allowDamage false;
player enableSimulation false;
[] spawn compile preprocessFileLineNumbers "fnc_getConfig.sqf";
