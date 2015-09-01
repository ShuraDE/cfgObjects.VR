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


["Export Data:"] call ADL_DEBUG;
["[className,_generalMacro,vehicleClass,displayName,[availableForSupportTypes],[weapons],[magazines],textSingular,[BASE],side,model,_parent,vehicleClass,timeToLive,[cargoIsCoDriver],transportSoldier,transportVehicleCount,transportAmmo,transportFuel,transportRepair,maximumLoad,transportMaxMagazines,transportMaxWeapons,transportMaxBackpacks,fuelCapacity,armor,audible,accuracy,camouflage,accerleration,brakeDistance,maxSpeed,minSpeed,[hiddenSelections],[hiddenSelectionsTextures],[_x,_y,_z, [_bb]],_scrshot_file"] call ADL_DEBUG;

[format["Found %1 Objects",count(_cfg)]] call ADL_DEBUG;

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

  _dataBase = [_class,_genMac,_type,_description,_roles,_weapons,_magazines,_type2,_filter,_side,_model,_parent,_vehicleClass,_ttl];

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


  /*
  ["data base: " + str(_dataBase)] call ADL_DEBUG;
  ["data trans: " + str(_dataTransport)] call ADL_DEBUG;
  ["data veh: " + str(_dataVehicle)] call ADL_DEBUG;
  */


  if (_class != "" && _type != "" && _description != "") then {
    try {
      _veh = [_class] call ADL_SPAWN_OBJ;

      _scrFile = "";


      if (!isNil("_veh") && (typeName _veh == "OBJECT") && (!(_veh isKindOf "Logic")) && (alive _veh)) then {

         try {
           _bbox = boundingBox _veh;
           _maxWidth = abs ((_bbox select 1 select 0) - (_bbox select 0 select 0));
           _maxLength = abs ((_bbox select 1 select 1) - (_bbox select 0 select 1));
           _maxHeight = abs ((_bbox select 1 select 2) - (_bbox select 0 select 2));
           _sizes = [_maxWidth,_maxLength,_maxHeight];

           //[[[_veh,1]]] call ADL_DRAW_CHART;

           //take screen shoot if enabled
           if (ENABLE_SCREEN) then {
             sleep 0.5;
             _scrFile = [_class] call FNC_SCR_CAP;
             _scr = true;
           };

           [str(_i) + str(_dataBase+_dataTransport+_dataVehicle+[_sizes]+[_scrFile]), "adl_data"]  call ADL_DEBUG;

         }
         catch {
           [str(_i) + str(_dataBase+_dataTransport+_dataVehicle+[_sizes]), "adl_data"]  call ADL_DEBUG;
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
  if  (_debugTextExit && _i > 3) exitWith { true; };
};
["done"] call ADL_DEBUG;
hint ("done with " + str(count(_cfg)));
