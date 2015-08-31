
_targetObj = _this select 0;

_targetObj call FNC_SHOW_BOUNDINGBOX;

_bbox = boundingBox _targetObj;
_p1 = _bbox select 0;
_p2 = _bbox select 1;

[_p2] call ADL_DEBUG;

[] call {
  if (!isNil("points")) then {
    {
        deleteVehicle _x;
    } forEach points;
  };
};

points = [];

//X
for[{_i = 0}, {_i <= floor(_p2 select 0)}, {_i=_i+1}] do {

  //set upper x  > 0
  points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
  (points select (count points - 1)) attachTo [_targetObj, [_i, (_p2 select 1), (_p2 select 2)]];
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };

  //set upper x  < 0
  if (_i > 0) then {
    points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
    (points select (count points - 1)) attachTo [_targetObj, [_i * -1, (_p2 select 1), (_p2 select 2)]];
  } else {
    //0 point in black
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,0,1)'];
  };
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };
};

//Y
for[{_i = 0}, {_i <= floor(_p2 select 2)}, {_i=_i+1}] do {

  //set upper y  > 0
  points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
  (points select (count points - 1)) attachTo [_targetObj, [(_p2 select 0), _i, (_p2 select 2)]];
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };

  //set upper y  < 0
  if (_i > 0) then {
    points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
    (points select (count points - 1)) attachTo [_targetObj, [(_p2 select 0), _i * -1, (_p2 select 2)]];
  } else {
    //0 point in black
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,0,1)'];
  };
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };
};

//Z
for[{_i = 0}, {_i <= floor(_p2 select 1)}, {_i=_i+1}] do {

  //set upper z  > 0
  points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
  (points select (count points - 1)) attachTo [_targetObj, [(_p2 select 0), (_p2 select 1), _i]];
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };

  //set upper z  < 0
  if (_i > 0) then {
    points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
    (points select (count points - 1)) attachTo [_targetObj, [(_p2 select 0), (_p2 select 1), _i *-1]];
  } else {
    //0 point in black
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,0,1)'];
  };
  if (_i mod 5 == 0 && _i > 0) then {
    //each 5 in blue
    (points select (count points - 1)) setObjectTexture [0,'#(argb,8,8,3)color(0,0,1,1)']
  };
};
