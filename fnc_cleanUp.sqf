removeAllMissionEventHandlers "Draw3D";

{
    {
        deleteVehicle _x;
    } forEach attachedObjects _x;

    deleteVehicle _x;
} forEach nearestObjects [player, [], 500];
