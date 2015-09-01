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

_debugTextExit = true;
_scr = false;

//scope == 0 private, 1 internal/protected, 2 public

//some mods havnt define correct vehicleClass like ""land_Objects84","House","SAR_ru_architect""
// genMacro is "House", vehcileClass "SAR_ru_architect"
_cfg_xxx= "(
  (getNumber (_x >> 'scope') >= 2) &&
  {getText (_x >> '_generalMacro') in ['House','NonStrategic']
    ||
    {getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air', 'Ship', 'Static','Objects','Support','Items','Structures','Wrecks','Fortifications','misc','Misc','A3_Trees','A3_Stones','A3_Plants','A3_Bush','Flag','Training','Objects_Sports','Structures_Sports','Structures_VR','Furniture','Cargo','Tents','Small_items','Dead_bodies','Garbage','Structures_Town','Military','Market','Objects_Airport','Container','Helpers','ItemsUniforms','ItemsHeadgear','ItemsVests','WeaponAccessories','Backpacks','Schild','Signs','Structures_Walls','Structures_Fences']}
  }
)" configClasses (configFile >> "CfgVehicles");
_cfg= "(
  (getNumber (_x >> 'scope') >= 2) &&
    {getText (_x >> 'vehicleClass') in ['Car']}
)" configClasses (configFile >> "CfgVehicles");

_cfgAll = "(
  (getNumber (_x >> 'scope') >= 2)
)" configClasses (configFile >> "CfgVehicles");


[format["Found %1 Objects",count(_cfg)]] call ADL_DEBUG;

["Export Data:"] call ADL_DEBUG;
["[className,_generalMacro,vehicleClass,displayName,[availableForSupportTypes],[weapons],[magazines],textSingular,[BASE],side,model,_parent,vehicleClass,timeToLive,[cargoIsCoDriver],transportSoldier,transportVehicleCount,transportAmmo,transportFuel,transportRepair,maximumLoad,transportMaxMagazines,transportMaxWeapons,transportMaxBackpacks,fuelCapacity,armor,audible,accuracy,camouflage,accerleration,brakeDistance,maxSpeed,minSpeed,[hiddenSelections],[hiddenSelectionsTextures],armorStructural,armorFuel,armorGlass,armorLights,armorWheels,armorHull,armorTurret,armorGun,armorEngine,armorTracks,armorHead,armorHands,armorLegs,armorEngine,armorAvionics,armorVRotor,armorHRotor,armorMissiles, [[_maxWidth,_maxLength,_maxHeight],[_radius2D,_radius3D],[_worldLength,_worldWidth,_worldHeight], _bbox],_scrshot_file","exp_def"] call ADL_DEBUG;

for[{_i = 1}, {_i < count(_cfg)}, {_i=_i+1}] do
{
  _class = configName(_cfg select _i);
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

  _faction = getText((_cfg select _i) >> "faction");
  _crew = getNumber((_cfg select _i) >> "crew");
  _picture = getText((_cfg select _i) >> "picture");
  _icon = getText((_cfg select _i) >> "icon");
  _vehicleClass = getText((_cfg select _i) >> "vehicleClass");
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

  _dataBase = [_class,_genMac,_type,_description,_roles,_weapons,_magazines,_type2,_filter,_side,_model,_parent,_vehicleClass,_ttl];

  _dataExtend = [_faction,_crew,_picture,_icon,_vehicleClass,_slingLoadCargoMemoryPoints,_crewCrashProtection,_crewExplosionProtection,_numberPhysicalWheels,_tracksSpeed,_CommanderOptics,_maxGForce,_fireResistance,_airCapacity,_tf_hasLRradio,_author];

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

  _dataTransport = [_cargoCoDriver,_transportSoldier,_transportVehicle,_transportAmmo,_transportFuel,_transportRepair,_maximumLoad,_transportMaxMagazines,_transportMaxWeapons,_transportMaxBackpacks];

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

  _dataVehicle = [_fuelCap,_armour,_audible,_accuracy,_camouflage,_accerleration,_breakDist,_maxSpeed,_minSpeed,_hiddenSel,_hiddelSelTex];


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

  _dataArmor = [_armorStructural,_armorFuel,_armorGlass,_armorLights,_armorWheels,_armorHull,_armorTurret,_armorGun,_armorEngine,_armorTracks,_armorHead,_armorHands,_armorLegs,_armorEngine,_armorAvionics,_armorVRotor,_armorHRotor,_armorMissiles];


  /*
  ["data base: " + str(_dataBase)] call ADL_DEBUG;
  ["data trans: " + str(_dataTransport)] call ADL_DEBUG;
  ["data veh: " + str(_dataVehicle)] call ADL_DEBUG;
  */


  if (_class != "" && _type != "" && _description != "") then {
    try {

      _objSpawn = [_class] call ADL_SPAWN_OBJ;

      _veh = _objSpawn select 0;
      _sizes = _objSpawn select 1;

      _scrFile = "";

      sleep 2;

      if (!isNil("_veh") && (typeName _veh == "OBJECT") && (!(_veh isKindOf "Logic")) && (alive _veh)) then {

         try {
           //[[[_veh,1]]] call ADL_DRAW_CHART;

           //take screen shoot if enabled
           if (ENABLE_SCREEN) then {
             sleep 0.5;
             _scrFile = [_class] call FNC_SCR_CAP;
             _scr = true;
           };

           [str(_i) + str(_dataBase+_dataExtend+_dataTransport+_dataVehicle+_dataArmor+[_sizes]+[_scrFile]), "exp_data"]  call ADL_DEBUG;

         }
         catch {
           [str(_i) + str(_dataBase+_dataExtend+_dataTransport+_dataVehicle+_dataArmor+[_sizes]), "exp_data"]  call ADL_DEBUG;
           [_class, "adl_error"] call ADL_DEBUG;
         };

         //test exit
         if (_debugTextExit) exitWith { true; };

         {
             deleteVehicle _x;
         } forEach attachedObjects _veh;
         deleteVehicle _veh;
         _veh = nil;
         sleep 0.2;
      };
    }
    catch {
        ["**** NO SCREEN ****", "warn"] call ADL_DEBUG;
        [str(_exception)] call ADL_DEBUG;
    };
  };
  if  (_debugTextExit && _i > 2) exitWith { true; };
};
["done"] call ADL_DEBUG;
hint ("done with " + str(count(_cfg)));
