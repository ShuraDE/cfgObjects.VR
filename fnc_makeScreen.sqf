private ["_picName"];

_picName = _this select 0;

"scr_cap" callExtension (PIC_PATH + _picName + PIC_EXT);

PIC_PATH + _picName + PIC_EXT;
