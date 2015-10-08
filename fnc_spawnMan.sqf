[] call ADL_CLEAN_UP;

_man_md = createVehicle ["B_Soldier_lite_F", [0,0.1,0], [], 0, "CAN_COLLIDE"];
_man_rd = createVehicle ["B_Soldier_lite_F", [-0.9,0.1,0], [], 0, "CAN_COLLIDE"];
_man_ld = createVehicle ["B_Soldier_lite_F", [0.9,0.1,0], [], 0, "CAN_COLLIDE"];

_man_md setDir 180;
_man_ld setDir 0;


_allMan = [_man_md, _man_rd, _man_ld];
{
  removeAllWeapons _x;
  removeAllItems _x;
  removeAllAssignedItems _x;
  removeUniform _x;
  removeVest _x;
  removeBackpack _x;
  removeHeadgear _x;
} forEach _allMan;

_allMan;
