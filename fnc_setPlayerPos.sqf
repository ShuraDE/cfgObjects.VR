_target = _this select 0;

//[[_x,_y,_z],_radius,[_worldLength,_worldWidth,_worldHeight],[_boundingBoxPoints]]
_radius = _this select 1 select 1 select 1;  //use 3d radius
_worldSizes = _this select 1 select 2;
_worldHeight = _worldSizes select 2;
_worldLength = _worldSizes select 1;
_worldWidth = _worldSizes select 0;

_zOffSet = _this select 2;
_spaceBetweenObjects = _this select 3;
_eyeOffset = 1.71433;

/* position difference
posASL player [-1.59637,-8.02312,5.00144]
eyepos player [-1.58802,-7.92655,6.71577]
delta         [0.00835, 0.09657, 1.71433]
*/

_objMiddle = _target modelToWorld [0,0,0];

player setDir 0;


/*
//set pos
x = middle of target
y = in front of target from the middle 2 times radius + width
z = 2 times height
*/
//(_worldHeight max _worldLength)
player setPosASL [
  (_objMiddle select 0),
  ((_objMiddle select 1)-(_radius + _radius)-((_worldHeight max _worldLength max _worldWidth))) min -2,
  (_zOffSet + (_worldHeight max _worldLength) +_eyeOffset) max 4
  //((_worldSizes select 2) max (_worldSizes select 1)) + (_worldSizes select 2) + _zOffSet +_eyeOffset
];
//[format["%1 height, %2 width, %3 length, %4 radius", _worldSizes select 2,_worldSizes select 0,_worldSizes select 1,_radius]] call ADL_DEBUG;
