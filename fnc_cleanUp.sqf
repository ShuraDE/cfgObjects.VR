removeAllMissionEventHandlers "Draw3D";

{
    {
        deleteVehicle _x;
    } forEach attachedObjects _x;

    deleteVehicle _x;
} forEach nearestObjects [player, [], 500];

sleep 0.1;
