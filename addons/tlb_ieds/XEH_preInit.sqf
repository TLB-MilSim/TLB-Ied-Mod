// TLB - IEDs :: pre-init
// Runs via CBA's Extended_PreInit_EventHandlers, which fires before any mine's
// own init event handler - so the functions below are guaranteed to exist by the
// time an editor-placed TLB IED initialises.

TLB_IEDs_fnc_initMine        = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_initMine.sqf";
TLB_IEDs_fnc_spawnCrater     = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_spawnCrater.sqf";
TLB_IEDs_fnc_liftEntities    = compile preprocessFileLineNumbers "\tlb\ieds\functions\fnc_liftEntities.sqf";

if (isNil "TLB_IEDs_craters") then { TLB_IEDs_craters = [] };

// --- Settings -------------------------------------------------------------
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

// --- Events ---------------------------------------------------------------
["TLB_IEDs_spawnCrater",   { _this call TLB_IEDs_fnc_spawnCrater }]     call CBA_fnc_addEventHandler;
["TLB_IEDs_blastLift",     { _this call TLB_IEDs_fnc_liftEntities }]    call CBA_fnc_addEventHandler;

diag_log "[TLB_IEDs] preInit complete";

