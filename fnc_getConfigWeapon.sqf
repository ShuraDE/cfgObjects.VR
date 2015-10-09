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

//parents
//HELMET    ["ARC_GER_Flecktarn_Helmet_simple","H_HelmetB","ItemCore","Default"]
//VEST      ["ARC_GER_Flecktarn_rangemaster_belt","V_Rangemaster_belt","Vest_NoCamo_Base","ItemCore","Default"]
//  containerclass = "Supply80";
//UNIFORM   ["ARC_GER_Flecktarn_Uniform_Light","Uniform_Base","ItemCore","Default"]

_allMan = [] call ADL_SPAWN_MAN;
//https://community.bistudio.com/wiki/Arma_3_Characters_And_Gear_Encoding_Guide#Vest_configuration
//https://community.bistudio.com/wiki/Arma_3_Weapon_Config_Guidelines

for[{_i = 1}, {_i < count(_cfg)}, {_i=_i+1}] do
{
  _hint_txt_4 = "unknown";
  _hint_txt_5 = "unknown";
  _hint_txt_6 = "unknown";

  _isEquip = false;
  _isWeapon = false;

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

  _allParents = [(configFile >> "CfgWeapons" >> _class), true] call BIS_fnc_returnParents;
  //UNIFORM
  if ("Uniform_Base" in _allParents) then {
    _isEquip = true;
    {
        _x forceAddUniform _class;
    } forEach _allMan;
  };
  if (count (_allParents - ["Vest_NoCamo_Base","Vest_Camo_Base"]) < count _allParents) then {
    _isEquip = true;
    {
        _x addVest _class;
    } forEach _allMan;
  };
  if (count (_allParents - ["H_HelmetIA","H_HelmetB","H_HelmetB_paint","H_HelmetB_light"]) < count _allParents) then {
    _isEquip = true;
    {
        _x addHeadgear _class;
    } forEach _allMan;
    player setPosASL [0.0855641,-1.4,5.2];
  };
  if ("RifleCore" in _allParents) then {
    _isWeapon = true;
    {
        _x addWeapon _class;
    } forEach _allMan;
  };
  if ("LauncherCore" in _allParents) then {
    _isWeapon = true;
    {
        _x addWeapon "FakeWeapon";
        _x addWeapon _class;
    } forEach _allMan;
  };



  _mod = if (configSourceMod(configFile >> "CfgWeapons" >> _class) == "") then { "vanilla"; } else { configSourceMod(configFile >> "CfgWeapons" >> _class); };

  _displayName = [(getText(configFile >> "CfgWeapons" >> _class >> "displayName")),"&","&amp;"] call FNC_REPLACE;
  _hiddenSel = getArray((_cfg select _i) >> "hiddenSelections");
  _hiddelSelTex = getArray((_cfg select _i) >> "hiddenSelectionsTextures");
  _model = getText(configFile >> "CfgWeapons" >> _class >> "model");
  _UiPicture = getText(configFile >> "CfgWeapons" >> _class >> "UiPicture");
  _picture = getText(configFile >> "CfgWeapons" >> _class >> "picture");
  _descriptionShort = getText(configFile >> "CfgWeapons" >> _class >> "descriptionShort");
  _inertia = getNumber(configFile >> "CfgWeapons" >> _class >> "inertia");
  _type = getNumber(configFile >> "CfgWeapons" >> _class >> "type");

  //global
  _ItemInfo_mass = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "mass");
  _ItemInfo_RMBhint = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "RMBhint");
  _ItemInfo_weaponInfoType = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "weaponInfoType");
  _ItemInfo_onHoverText = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "onHoverText");
  _ItemInfo_priority = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "priority");

  //uniform/vest etc
  _ItemInfo_allowedslots = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "allowedslots");
  _ItemInfo_armor = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "armor");
  _ItemInfo_modelsides  = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "modelsides");
  _ItemInfo_passthrough = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "passthrough");
  _ItemInfo_uniformModel = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "uniformModel");
  _ItemInfo_uniformClass = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "uniformClass");
  _ItemInfo_containerClass = getText(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "containerClass");
  _ItemInfo_hiddenselectionsItemInfo = getArray(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "hiddenselections");

  //weapons
  _dexterity = getNumber(configFile >> "CfgWeapons" >> _class >> "dexterity");
  _modes = getArray(configFile >> "CfgWeapons" >> _class >> "modes");
  _magazines = getArray(configFile >> "CfgWeapons" >> _class >> "magazines");
  _magazineReloadTime = getNumber(configFile >> "CfgWeapons" >> _class >> "magazineReloadTime");
	_reloadTime = getNumber(configFile >> "CfgWeapons" >> _class >> "reloadTime");
	_initSpeed = getNumber(configFile >> "CfgWeapons" >> _class >> "initSpeed");
  _autoReload = getNumber(configFile >> "CfgWeapons" >> _class >> "autoReload");
  _autoFire = getNumber(configFile >> "CfgWeapons" >> _class >> "autoFire");
  _autoAimEnabled = getNumber(configFile >> "CfgWeapons" >> _class >> "autoAimEnabled");
  _UiPicture = getText(configFile >> "CfgWeapons" >> _class >> "UiPicture");
  if (isNumber(configFile >> "CfgWeapons" >> _class >> "burst")) then {
    _burst = getNumber(configFile >> "CfgWeapons" >> _class >> "burst");
  } else {
    _burst = 0;
  };

  _WeaponSlotsInfo_mass = getNumber(configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "mass");
  _WeaponSlotsInfo_allowedSlots = getArray(configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "allowedSlots");

  _ItemInfo_deployedPivot = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "deployedPivot");
  _ItemInfo_hasBipod = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "hasBipod");
  _ItemInfo_type = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "type");
  _ItemInfo_opticType = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "opticType");
  _ItemInfo_optics = getNumber(configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "optics");

  _optics = getNumber(configFile >> "CfgWeapons" >> _class >> "optics");
	_forceOptics = getNumber(configFile >> "CfgWeapons" >> _class >> "forceOptics");
	_lockAcquire = getNumber(configFile >> "CfgWeapons" >> _class >> "lockAcquire");
	_canLock = getNumber(configFile >> "CfgWeapons" >> _class >> "canLock");
  _canDrop = getNumber(configFile >> "CfgWeapons" >> _class >> "canDrop");
	_weaponLockDelay = getNumber(configFile >> "CfgWeapons" >> _class >> "weaponLockDelay");
	_opticsZoomMin = getNumber(configFile >> "CfgWeapons" >> _class >> "opticsZoomMin");
	_opticsZoomMax = getNumber(configFile >> "CfgWeapons" >> _class >> "opticsZoomMax");
	_opticsZoomInit = getNumber(configFile >> "CfgWeapons" >> _class >>  "opticsZoomInit");
	_opticsPPEffects= getArray(configFile >> "CfgWeapons" >> _class >>  "opticsPPEffects");

  _aiRateOfFire = getNumber(configFile >> "CfgWeapons" >> _class >> "aiRateOfFire");
	_aiRateOfFireDistance = getNumber(configFile >> "CfgWeapons" >> _class >> "aiRateOfFireDistance");
	_minRange = getNumber(configFile >> "CfgWeapons" >> _class >> "minRange");
	_minRangeProbab = getNumber(configFile >> "CfgWeapons" >> _class >> "minRangeProbab");
	_midRange = getNumber(configFile >> "CfgWeapons" >> _class >>  "midRange");
	_midRangeProbab = getNumber(configFile >> "CfgWeapons" >> _class  >> "midRangeProbab");
	_maxRange = getNumber(configFile >> "CfgWeapons" >> _class >> "maxRange");
	_maxRangeProbab = getNumber(configFile >> "CfgWeapons" >> _class >> "maxRangeProbab");


  //weapons
  //class LinkedItemsOptic	-	class LinkedItemsAcc - class LinkedItemsMuzzle - class LinkedItemsUnder
  _classLinkedItems = (configFile >> "CfgWeapons" >> _class >> "LinkedItems");
  _classWeaponSlotsInfo = (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo");

  _classMuzzleSlot = (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "MuzzleSlot");
  _classCowsSlot = (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "CowsSlot");
  _classPointerSlot = (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "PointerSlot");
  _classUnderBarrelSlot = (configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "UnderBarrelSlot");

  _classOpticsModes = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "OpticsModes");
  _classPointer = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "Pointer");
  _classMagazineCoef = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "FlashLight");
  _classFlashLight = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "MagazineCoef");
  _classAmmoCoef = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "AmmoCoef");
  _classMuzzleCoef = (configFile >> "CfgWeapons" >> _class >> "ItemInfo" >> "MuzzleCoef");


  if (_isEquip) then {
    _hint_txt_4 = str _ItemInfo_armor + "/" + str _ItemInfo_passthrough;
    _hint_txt_5 = _containerClass;
    _hint_txt_6 = str _ItemInfo_mass;
  };

  if (_isWeapon) then {
    _hint_txt_4 = str _minRange + " - " + str _midRange + " - " + str _maxRange;
    _hint_txt_5 = str _modes;
    _hint_txt_6 = str _WeaponSlotsInfo_mass;
  };

  hint parseText format ["
    <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%1</t><br/>
    <t align='center' color='#666666'>------------------------------</t><br/><br/>
    <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%2</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%3'/></t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%4</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%5</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%6</t><br/>
    <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%7</t><br/>
    ",
       _class,
       _displayName,
       getText(configFile >> "CfgWeapons" >> _class >> "picture"),
       _hint_txt_4,
       _hint_txt_5,
       _hint_txt_6,
       _mod];



  //TODO
  //default equip if
  //space (count maps per uniform/vest)

  sleep 1;
  [_class] call ADL_DEBUG;

  if  (DEBUG_EXIT && _i > DEBUG_COUNT) exitWith { true; };
};
