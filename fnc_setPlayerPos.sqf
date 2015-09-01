_target = _this select 0;


/* position difference
posASL player [-1.59637,-8.02312,5.00144]
eyepos player [-1.58802,-7.92655,6.71577]
delta         [0.00835, 0.09657, 1.71433]
*/

_objSize = boundingBox _target;
_p1 = _objSize select 0;
_p2 = _objSize select 1;
_width = abs ((_p2 select 0) - (_p1 select 0));
_length = abs ((_p2 select 1) - (_p1 select 1));
_height = abs ((_p2 select 2) - (_p1 select 2));


_objMiddle = _target modelToWorld [0,0,_height];


player setDir 0;
player setPosASL [
  (_objMiddle select 0),
  (_objMiddle select 1)-((_objMiddle select 2)*2),
  (_objMiddle select 2)]; //+1.71433];
