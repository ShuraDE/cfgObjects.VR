private ["_obj_ru","_obj_lu"];

_objClass = _this select 0;
_spaceBetweenObjects = 1;
_zOffSet = 0.2;

[] call ADL_CLEAN_UP;

//spawn max 6 Objects, checks sizes of object and reduce amount if to large
// dir 180 center down
// dir 135 right down
// dir 225 left down
// pitch up (top down view) center top
// dir 0  left top, rear view
// dir 90  right top, side view


_mod = if (configSourceMod(configFile >> "CfgVehicles" >> _objClass) == "") then { "vanilla"; } else { configSourceMod(configFile >> "CfgVehicles" >> _objClass); };

_objType = getText(configFile >> "CfgVehicles" >> _objClass >> "vehicleClass");

_enableSimulation = (_objType == "Flag");

_displayName = getText(configFile >> "CfgVehicles" >> _objClass >> "displayName");
_displayName = [_displayName,"&","&amp;"] call FNC_REPLACE;
_author = getText(configFile >> "CfgVehicles" >> _objClass >> "author");
_author = [_author,"&","&amp;"] call FNC_REPLACE;

_bIsWeapon = (_objType in ['WeaponsPrimary','WeaponsSecondary','WeaponsHandgun']);
_bIsBackpack = (_objType == 'Backpacks');

_setupVector =  {
  _turnObj = _this select 0;
  _dir = _this select 1;
  _angle_corr = _this select 2;

  _heightDiff =  (getPosASl _turnObj select 2) - ((_turnObj modelToWorld [0,0,0]) select 2); 
  //_heightDiff =  ((getPosASl player select 2)- 1.71433) - ((getPosASl _turnObj select 2) min ((_turnObj modelToWorld [0,0,0]) select 2));
  _dist = _turnObj distance2D player;

  _angle = (_heightDiff atan2 _dist);
  _angle = (_angle_corr + _angle) *-1;

  _pitch = 0;

  _vecdx = sin(_dir) * cos(_angle);
  _vecdy = cos(_dir) * cos(_angle);
  _vecdz = sin(_angle);

  _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
  _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
  _vecuz = cos(_angle) * cos(_pitch);

  _turnObj setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
};

//primary object
_obj = createVehicle [_objClass, [0,0.1,_zOffSet], [], 0, "CAN_COLLIDE"];
_obj enableSimulation _enableSimulation;
_obj allowDamage false;

_parentClass = "unkown";
if (_obj isKindOf 'Man') then { _parentClass = "Man"; };
if (_obj isKindOf 'StaticWeapon') then { _parentClass = "StaticWeapon"; };
if (_obj isKindOf 'Car') then { _parentClass = "Car"; };
if (_obj isKindOf 'Tank') then { _parentClass = "Tank"; };
if (_obj isKindOf 'Motorcycle') then { _parentClass = "Motorcycle"; };
if (_obj isKindOf 'Helicopter') then { _parentClass = "Helicopter"; };
if (_obj isKindOf 'Plane') then { _parentClass = "Plane"; };
if (_obj isKindOf 'Ship') then { _parentClass = "Ship"; };
if (_obj isKindOf 'Fortress') then { _parentClass = "Fortress"; };
if (_obj isKindOf 'Building') then { _parentClass = "Building"; };
if (_obj isKindOf 'Thing') then { _parentClass = "Thing"; };
if (_bIsWeapon) then { _parentClass = "Weapons"; };

//_objType in ['WeaponsPrimary','WeaponsSecondary','WeaponsHandgun']);

if (_bIsWeapon) then {
  [_obj, 180, 200] call _setupVector;
  _obj setPosASL [0,0.1,5.5];
} else {
  _obj setDir 180; //warning: boundingbox points -> modelToWorld calc is reversed with  reason model is turn around !!  -.-
};


testObj = _obj;

hint parseText format ["
  <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%1</t><br/>
  <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%2</t><br/>
  <t align='center' color='#666666'>------------------------------</t><br/><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%3'/></t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%4'/></t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%5</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%6</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%7</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%8</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%9</t>
  ",
     _objClass,
     _displayName,
     getText(configFile >> "CfgVehicles" >> _objClass >> "picture"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "icon"),
     _objType,
     getText(configFile >> "CfgVehicles" >> _objClass >> "faction"),
     _author,
     _mod,
     _parentClass];

