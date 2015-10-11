local _ar = _this select 0;
local _prefix = _this select 1;
local _retVal = "";


if (_prefix != "") then {_retVal = _prefix + ":";};

if (count _ar > 0) then {
  {_retVal = _retVal + _x + "<br/>";} forEach _ar;
};

_retVal;
