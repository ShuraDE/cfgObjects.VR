_turnObj = _this select 0;
_dir = _this select 1;
_angle = _this select 2;
_pitch = _this select 3;


_vecdx = sin(_dir) * cos(_angle);
_vecdy = cos(_dir) * cos(_angle);
_vecdz = sin(_angle);

_vecux = cos(_dir) * cos(_angle) * sin(_pitch);
_vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
_vecuz = cos(_angle) * cos(_pitch);

_turnObj setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
