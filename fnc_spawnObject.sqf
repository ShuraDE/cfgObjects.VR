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

//get sizes for calculation
_bbox = boundingBox _obj;
_maxWidth = abs ((_bbox select 1 select 0) - (_bbox select 0 select 0));
_maxLength = abs ((_bbox select 1 select 1) - (_bbox select 0 select 1));
_maxHeight = abs ((_bbox select 1 select 2) - (_bbox select 0 select 2));
_radius = (_obj modelToWorld [0,0,0]) distance (_obj modelToWorld [((_bbox select 0 )select 0), ((_bbox select 1) select 1), 0]);
_worldLength = abs((_obj modelToWorld [0,((_bbox select 1) select 1) * 2,0]) select 1) - (getPosASL _obj select 0);
_worldWidth =  abs((_obj modelToWorld [((_bbox select 1) select 0) * 2,0,0]) select 0) - (getPosASL _obj select 1);
//_worldHeight = abs((_obj modelToWorld [0,0,(((_bbox select 1) select 2) max ((_bbox select 0) select 2)) * 2]) select 2) - _zOffSet;
_worldHeight = (getPosASL _obj select 2) - _zOffSet;
_sizes = [[_maxWidth,_maxLength,_maxHeight],_radius,[_worldLength,_worldWidth,_worldHeight], _bbox];



try {
  //right down object
  //distance between middlepoint to corner + space between + half width
  _x = _radius + _spaceBetweenObjects + (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_rd = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_rd enableSimulation false;
  _obj_rd allowDamage false;
  _obj_rd setDir 135;

  //left down object
  _x = (_radius*-1) - _spaceBetweenObjects - (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _obj_ld = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _obj_ld enableSimulation false;
  _obj_ld allowDamage false;
  _obj_ld setDir 225;

  //topdown view upper center
  _z = _zOffSet + (_worldHeight max _worldLength);
  _obj_td = createVehicle [_objClass, [0, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_td enableSimulation false;
  _obj_td allowDamage false;

  _setupVector =  {

    _dir = 180;
    _angle = -90;
    _pitch = 0;

    _vecdx = sin(_dir) * cos(_angle);
    _vecdy = cos(_dir) * cos(_angle);
    _vecdz = sin(_angle);

    _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
    _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
    _vecuz = cos(_angle) * cos(_pitch);

    _obj_td setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
  };
  [] call _setupVector;

  testObj = _obj_td;

  //side view upper right corner
  _x = (_spaceBetweenObjects + _maxWidth);
  _z = _zOffSet + (_worldHeight max _worldLength);
  _obj_s = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_s enableSimulation false;
  _obj_s allowDamage false;
  //correct orientation from player view
  _angle_s = ((( getPosASL _obj_s) select 1) - ((getPosASL player) select 1)) atan2 ((( getPosASL _obj_s) select 0) - (( getPosASL player) select 0));
  _obj_s setDir (180 - _angle_s);


  //rear view upper left corner
  _x = (_spaceBetweenObjects + _maxWidth) * -1;
  _z = _zOffSet + (_worldHeight max _worldLength);
  _obj_r = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _obj_r enableSimulation false;
  _obj_r allowDamage false;
  //correct orientation from player view
  _angle_r = ((( getPosASL _obj_r) select 1) - ((getPosASL player) select 1)) atan2 ((( getPosASL _obj_r) select 0) - (( getPosASL player) select 0));
  _obj_r setDir (90 - _angle_r);

}
catch {
  ["error calculation spawn more then one object", "error"] call ADL_DEBUG;
};

//set player view
[_obj, _sizes, _zOffSet, _spaceBetweenObjects] call ADL_PL_POS;

//return major spawn object
[_obj,_sizes];
