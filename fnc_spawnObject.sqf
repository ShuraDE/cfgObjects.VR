_objClass = _this select 0;
_spaceBetweenObjects = 2;
_zOffSet = 0.2;

[] call ADL_CLEAN_UP;

//spawn max 6 Objects, checks sizes of object and reduce amount if to large
// dir 180 center down
// dir 135 right down
// dir 225 left down
// dir 0 center behind
// dir 270  left top, top down
// dir 90  right top, side view


//primary object
_veh = createVehicle [_objClass, [0,0.1,_zOffSet], [], 0, "CAN_COLLIDE"];
_veh enableSimulation false;
_veh allowDamage false;
_veh setDir 180; //warning: boundingbox points -> modelToWorld calc is reversed with  reason model is turn around !!  -.-
hint _objClass;
//set player view
[_veh] call ADL_PL_POS;

try {
  //get sizes for calculation
  _bbox = boundingBox _veh;
  _maxWidth = abs ((_bbox select 1 select 0) - (_bbox select 0 select 0));
  _maxLength = abs ((_bbox select 1 select 1) - (_bbox select 0 select 1));
  _maxHeight = abs ((_bbox select 1 select 2) - (_bbox select 0 select 2));
  _radius = (_veh modelToWorld [0,0,0]) distance (_veh modelToWorld [((_bbox select 0 )select 0), ((_bbox select 1) select 1), 0]);
  _worldLength = abs((_veh modelToWorld [0,((_bbox select 1) select 1) * 2,0]) select 1) - (getPosASL _veh select 0);
  _worldWidth =  abs((_veh modelToWorld [((_bbox select 1) select 0) * 2,0,0]) select 0) - (getPosASL _veh select 1);
  _worldHeight = abs((_veh modelToWorld [0,0,((_bbox select 1) select 2) * 2]) select 2) - (getPosASL _veh select 2);

  //right down object
  //distance between middlepoint to corner + space between + half width
  _x = _radius + _spaceBetweenObjects + (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _veh_rd = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _veh_rd enableSimulation false;
  _veh_rd allowDamage false;
  _veh_rd setDir 135;

  //left down object
  _x = (_radius*-1) - _spaceBetweenObjects - (_maxWidth/2);
  _pos = [ _x, 0, _zOffSet];
  _veh_ld = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _veh_ld enableSimulation false;
  _veh_ld allowDamage false;
  _veh_ld setDir 225;

  //dir 0 center behind
  _y = (_worldLength*2) + _spaceBetweenObjects + _worldHeight;
  _pos = [ 0, _y, _zOffSet];
  _veh_cb = createVehicle [_objClass, _pos, [], 0, "CAN_COLLIDE"];
  _veh_cb enableSimulation false;
  _veh_cb allowDamage false;
  _veh_cb setDir 0;


  //topdown view in upper left corner
  _x = (_spaceBetweenObjects + _maxWidth) *-1;
  _z = _zOffSet + _worldHeight * 2;
  _veh_td = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _veh_td enableSimulation false;
  _veh_td allowDamage false;


  _setupVector =  {

    _dir = 90;
    _angle = 0;
    _pitch = -90;

    _vecdx = sin(_dir) * cos(_angle);
    _vecdy = cos(_dir) * cos(_angle);
    _vecdz = sin(_angle);

    _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
    _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
    _vecuz = cos(_angle) * cos(_pitch);

    _veh_td setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
  };

  [] call _setupVector;

  /*
  _veh_td setVectorDirAndUp [[1,0,0],[0,-1,0]];
  sleep 0.2;
*/
  //side view upper right corner
  _x = (_spaceBetweenObjects + _maxWidth);
  _z = _zOffSet + _worldHeight * 2;
  _veh_s = createVehicle [_objClass, [_x, 0, _z], [], 0, "CAN_COLLIDE"];
  _veh_s enableSimulation false;
  _veh_s allowDamage false;
  _veh_s setDir 270;

  //setup again, didnt do it first time :-/
  sleep 1;
  [] call _setupVector;
}
catch {
  ["error calculation spawn more then one object", "error"] call ADL_DEBUG;
};
//return major spawn object
_veh;
