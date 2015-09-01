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


//primary object
_obj = createVehicle [_objClass, [0,0.1,_zOffSet], [], 0, "CAN_COLLIDE"];
_obj enableSimulation false;
_obj allowDamage false;
_obj setDir 180; //warning: boundingbox points -> modelToWorld calc is reversed with  reason model is turn around !!  -.-

hint _objClass;

hint parseText format ["
  <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%1</t><br/>
  <t align='center' color='#f39403' shadow='1' shadowColor='#000000'>%2</t><br/>
  <t align='center' color='#666666'>------------------------------</t><br/><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%3'/></t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'><img size='4' image='%4'/></t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%5</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%6</t><br/>
  <t align='center' color='#666c3f' shadow='1' shadowColor='#000000'>%7</t>
  ",
     _objClass,
     getText(configFile >> "CfgVehicles" >> _objClass >> "displayName"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "picture"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "icon"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "vehicleClass"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "faction"),
     getText(configFile >> "CfgVehicles" >> _objClass >> "author")];


[_objClass] call ADL_DEBUG;

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
  _setupVector =  {
    _turnObj = _this select 0;
    _dir = _this select 1;
    _angle_corr = _this select 2;

    _heightDiff =  (getPosASl _turnObj select 2)-((_turnObj modelToWorld [0,0,0]) select 2);
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

  //right down object
  //distance between middlepoint to corner + space between + half width
  _x = _radius2D + _spaceBetweenObjects + (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_rd = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_rd enableSimulation false;
  _obj_rd allowDamage false;
  _obj_rd setDir 135;

  //left down object
  _x = (_radius2D*-1) - _spaceBetweenObjects - (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_ld = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_ld enableSimulation false;
  _obj_ld allowDamage false;
  _obj_ld setDir 225;

  //upper objects
  _z = (_zOffSet + (_worldHeight max _worldWidth)) max 1; //for flip check height and length, min 1 up

  //topdown view upper center

  //add a fake object, dir/up isnt correct displayed
  _objHolder = createVehicle ["Sign_sphere10cm_EP1", [0, 5, _z], [], 0, "CAN_COLLIDE"];
  hideObject _objHolder;
  _objHolder allowDamage false;

  _obj_td_faker = createVehicle [_objClass, [0, _worldHeight max _worldLength, _z], [], 0, "CAN_COLLIDE"];
  _obj_td_faker allowDamage false;
  hideObject _obj_td_faker;
  _obj_td_faker enableSimulation false;
  [_obj_td_faker, 180, 90] call _setupVector;

  _obj_td = createVehicle [_objClass, [0, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_td enableSimulation false;
  _obj_td attachTo [_objHolder, [0,0, 1]];
  [_obj_td, 180, 90] call _setupVector;
  _obj_td allowDamage false;
  _obj_td enableSimulation false;

  _obj_td setPosASL [getPosASL _obj_td select 0, getPosASL _obj_td select 1, _z];//((_obj_td_faker modelToWorld [0,0,0]) select 2)];
  //detach _obj_td;

  //side view upper right corner
  _x = _radius2D + _spaceBetweenObjects + (_maxWidth/2);
  _obj_s = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_s enableSimulation false;
  _obj_s allowDamage false;
  //correct orientation from player view
  _angle_s = ((( getPosASL _obj_s) select 1) - ((getPosASL player) select 1)) atan2 ((( getPosASL _obj_s) select 0) - (( getPosASL player) select 0));
  _obj_s setDir (180 - _angle_s);
  //[_obj_s, (180 - _angle_s), 90] call _setupVector;

  //rear view upper left corner
  _x = (_radius2D*-1) - _spaceBetweenObjects - (_maxWidth/2);
  _obj_r = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_r enableSimulation false;
  _obj_r allowDamage false;
  //correct orientation from player view
  _angle_r = ((( getPosASL _obj_r) select 1) - ((getPosASL player) select 1)) atan2 ((( getPosASL _obj_r) select 0) - (( getPosASL player) select 0));
  _obj_r setDir (90 - _angle_r);
  //[_obj_r,0,0,0] call FNC_ROTATE;
  //[_obj,[-10,0,0]] call fnc_SetPitchBankYaw;
  ////[_obj_r, (90 - _angle_r), 90] call _setupVector;


  //draw chart
  // 1 = front, 2 = side left, 3 = side right, 4 = buttom, 5 = top
  [[[_obj_td_faker,5],[_obj_r,1],[_obj_s,2]]] execVM "fnc_drawChart.sqf";
}
catch {
  ["error calculation spawn more then one object", "error"] call ADL_DEBUG;
};

//return major spawn object with size array
[_obj,_sizes];
