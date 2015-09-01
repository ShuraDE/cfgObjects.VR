
[] call ADL_CLEAN_UP;

_setupVector =  {
  _turnObj = _this select 0;
  _dir = _this select 1;
  _angel_corr = _this select 2;
  _pitch = _this select 3;

  _heightDiff =  (getPosASl _turnObj select 2)-((_turnObj modelToWorld [0,0,0]) select 2);
  _dist = _turnObj distance2D player;

  _angle = (_heightDiff atan2 _dist);
  _angle = (_angel_corr + _angle) *-1;

  _vecdx = sin(_dir) * cos(_angle);
  _vecdy = cos(_dir) * cos(_angle);
  _vecdz = sin(_angle);

  _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
  _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
  _vecuz = cos(_angle) * cos(_pitch);

  _turnObj setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];

};

_sphere = createVehicle ["Sign_sphere10cm_EP1", [0,0,0], [], 0, "CAN_COLLIDE"];

for "_i" from 0 to (360) step 10 do {

  _obj = createVehicle ["Fennek_Flecktarn", [0,0,8], [], 0, "CAN_COLLIDE"];
  _obj attachTo [_sphere, [0,0,10]];
  [_obj, _i, _i, _i] call _setupVector;

  _obj allowDamage false;



  hint str(_i);
  sleep 0.5;

  deleteVehicle _obj;
};
deleteVehicle _sphere;
