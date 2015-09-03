/*
* name (is klar)
* source / enthalten in mod x
* cargo
* crew
* coordinaten system für attach to
* armour / speed
* bounding boxes
* audible
* breakdistance
* camouflage
* selectionNames
* displayName (edited)

https://community.bistudio.com/wiki/CfgVehicles_Config_Reference
configProperties [configFile >> "CfgVehicles" >> "O_Truck_02_box_F"];
*/

//turn off environment
enableEnvironment false;
_scr = false;

//scope == 0 private, 1 internal/protected, 2 public

//some mods havnt define correct vehicleClass like ""land_Objects84","House","SAR_ru_architect""
// genMacro is "House", vehcileClass "SAR_ru_architect"
_cfg_x= "(
  (getNumber (_x >> 'scope') >= 2) &&
  {getText (_x >> '_generalMacro') in ['House','NonStrategic']
    ||
    {getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air', 'Ship', 'Static','Objects','Support','Items','Structures','Wrecks','Fortifications','misc','Misc','A3_Trees','A3_Stones','A3_Plants','A3_Bush','Flag','Training','Objects_Sports','Structures_Sports','Structures_VR','Furniture','Cargo','Tents','Small_items','Dead_bodies','Garbage','Structures_Town','Military','Market','Objects_Airport','Container','Helpers','ItemsUniforms','ItemsHeadgear','ItemsVests','WeaponAccessories','Backpacks','Schild','Signs','Structures_Walls','Structures_Fences']}
  }
)" configClasses (configFile >> "CfgVehicles");

//für testzwecke reduzierte daten
_cfg = "(
  (getNumber (_x >> 'scope') >= 2) &&
    {getText (_x >> 'vehicleClass') in ['Car']}
)" configClasses (configFile >> "CfgVehicles");

//alle daten inkl. nicht möglichen
_cfgAll = "(
  (getNumber (_x >> 'scope') >= 2)
)" configClasses (configFile >> "CfgVehicles");

_cfgExcludeArray = [] call ADL_EXCLUDE;
_cfgSkippedObjects = [];

[format["Found %1 Objects",count(_cfg)]] call ADL_DEBUG;

["Export Data:"] call ADL_DEBUG;
["[className,_generalMacro,vehicleClass,displayName,[availableForSupportTypes],[weapons],[magazines],textSingular,[BASE],side,model,parent,timeToLive,mod_folder]", "def_001"] call ADL_DEBUG;

["[faction,crew,picture,icon,slingLoadCargoMemoryPoints,crewCrashProtection,crewExplosionProtection,numberPhysicalWheels,tracksSpeed,CommanderOptics,maxGForce,fireResistance,airCapacity,tf_hasLRradio,author]", "def_002"] call ADL_DEBUG;

["[[cargoIsCoDriver],transportSoldier,transportVehicleCount,transportAmmo,transportFuel,transportRepair,maximumLoad,transportMaxMagazines,transportMaxWeapons,transportMaxBackpacks]", "def_003"] call ADL_DEBUG;

["[fuelCapacity,armor,audible,accuracy,camouflage,accerleration,brakeDistance,maxSpeed,minSpeed,[hiddenSelections],[hiddenSelectionsTextures]]", "def_004"] call ADL_DEBUG;

["[armorStructural,armorFuel,armorGlass,armorLights,armorWheels,armorHull,armorTurret,armorGun,armorEngine,armorTracks,armorHead,armorHands,armorLegs,armorAvionics,armorVRotor,armorHRotor,armorMissiles]","def_005"] call ADL_DEBUG;

["[[_maxWidth,_maxLength,_maxHeight],[_radius2D,_radius3D],[_worldWidth,_worldLength,_worldHeight],[bbox_p1, bbox_p2]]","def_006"] call ADL_DEBUG;

["_scrshot_file","exp_scr"] call ADL_DEBUG;

//configSourceMod(configFile >> "CfgVehicles" >> "Item_optic_KHS_hex")
//lol

