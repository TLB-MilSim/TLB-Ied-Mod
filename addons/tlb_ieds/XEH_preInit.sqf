// TLB - IEDs :: pre-init
// Runs via CBA's Extended_PreInit_EventHandlers, which fires before any mine's
// own init event handler - so the functions below are guaranteed to exist by the
// time an editor-placed TLB IED initialises.

TLB_IEDs_fnc_initMine        = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_initMine.sqf";
TLB_IEDs_fnc_spawnCrater     = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_spawnCrater.sqf";
TLB_IEDs_fnc_liftEntities    = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_liftEntities.sqf";

if (isNil "TLB_IEDs_craters") then { TLB_IEDs_craters = [] };

// Index -> crater classname. The crater settings below store an index into this,
// so adding a size here is all it takes to offer it everywhere.
// Index 5 ("Random") is resolved at detonation time, not stored.
TLB_IEDs_craterTypes = [
    "",                                 // 0 None
    "Land_ShellCrater_01_F",            // 1 Small
    "Land_ShellCrater_02_small_F",      // 2 Medium
    "Land_ShellCrater_02_large_F",      // 3 Large
    "Land_ShellCrater_02_extralarge_F"  // 4 Extra Large
];
TLB_IEDs_craterRandom = 5;

// --- General settings -----------------------------------------------------
[
    "TLB_IEDs_enableCraters", "CHECKBOX",
    ["Spawn craters", "Leave a persistent crater where a TLB IED detonates."],
    "TLB - IEDs",
    true, 1
] call CBA_settings_fnc_init;

[
    "TLB_IEDs_includeInfantry", "CHECKBOX",
    ["Lift infantry too", "Also lift infantry standing where the crater is about to appear, not just vehicles."],
    "TLB - IEDs",
    true, 1
] call CBA_settings_fnc_init;

[
    "TLB_IEDs_liftHeight", "SLIDER",
    ["Lift height (m)", "How far to raise anything standing where the crater is about to appear, so the crater forms underneath it rather than inside it. 0 disables the lift."],
    "TLB - IEDs",
    [0, 5, 1, 1], 1
] call CBA_settings_fnc_init;

[
    "TLB_IEDs_liftHoldTime", "SLIDER",
    ["Lift hold (s)", "How long to stop a lifted vehicle falling back down, covering the network delay before the crater actually appears. 0 for a single instant lift."],
    "TLB - IEDs",
    [0, 5, 1, 1], 1
] call CBA_settings_fnc_init;

[
    "TLB_IEDs_maxCraters", "SLIDER",
    ["Max craters (0 = unlimited)", "Safety valve for very long operations: once exceeded, the oldest craters are removed."],
    "TLB - IEDs",
    [0, 500, 0, 0], 1
] call CBA_settings_fnc_init;

// --- Per-IED crater selection ---------------------------------------------
// One LIST setting per IED type. The ammo classes only name which setting to
// read (TLB_craterSetting) and what it defaults to, so nothing about crater
// choice is baked into the config.
private _values = [0, 1, 2, 3, 4, 5];
private _labels = ["None", "Small", "Medium", "Large", "Extra Large", "Random"];

{
    _x params ["_setting", "_label", "_default"];

    [
        _setting, "LIST",
        [
            format ["Crater: %1", _label],
            "Which crater this IED type leaves. Random picks a different size on every detonation. None disables the crater for this type only."
        ],
        "TLB - IEDs",
        [_values, _labels, _default], 1
    ] call CBA_settings_fnc_init;
} forEach [
    ["TLB_IEDs_craterLandBig",      "Large IED (Dug-in)",                    3],
    ["TLB_IEDs_craterLandBigPP",    "Large IED (Dug-in, Pressure Plate)",    3],
    ["TLB_IEDs_craterUrbanBig",     "Large IED (Urban)",                     3],
    ["TLB_IEDs_craterUrbanBigPP",   "Large IED (Urban, Pressure Plate)",     3],
    ["TLB_IEDs_craterLandSmall",    "Small IED (Dug-in)",                    2],
    ["TLB_IEDs_craterLandSmallPP",  "Small IED (Dug-in, Pressure Plate)",    2],
    ["TLB_IEDs_craterUrbanSmall",   "Small IED (Urban)",                     2],
    ["TLB_IEDs_craterUrbanSmallPP", "Small IED (Urban, Pressure Plate)",     2]
];

// --- Events ---------------------------------------------------------------
["TLB_IEDs_spawnCrater",   { _this call TLB_IEDs_fnc_spawnCrater }]  call CBA_fnc_addEventHandler;
["TLB_IEDs_blastLift",     { _this call TLB_IEDs_fnc_liftEntities }] call CBA_fnc_addEventHandler;

diag_log "[TLB_IEDs] preInit complete";
