/**
 * fn_treatmentMutex.sqf
 * @Descr: N/A
 * @Author: Glowbal
 *
 * @Arguments: [client OBJECT, action STRING ("release" releases the mutex if it has been set. "set" for setting the mutex)]
 * @Return: void
 * @PublicAPI: false
 */

#include "script_component.hpp"

private ["_unit", "_set"];

_unit = _this select 0;
_set = if (count _this > 1) then {_this select 1} else {true};

if (_set) exitwith {
    _unit setvariable [QGVAR(PerformingTreatmentMutex), time, true];
};

// Max locked time is 2 minutes.
_unit setvariable [QGVAR(PerformingTreatmentMutex), -120, true];