/*
 * Runs on every machine, fired from the Explode handler BEFORE the server is
 * even asked to build the crater - so this always lands ahead of the crater
 * existing, on any machine, however long the network takes.
 *
 * Lifts anything standing where the crater is about to appear, so the crater
 * materialises underneath it instead of inside it. There is then no mesh
 * penetration for the physics engine to resolve, which is what was launching
 * vehicles into the air.
 *
 * Arguments:
 * 0: Crater classname <STRING>
 * 1: Detonation position ASL <ARRAY>
 */

params ["_craterType", "_posASL"];

private _lift = TLB_IEDs_liftHeight;
if (_lift <= 0) exitWith {};

private _px = _posASL select 0;
private _py = _posASL select 1;

// The crater model's own footprint, not the blast radius - only things that
// would actually end up inside the mesh need lifting. Read from the model so it
// stays correct if the crater types are ever changed.
private _radius = ((sizeOf _craterType) / 2) max 3;

private _candidates = vehicles;
if (TLB_IEDs_includeInfantry) then {
    // Troops on foot only. Lifting a unit that is inside a vehicle rips it out
    // of its seat - the vehicle lift already carries its crew along with it.
    _candidates = _candidates + (allUnits select { isNull objectParent _x });
};

// setPos on a remote object desyncs, so each machine only touches what it owns.
private _affected = _candidates select {
    local _x && {(_x distance2D [_px, _py]) <= _radius}
};
if (_affected isEqualTo []) exitWith {};

private _targets = [];
{
    private _p = getPosATL _x;
    private _targetZ = (_p select 2) + _lift;
    _x setPosATL [_p select 0, _p select 1, _targetZ];

    // Don't add speed, just refuse to be moving downwards into the new hole.
    private _v = velocity _x;
    _x setVelocity [_v select 0, _v select 1, (_v select 2) max 0];

    _targets pushBack [_x, _targetZ];
} forEach _affected;

diag_log format ["[TLB_IEDs] lifted %1 entities by %2m (r%3)", count _targets, _lift, _radius];

if (TLB_IEDs_liftHoldTime <= 0) exitWith {};

// Hold them clear for a moment. On a dedicated server the crater is created a
// network hop after this runs, and gravity would otherwise drop them back down
// before it appears. Height is ATL, so this tracks the ground as they drive.
[{
    params ["_args", "_pfhId"];
    _args params ["_targets", "_deadline"];

    if (CBA_missionTime > _deadline) exitWith { _pfhId call CBA_fnc_removePerFrameHandler };

    {
        _x params ["_obj", "_targetZ"];
        if (isNull _obj || {!local _obj}) then { continue };

        private _p = getPosATL _obj;
        if ((_p select 2) < _targetZ) then {
            _obj setPosATL [_p select 0, _p select 1, _targetZ];
            private _v = velocity _obj;
            _obj setVelocity [_v select 0, _v select 1, (_v select 2) max 0];
        };
    } forEach _targets;
}, 0, [_targets, CBA_missionTime + TLB_IEDs_liftHoldTime]] call CBA_fnc_addPerFrameHandler;
