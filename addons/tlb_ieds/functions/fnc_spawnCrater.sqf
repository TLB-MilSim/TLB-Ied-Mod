/*
 * Server only. Creates the crater. It appears instantly - anything standing
 * where it lands has already been lifted clear by fnc_liftEntities, which is
 * fired earlier from the Explode handler.
 *
 * Arguments:
 * 0: Crater classname <STRING>
 * 1: Detonation position ASL <ARRAY>
 *
 * Return Value:
 * The crater <OBJECT>
 */

params ["_craterType", "_posASL"];

private _posAGL = ASLToAGL _posASL;
private _px = _posAGL select 0;
private _py = _posAGL select 1;

private _crater = createVehicle [_craterType, [_px, _py, 0], [], 0, "CAN_COLLIDE"];
if (isNull _crater) exitWith {
    diag_log format ["[TLB_IEDs] Failed to create crater '%1' at %2", _craterType, _posAGL];
    objNull
};

_crater setPosATL [_px, _py, 0];    // sit flush on the terrain, not on the blast Z
_crater setDir (random 360);        // so repeat hits on one route don't look cloned
_crater allowDamage false;
_crater setVariable ["TLB_IEDs_isCrater", true, true];

TLB_IEDs_craters pushBack _crater;
if (TLB_IEDs_maxCraters > 0) then {
    while {count TLB_IEDs_craters > TLB_IEDs_maxCraters} do {
        deleteVehicle (TLB_IEDs_craters deleteAt 0);
    };
};

diag_log format ["[TLB_IEDs] crater %1 at %2", _craterType, getPosATL _crater];

_crater