//get sizes for calculation
_bbox = boundingBox _obj;
_maxWidth = abs ((_bbox select 1 select 0) - (_bbox select 0 select 0));
_maxLength = abs ((_bbox select 1 select 1) - (_bbox select 0 select 1));
_maxHeight = abs ((_bbox select 1 select 2) - (_bbox select 0 select 2));
_radius2D = (_obj modelToWorld [0,0,0]) distance (_obj modelToWorld [((_bbox select 0 )select 0), ((_bbox select 1) select 1), 0]);
_radius3D = (_obj modelToWorld [0,0,0]) distance (_obj modelToWorld (_bbox select 1));
_worldLength = abs((_obj modelToWorld [0,((_bbox select 1) select 1) * 2,0]) select 1) - (getPosASL _obj select 0);
_worldWidth =  abs((_obj modelToWorld [((_bbox select 1) select 0) * 2,0,0]) select 0) - (getPosASL _obj select 1);
//_worldHeight = abs((_obj modelToWorld [0,0,(((_bbox select 1) select 2) max ((_bbox select 0) select 2)) * 2]) select 2) - _zOffSet;
_worldHeight = abs(((_obj modelToWorld [0,0,((_bbox select 1) select 2)]) select 2) - ((_obj modelToWorld [0,0,((_bbox select 0) select 2)]) select 2));
//_worldHeight = (getPosASL _obj select 2) - _zOffSet;
_sizes = [[_maxWidth,_maxLength,_maxHeight],[_radius2D,_radius3D],[_worldWidth,_worldLength,_worldHeight], _bbox];

//set player view
[_obj, _sizes, _zOffSet, _spaceBetweenObjects] call ADL_PL_POS;

try {
  //right down object
  //distance between middlepoint to corner + space between + half width
  _x = _radius2D + _spaceBetweenObjects + (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_rd = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_rd enableSimulation _enableSimulation;
  _obj_rd allowDamage false;

  //left down object
  _x = _x *-1; //(_radius2D*-1) - _spaceBetweenObjects - (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_ld = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_ld enableSimulation _enableSimulation;
  _obj_ld allowDamage false;

  //angle correction lower line
  _angle_cor = ((( getPosASL _obj_ld) select 1) - ((getPosASL player) select 1)) atan2 ((( getPosASL _obj_ld) select 0) - (( getPosASL player) select 0));
  _obj_ld setDir (90 + _angle_cor);
  _obj_rd setDir (270 - _angle_cor);

  if (_bIsWeapon) then {
    [_obj_rd, 300, 200] call _setupVector;
    [_obj_ld, 310, 200] call _setupVector;
    _obj_ld setPosASL [(_radius2D*-1.5),-1,5.5]
  };


  //upper objects
  //upper base line
  _z = (_zOffSet + (_maxHeight max _maxLength)) max 1; //for flip check height and length, min 1 up

  if (!(_bIsWeapon || _bIsBackpack))  then {
    //side view upper right corner
      _x = _radius2D + _spaceBetweenObjects + (_maxWidth/2);
      _obj_ru = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
      _obj_ru enableSimulation false;
      _obj_ru allowDamage false;
      //correct orientation from player view
      _obj_ru setDir (_angle_cor);

    //rear view upper left corner
      _x = _x * -1; //(_radius2D*-1) - _spaceBetweenObjects - (_maxWidth/2);
      _obj_lu = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
      _obj_lu enableSimulation false;
      _obj_lu allowDamage false;
      //correct orientation from player view
      _obj_lu setDir (90 - _angle_cor);

    //flipped _z a little bit different ;)
    _z = (_zOffSet + (_worldHeight max _worldLength)) max 1; //for flip check height and length, min 1 up
  };
  //_objType in ["Men"]
  //if infantry, dont spawn 6th one
  if ((_obj isKindOf 'Man') || _bIsWeapon || _bIsBackpack) then {
    //if men or weapon
    [[[_obj,6]]] execVM "fnc_drawChart.sqf";
  } else {
    //topdown view upper center
    _obj_td = createVehicle [_objClass, [0, 0, (_z + (_maxWidth / 2))], [], 0, "CAN_COLLIDE"];
    _obj_td attachTo [_obj, _obj worldToModel [0, 0,_z + ((getPosASL _obj)  select 2)]];
    _obj_td enableSimulation false;
    _obj_td setPosASL [0,0, ((getPosASL _obj_lu) select 2)];
    detach _obj_td;
    //dont turn objects from class

    [_obj_td, 180, 90] call _setupVector;
    _obj_td allowDamage false;
    //draw chart
    try {
      // 1 = front, 2 = side left, 3 = side right, 4 = buttom, 5 = top, 6 = rear
      [[[_obj,4],[_obj_td,4],[_obj_lu,1],[_obj_ru,2]]] execVM "fnc_drawChart.sqf";
    } catch {
      ["error draw chart","CERROR"] call ADL_DEBUG;
    }
  };
  if (ENABLE_SCREEN) then { sleep 1; };


}
catch {
  ["error calculation spawn more then one object", "error"] call ADL_DEBUG;
};

//return major spawn object with size array
//additional return parent class
[_obj,_sizes, _parentClass];
