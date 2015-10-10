//_holder = createVehicle [ "GroundWeaponHolder", [13219.729492,6561.291504,1.37793], [], 0, "NONE" ];

_holder_md = createVehicle ["GroundWeaponHolder", [0,0.1,0.5], [], 0, "CAN_COLLIDE"];
_holder_rd = createVehicle ["GroundWeaponHolder", [0.5,0.2,0.2], [], 0, "CAN_COLLIDE"];
_holder_ld = createVehicle ["GroundWeaponHolder", [-0.3,-0.3,0.5], [], 0, "CAN_COLLIDE"];


_holder_md setDir 180;

[_holder_rd,90,0,90] call FNC_ROTATE_SIMPLE;
[_holder_ld,270,0,90] call FNC_ROTATE_SIMPLE;;

_allHolder = [_holder_md, _holder_rd, _holder_ld];
_allHolder;
