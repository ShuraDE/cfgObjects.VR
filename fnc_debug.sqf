private ["_msg","_typ"];

//variable checks
if (isNil "DEBUG_OUTPUT") then { DEBUG_OUTPUT = false; };
if (isNil "DEBUG_TYPE_HINT") then { DEBUG_TYPE_HINT = false; };
if (isNil "DEBUG_TYPE_CHAT") then { DEBUG_TYPE_CHAT = false; };
if (isNil "DEBUG_TYPE_LOG") then { DEBUG_TYPE_LOG = true; };

//exit log if disabled
if (DEBUG_OUTPUT) then { exit; };

_msg = _this select 0;
_typ =  param [1, "debug"];

if (DEBUG_TYPE_HINT) then {hintSilent format ["%1: %2", _typ, _msg];};
if (DEBUG_TYPE_CHAT) then {systemChat format ["%1: %2", _typ, _msg];};
if (DEBUG_TYPE_LOG) then {diag_log format ["%1: %2", _typ, _msg]};