for[{_i = 1}, {_i < count(_cfg)}, {_i=_i+1}] do
{
  _class = configName(_cfg select _i);

  if (EXCLUDE_OBJECTS && _class in _cfgExcludeArray) then {
    //skip
    _cfgSkippedObjects = _cfgSkippedObjects + [_class];
  } else {

    _genMac = getText((_cfg select _i) >> "_generalMacro");
    _type = getText((_cfg select _i) >> "vehicleClass");
    _description = getText((_cfg select _i) >> "displayName");
    _roles = getArray((_cfg select _i) >> "availableForSupportTypes");
    _weapons = getArray((_cfg select _i) >> "weapons");
    _magazines = getArray((_cfg select _i) >> "magazines");
    _type2 = getText((_cfg select _i) >> "textSingular");
    _filter = toArray("BASE");
    _side = getNumber((_cfg select _i) >> "side");
    _model = getText((_cfg select _i) >> "model");
    _parent = inheritsFrom (configFile >> "CfgVehicles" >> _class);
    _vehicleClass = getText((_cfg select _i) >> "vehicleClass");
    _ttl = getNumber((_cfg select _i) >> "timeToLive");
    _mod = configSourceMod(_cfg select _i);

    _faction = getText((_cfg select _i) >> "faction");
    _crew = getNumber((_cfg select _i) >> "crew");
    _picture = getText((_cfg select _i) >> "picture");
    _icon = getText((_cfg select _i) >> "icon");
    _slingLoadCargoMemoryPoints = getText((_cfg select _i) >> "slingLoadCargoMemoryPoints");
    _crewCrashProtection = getNumber((_cfg select _i) >> "crewCrashProtection");
    _crewExplosionProtection = getNumber((_cfg select _i) >> "crewExplosionProtection");
    _numberPhysicalWheels = getNumber((_cfg select _i) >> "numberPhysicalWheels");
    _tracksSpeed = getNumber((_cfg select _i) >> "tracksSpeed");
    _CommanderOptics = getText((_cfg select _i) >> "CommanderOptics");
    _maxGForce = getNumber((_cfg select _i) >> "maxGForce");
    _fireResistance = getNumber((_cfg select _i) >> "fireResistance");
    _airCapacity = getNumber((_cfg select _i) >> "airCapacity");
    _tf_hasLRradio = getNumber((_cfg select _i) >> "tf_hasLRradio");
    _author = getText((_cfg select _i) >> "author");


    _cargoCoDriver = getArray((_cfg select _i) >> "cargoIsCoDriver");
    _transportSoldier = getNumber((_cfg select _i) >> "transportSoldier");
    _transportVehicle = getNumber((_cfg select _i) >> "transportVehicleCount");
    _transportAmmo = getNumber((_cfg select _i) >> "transportAmmo");
    _transportFuel = getNumber((_cfg select _i) >> "transportFuel");
    _transportRepair = getNumber((_cfg select _i) >> "transportRepair");
    _maximumLoad = getNumber((_cfg select _i) >> "maximumLoad");
    _transportMaxMagazines = getNumber((_cfg select _i) >> "transportMaxMagazines");
    _transportMaxWeapons = getNumber((_cfg select _i) >> "transportMaxWeapons");
    _transportMaxBackpacks = getNumber((_cfg select _i) >> "transportMaxBackpacks");

    _fuelCap = getNumber((_cfg select _i) >> "fuelCapacity");
    _armour = getNumber((_cfg select _i) >> "armor");
    _audible = getNumber((_cfg select _i) >> "audible");
    _accuracy = getNumber((_cfg select _i) >> "accuracy");
    _camouflage = getNumber((_cfg select _i) >> "camouflage");
    _accerleration = getNumber((_cfg select _i) >> "accerleration");
    _breakDist = getNumber((_cfg select _i) >> "brakeDistance");
    _maxSpeed = getNumber((_cfg select _i) >> "maxSpeed");
    _minSpeed = getNumber((_cfg select _i) >> "minSpeed");
    _hiddenSel = getArray((_cfg select _i) >> "hiddenSelections");
    _hiddelSelTex = getArray((_cfg select _i) >> "hiddenSelectionsTextures");

    // for vehicles general
    _armorStructural =  getNumber((_cfg select _i) >> "armorStructural"); //= 1;	// ranges between 1 and 4.0, default 1
    _armorFuel =  getNumber((_cfg select _i) >> "armorFuel"); // = 1.4;	// default
    _armorGlass =  getNumber((_cfg select _i) >> "armorGlass"); // = 0.5;	// default
    _armorLights =  getNumber((_cfg select _i) >> "armorLights"); // = 0.4;	// default 0.4 in all models.
    _armorWheels =  getNumber((_cfg select _i) >> "armorWheels"); // = 0.05;	// default
    // for tanks
    _armorHull =  getNumber((_cfg select _i) >> "armorHull"); // = 1;
    _armorTurret =  getNumber((_cfg select _i) >> "armorTurret"); // = 0.8;
    _armorGun =  getNumber((_cfg select _i) >> "armorGun"); // = 0.6;
    _armorEngine =  getNumber((_cfg select _i) >> "armorEngine"); // = 0.8;
    _armorTracks =  getNumber((_cfg select _i) >> "armorTracks"); // = 0.6;
    // for men
    _armorHead =  getNumber((_cfg select _i) >> "armorHead"); // = 0.7;
    _armorHands =  getNumber((_cfg select _i) >> "armorHands"); // = 0.5;
    _armorLegs =  getNumber((_cfg select _i) >> "armorLegs"); // = 0.5;
    // additional to helicopters
    _armorEngine =  getNumber((_cfg select _i) >> "armorEngine"); // = 0.6;
    _armorAvionics =  getNumber((_cfg select _i) >> "armorAvionics"); // = 1.4;
    _armorVRotor =  getNumber((_cfg select _i) >> "armorVRotor"); // = 0.5;
    _armorHRotor =  getNumber((_cfg select _i) >> "armorHRotor"); // = 0.7;
    _armorMissiles =  getNumber((_cfg select _i) >> "armorMissiles"); // = 1.6;

    _dataBase = [_class,_genMac,_type,_description,_roles,_weapons,_magazines,_type2,_filter,_side,_model,_parent,_vehicleClass,_ttl,_mod];

    _dataExtend = [_faction,_crew,_picture,_icon,_slingLoadCargoMemoryPoints,_crewCrashProtection,_crewExplosionProtection,_numberPhysicalWheels,_tracksSpeed,_CommanderOptics,_maxGForce,_fireResistance,_airCapacity,_tf_hasLRradio,_author];

    _dataTransport = [_cargoCoDriver,_transportSoldier,_transportVehicle,_transportAmmo,_transportFuel,_transportRepair,_maximumLoad,_transportMaxMagazines,_transportMaxWeapons,_transportMaxBackpacks];

    _dataVehicle = [_fuelCap,_armour,_audible,_accuracy,_camouflage,_accerleration,_breakDist,_maxSpeed,_minSpeed,_hiddenSel,_hiddelSelTex];

    _dataArmor = [_armorStructural,_armorFuel,_armorGlass,_armorLights,_armorWheels,_armorHull,_armorTurret,_armorGun,_armorEngine,_armorTracks,_armorHead,_armorHands,_armorLegs,_armorAvionics,_armorVRotor,_armorHRotor,_armorMissiles];

    /*
    ["data base: " + str(_dataBase)] call ADL_DEBUG;
    ["data trans: " + str(_dataTransport)] call ADL_DEBUG;
    ["data veh: " + str(_dataVehicle)] call ADL_DEBUG;
    */

    [str(_i),"exp_idx"] call ADL_DEBUG;
    [_dataBase, "exp_001"] call ADL_DEBUG;
    [_dataExtend, "exp_002"] call ADL_DEBUG;
    [_dataTransport, "exp_003"] call ADL_DEBUG;
    [_dataVehicle, "exp_004"] call ADL_DEBUG;
    [_dataArmor, "exp_005"] call ADL_DEBUG;

    if (_class != "" && _type != "" && _description != "") then {
      try {

        //create objects, returns major object and sizes
        _objSpawn = [_class] call ADL_SPAWN_OBJ; //rotation wird nicht angezeigt, aber durchgeführt Oo
        _veh = _objSpawn select 0;
        _sizes = _objSpawn select 1;


        [_sizes, "exp_006"] call ADL_DEBUG;

        _scrFile = "";
        if (!isNil("_veh") && (typeName _veh == "OBJECT") && (!(_veh isKindOf "Logic")) && (alive _veh)) then {
           try {
             //take screen shoot if enabled
             if (ENABLE_SCREEN) then {
               sleep 0.5;
               _scrFile = [_class] call FNC_SCR_CAP;
               _scr = true;
             };
             [_scrFile, "exp_scr"]  call ADL_DEBUG;
           }
           catch {
             [_class, "exp_err"] call ADL_DEBUG;
           };
        };
      }
      catch {
          ["**** NO SCREEN ****", "warn"] call ADL_DEBUG;
          [str(_exception)] call ADL_DEBUG;
      };
    };
  };
  if  (DEBUG_EXIT && _i > DEBUG_COUNT) exitWith { true; };
};
["done"] call ADL_DEBUG;
[str(_cfgSkippedObjects), "skipped objects:"] call ADL_DEBUG;
hint ("done with " + str((count(_cfg))-(count(_cfgSkippedObjects))));
