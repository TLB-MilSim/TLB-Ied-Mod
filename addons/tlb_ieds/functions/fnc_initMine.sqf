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
    private _setting = getText (_cfg >> "TLB_craterSetting");
    private _default = getNumber (_cfg >> "TLB_craterDefault");

    // configOf resolves to CfgAmmo at detonation; fall back through the mine's
    // ammo entry in case we are handed the CfgVehicles side instead.
    if (_setting isEqualTo "") then {
        private _ammoCfg = configFile >> "CfgAmmo" >> getText (_cfg >> "ammo");
        _setting = getText (_ammoCfg >> "TLB_craterSetting");
        _default = getNumber (_ammoCfg >> "TLB_craterDefault");
    };

    if (_setting isEqualTo "") exitWith {};

    // Which crater this IED type leaves is a CBA setting, not config.
    private _idx = missionNamespace getVariable [_setting, _default];

    // Resolve Random here, once, on this machine only. The chosen classname is
    // then passed to both events - if each machine rolled its own, the lift
    // would size itself against a different crater than the one that appears.
    if (_idx isEqualTo TLB_IEDs_craterRandom) then {
        _idx = 1 + floor random ((count TLB_IEDs_craterTypes) - 1);
    };

    private _craterType = TLB_IEDs_craterTypes param [_idx, ""];
    if (_craterType isEqualTo "") exitWith {};   // "None", or a bad index

    diag_log format ["[TLB_IEDs] detonation: %1 -> crater %2", typeOf _projectile, _craterType];

    // Order matters. Lift first, on every machine, so nothing is standing in the
    // crater's footprint when it appears. This is sent straight to the clients,
    // while the crater still has to round-trip through the server - so the lift
    // is always ahead of the thing it protects against.
    ["TLB_IEDs_blastLift", [_craterType, _posASL]] call CBA_fnc_globalEvent;

    // The server owns the crater so it exists once, globally.
    ["TLB_IEDs_spawnCrater", [_craterType, _posASL]] call CBA_fnc_serverEvent;
}];

nil
