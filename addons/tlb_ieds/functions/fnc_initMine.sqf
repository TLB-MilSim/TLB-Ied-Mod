/*
 * Fired by CfgAmmo >> EventHandlers >> init, where the mine is local.
 * Attaches the detonation hook. "Explode" only fires on a real detonation -
 * defusing deletes the mine without firing it, so EOD work leaves no crater.
 *
 * Arguments:
 * 0: Mine <OBJECT>
 * 1: Position ASL (unused) <ARRAY>
 */

params ["_mine"];
if (isNull _mine) exitWith {};

diag_log format ["[TLB_IEDs] armed %1", typeOf _mine];

_mine addEventHandler ["Explode", {
    params ["_projectile", "_posASL"];

    if !(TLB_IEDs_enableCraters) exitWith {};

    private _cfg = configOf _projectile;
    private _craterType = getText (_cfg >> "TLB_craterType");
    private _radius = getNumber (_cfg >> "TLB_craterRadius");

    // configOf resolves to CfgAmmo at detonation; fall back through the mine's
    // ammo entry in case we are handed the CfgVehicles side instead.
    if (_craterType isEqualTo "") then {
        private _ammoCfg = configFile >> "CfgAmmo" >> getText (_cfg >> "ammo");
        _craterType = getText (_ammoCfg >> "TLB_craterType");
        _radius = getNumber (_ammoCfg >> "TLB_craterRadius");
    };

    if (_craterType isEqualTo "") exitWith {};
    if (_radius <= 0) then { _radius = 12 };

    diag_log format ["[TLB_IEDs] detonation: %1 -> crater %2 r%3",
        typeOf _projectile, _craterType, _radius];

    // Order matters. Lift first, on every machine, so nothing is standing in the
    // crater's footprint when it appears. This is sent straight to the clients,
    // while the crater still has to round-trip through the server - so the lift
    // is always ahead of the thing it protects against.
    ["TLB_IEDs_blastLift", [_craterType, _posASL]] call CBA_fnc_globalEvent;

    // The server owns the crater so it exists once, globally.
    ["TLB_IEDs_spawnCrater", [_craterType, _posASL, _radius]] call CBA_fnc_serverEvent;
}];

nil
