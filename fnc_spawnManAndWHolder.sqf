//_holder = createVehicle [ "GroundWeaponHolder", [13219.729492,6561.291504,1.37793], [], 0, "NONE" ];

[] call ADL_CLEAN_UP;

//_holder_md = createVehicle ["GroundWeaponHolder", [0,0.1,0.5], [], 0, "CAN_COLLIDE"];
_holder_rd = createVehicle ["GroundWeaponHolder", [0.5,0.2,0.2], [], 0, "CAN_COLLIDE"];
_man_ld = createVehicle ["B_Soldier_lite_F", [-0.9,0.1,0], [], 0, "CAN_COLLIDE"];

//_holder_md setDir 180;
_man_ld setDir 90;

temp_target = createVehicle ["Sign_Sphere10cm_F", [10,0,2], [], 0, "CAN_COLLIDE"];

[_holder_rd,90,0,90] call FNC_ROTATE_SIMPLE;

removeAllWeapons _man_ld;
removeAllItems _man_ld;
removeAllAssignedItems _man_ld;
removeUniform _man_ld;
removeVest _man_ld;
removeBackpack _man_ld;
removeHeadgear _man_ld;
//_man_ld disableAI "ANIM";

//_allHolder = [_holder_md, _holder_rd, _man_ld];
_allHolder = [_holder_rd, _man_ld];
_allHolder;
