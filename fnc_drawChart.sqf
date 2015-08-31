
removeAllMissionEventHandlers "Draw3D";
lines = [];


_createChart = {

  _targetObj = _this select 0;
  //values = 1 = front, 2 = side
  _side = _this select 1;  //draw chart on rear side

  {
      deleteVehicle _x;
  } forEach attachedObjects _targetObj;

  //bb = bounding box calculation based on source/creator: http://killzonekid.com/arma-3-bounding-box-utility/
  _bb = {
      _bbx = [_this select 0 select 0, _this select 1 select 0];
      _bby = [_this select 0 select 1, _this select 1 select 1];
      _bbz = [_this select 0 select 2, _this select 1 select 2];
      _arr = [];
      0 = {
          _y = _x;
          0 = {
              _z = _x;
              0 = {
                  0 = _arr pushBack (_targetObj modelToWorld [_x,_y,_z]);
              } count _bbx;
          } count _bbz;
          reverse _bbz;
      } count _bby;
      _arr pushBack (_arr select 0);
      _arr pushBack (_arr select 1);
      _arr
  };
  _bbox = boundingBox _targetObj call _bb;
  _bboxr = boundingBoxReal _targetObj call _bb;

  for "_i" from 0 to 7 step 2 do {
      lines pushBack ([_bbox select _i] + [_bbox select (_i + 2)] + [[0,0,1,1]]);
      lines pushBack ([_bboxr select _i] + [_bboxr select (_i + 2)] + [[0,1,0,1]]);
      lines pushBack ([_bbox select (_i + 2)] + [_bbox select (_i + 3)] + [[0,0,1,1]]);
      lines pushBack ([_bboxr select (_i + 2)] + [_bboxr select (_i + 3)] + [[0,1,0,1]]);
      lines pushBack ([_bbox select (_i + 3)] + [_bbox select (_i + 1)] + [[0,0,1,1]]);
      lines pushBack ([_bboxr select (_i + 3)] + [_bboxr select (_i + 1)] + [[0,1,0,1]]);
  };

  _bbr = boundingBoxReal _targetObj;
  _bb = boundingBox _targetObj;

  _bbox = if (isNil("_bbr")) then { _bb;} else {_bbr;};

  _p1 = _bbox select 0;
  _p2 = _bbox select 1;

  {
      deleteVehicle _x;
  } forEach  attachedObjects _targetObj;

  _points = [];

  _pointLayout = {
    _target = _this select 0;
    _loc = _this select 1;
    _idx = _this select 2;

    _colr = "";
    _lineColr = "";

    if (_idx == 0) then {
      _colr = [0,'#(argb,8,8,3)color(0,0,0,1)']; //black
      _lineColr = [0,0,0,1];
    } else {
      if (_idx mod 5 == 0) then {
        _colr = [0,'#(argb,8,8,3)color(1,1,1,1)']; //white
        _lineColr = [1,1,1,1];
      } else {
        _colr = [0,'#(argb,8,8,3)color(0.8,0.6,0,1)']; //yellow
        _lineColr = [0.8,0.6,0,1];
      };
    };

    {
      _points pushBack ("Sign_sphere10cm_EP1" createVehicle position player);
      (_points select ((count _points) - 1)) attachTo [_target, _x];
      (_points select ((count _points) - 1)) setObjectTexture _colr;
    } forEach _loc select 0;

    //add each node with sister and color

    for "_i" from 0 to (count _loc - 1) step 2 do {
      /*
      _tmpLines = [];
      _tmpLines pushBack (_loc select _i);
      _tmpLines pushBack (_loc select (_i+1));
      _tmpLines pushBack _lineColr;
      */
      lines pushBack ([(_target modelToWorld (_loc select _i))] + [(_target modelToWorld (_loc select (_i+1)))] + [_lineColr]);
    };

  };

  _rearPoints = {
    _target = _this select 0;
    _rp1 = _this select 1; //down left
    _rp2 = _this select 2; //up right
    _dSide = _this select 3; // x / y
    _loc = [];

    switch (_dSide) do {
      case (1): {
        //X
        for [{_i = 0}, {_i <= floor(_rp2 select 0)}, {_i=_i+1}] do {
          //up & down
          _loc pushBack [_i, (_rp2 select 1), (_rp2 select 2)];
          _loc pushBack [_i, (_rp2 select 1), (_rp1 select 2)];
          //negative up & down
          if (_i > 0) then {
            _loc pushBack [_i * -1, (_rp2 select 1), (_rp2 select 2)];
            _loc pushBack [_i * -1, (_rp2 select 1), (_rp1 select 2)];
          };
          [_target, _loc, _i] call _pointLayout;
          _loc =[];
        };
        //Z
        for [{_i = 0}, {_i <= floor(_rp2 select 2)}, {_i=_i+1}] do {

          //right & left
          _loc pushBack [(_rp2 select 0), (_rp2 select 1), _i];
          _loc pushBack [(_rp1 select 0), (_rp2 select 1), _i];
          //negative right & left
          if (_i > 0) then {
          _loc pushBack [(_rp2 select 0), (_rp2 select 1), _i*-1];
          _loc pushBack [(_rp1 select 0), (_rp2 select 1), _i*-1];
          };
          [_target, _loc, _i] call _pointLayout;
          _loc =[];
        };

      };
    };
  };

  switch (_side) do {
    case (1): { //front, draw back sided
      [_targetObj, [_p1 select 0, _p2 select 1, _p1 select 2], _p2, 1] call _rearPoints;
    };
  };
};

_targets = _this select 0;
[_targets] call ADL_DEBUG;
{
    [_x select 0, _x select 1]  call _createChart;
} forEach _targets;

if (count lines > 0) then {
  addMissionEventHandler ["Draw3D", {
      for "_i" from 0 to ((count lines) - 1) do {
         drawLine3D [
          lines select _i select 0,
          lines select _i select 1,
          lines select _i select 2
        ];
      };
  }];
};
