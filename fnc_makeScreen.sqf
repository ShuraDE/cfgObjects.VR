private ["_picName"];

_picName = _this select 0;
_picMod = _this select 1;

"scr_cap" callExtension (PIC_PATH + _picName + "_" + _picMod + PIC_EXT);

PIC_PATH + _picName + "_" + _picMod + PIC_EXT;
