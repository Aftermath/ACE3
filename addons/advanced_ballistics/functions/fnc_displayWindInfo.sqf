#include "script_component.hpp"

#define __dsp (uiNamespace getVariable "RscWindIntuitive")
#define __ctrl (__dsp displayCtrl 132948)

private ["_windSpeed", "_windDir", "_playerDir", "_windIndex", "_windColor", "_newWindSpeed", "_windSource", "_height"];

if (GVAR(WindInfo)) exitWith {
	GVAR(WindInfo) = false;
	0 cutText ["", "PLAIN"];
	true
};
if (underwater ACE_player) exitWith { true };
if (vehicle ACE_player != ACE_player) exitWith { true };

2 cutText ["", "PLAIN"];
GVAR(Protractor) = false;
1 cutText ["", "PLAIN"];
GVAR(WindInfo) = true;

[{
    // abort condition
    if (!(GVAR(WindInfo) && !(underwater ACE_player) && vehicle ACE_player == ACE_player)) exitWith {
        GVAR(WindInfo) = false;
        0 cutText ["", "PLAIN"];
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };
    
    _windIndex = 12;
    _windColor = [1, 1, 1, 1];
    
    _windSpeed = (eyePos ACE_player) call FUNC(calculateWindSpeed);
    
    if (_windSpeed > 0.2) then {
        _playerDir = getDir ACE_player;
        _windDir = (wind select 0) atan2 (wind select 1);
        _windIndex = round(((_playerDir - _windDir + 360) % 360) / 30);
        _windIndex = _windIndex % 12;
    };
    
    // Color Codes from https://en.wikipedia.org/wiki/Beaufort_scale#Modern_scale
    if (_windSpeed > 0.3) then { _windColor = [0.796, 1, 1, 1]; };
    if (_windSpeed > 1.5) then { _windColor = [0.596, 0.996, 0.796, 1]; };
    if (_windSpeed > 3.3) then { _windColor = [0.596, 0.996, 0.596, 1]; };
    if (_windSpeed > 5.4) then { _windColor = [0.6, 0.996, 0.4, 1]; };
    if (_windSpeed > 7.9) then { _windColor = [0.6, 0.996, 0.047, 1]; };
    if (_windSpeed > 10.7) then { _windColor = [0.8, 0.996, 0.059, 1]; };
    if (_windSpeed > 13.8) then { _windColor = [1, 0.996, 0.067, 1]; };
    if (_windSpeed > 17.1) then { _windColor = [1, 0.796, 0.051, 1]; };
    if (_windSpeed > 20.7) then { _windColor = [1, 0.596, 0.039, 1]; };
    if (_windSpeed > 24.4) then { _windColor = [1, 0.404, 0.031, 1]; };
    if (_windSpeed > 28.4) then { _windColor = [1, 0.22, 0.027, 1]; };
    if (_windSpeed > 32.6) then { _windColor = [1, 0.078, 0.027, 1]; };
    
    0 cutRsc ["RscWindIntuitive", "PLAIN", 1, false];
    
    __ctrl ctrlSetScale 0.75;
    __ctrl ctrlCommit 0;
    
    __ctrl ctrlSetText format[QUOTE(PATHTOF(UI\wind%1.paa)), _windIndex];
    __ctrl ctrlSetTextColor _windColor;
    
}, 0.5, _this select 0] call CBA_fnc_addPerFrameHandler;

true