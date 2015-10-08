private ["_cfg"];

if (GET_CONFIG_BY_MOD) then {
  //mod basiert
  _cfg = "(
   (getNumber (_x >> 'scope') >= 2) &&
   {configSourceMod(_x) in ACTIVE_MODLIST}
  )" configClasses (configFile >> "CfgWeapons");
} else {
  //alle daten inkl. evtl. nicht möglichen
  _cfg = "(
    (getNumber (_x >> 'scope') >= 2)
  )" configClasses (configFile >> "CfgWeapons");
};

[format["Found %1 cfgWeapon Objects",count(_cfg)]] call ADL_DEBUG;

_allMan = [] call ADL_SPAWN_MAN;

//parents
//HELMET    ["ARC_GER_Flecktarn_Helmet_simple","H_HelmetB","ItemCore","Default"]
//VEST      ["ARC_GER_Flecktarn_rangemaster_belt","V_Rangemaster_belt","Vest_NoCamo_Base","ItemCore","Default"]
//  containerclass = "Supply80";
//UNIFORM   ["ARC_GER_Flecktarn_Uniform_Light","Uniform_Base","ItemCore","Default"]


//https://community.bistudio.com/wiki/Arma_3_Characters_And_Gear_Encoding_Guide#Vest_configuration
//https://community.bistudio.com/wiki/Arma_3_Weapon_Config_Guidelines

for[{_i = 1}, {_i < count(_cfg)}, {_i=_i+1}] do
{

  //default pos (diff only helmet)
  player setPosASL [0.0855641,-1.7,4.2];

  {
    removeAllWeapons _x;
    removeAllItems _x;
    removeAllAssignedItems _x;
    removeUniform _x;
    removeVest _x;
    removeBackpack _x;
    removeHeadgear _x;
  } forEach _allMan;

  _class = configName(_cfg select _i);
  hint _class;

//ARC_GER_Flecktarn_Uniform_Light
  _allParents = [(configFile >> "CfgWeapons" >> _class), true] call BIS_fnc_returnParents;
  //UNIFORM
  if ("Uniform_Base" in _allParents) then {
    {
        _x forceAddUniform _class;
    } forEach _allMan;
  };
  if (count (_allParents - ["Vest_NoCamo_Base","Vest_Camo_Base"]) < count _allParents) then {
    {
        _x addVest _class;
    } forEach _allMan;
  };
  if (count (_allParents - ["H_HelmetIA","H_HelmetB","H_HelmetB_paint","H_HelmetB_light"]) < count _allParents) then {
    {
        _x addHeadgear _class;
    } forEach _allMan;
    player setPosASL [0.0855641,-1.4,5.2];
  };


  _mod = if (configSourceMod(configFile >> "CfgWeapons" >> _class) == "") then { "vanilla"; } else { configSourceMod(configFile >> "CfgWeapons" >> _class); };

  _displayName = [(getText(configFile >> "CfgWeapons" >> _class >> "displayName")),"&","&amp;"] call FNC_REPLACE;
  _hiddenSel = getArray((_cfg select _i) >> "hiddenSelections");
  _hiddelSelTex = getArray((_cfg select _i) >> "hiddenSelectionsTextures");
  _model = getText(configFile >> "CfgWeapons" >> _class >> "model");

  _model = getText(configFile >> "CfgWeapons" >> _class >> "model");
  _allowedslots = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "allowedslots");
  _armor = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "armor");
  _mass = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "mass");
  _modelsides  = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "modelsides");
  _passthrough = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "passthrough");
  _uniformModel = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "uniformModel");
  _uniformClass = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "uniformClass");
  _containerClass = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "containerClass");
  _hiddenselectionsItemInfo = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "hiddenselections");

  hint parseText format ["
    <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%1</t><br/>
    <t align='center' color='#666666'>------------------------------</t><br/><br/>
    <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%2</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%3'/></t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%4</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%5</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%6</t><br/>
    ",
       _class,
       _displayName,
       getText(configFile >> "CfgWeapons" >> _class >> "picture"),
       str _armor + "/" + str _passthrough,
       _containerClass,
       _mod];

  //TODO
  //default equip if
  //space (count maps per uniform/vest)

  sleep 1;
  [_class] call ADL_DEBUG;

  if  (DEBUG_EXIT && _i > DEBUG_COUNT) exitWith { true; };
};
