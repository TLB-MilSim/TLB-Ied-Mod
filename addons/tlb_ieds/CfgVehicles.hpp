// Straight copies of the eight IED types, re-pointed at the TLB ammo classes.
// Everything else (defusing, pressure plate, cellphone, clacker, dead man switch)
// is inherited from vanilla / ACE unchanged.

// displayName is deliberately NOT a macro argument: the config preprocessor
// splits macro arguments on commas, which silently ate the comma in names like
// "TLB IED (Large, Dug-in)".
#define TLB_IED_MINE \
    author = "TLB"; \
    editorSubcategory = "TLB_EdSubcat_IEDs"

class CfgVehicles {
    // Forward declarations only - never re-state a parent for a class we do not
    // own, or we would rebase the original instead of just referencing it.

    // --- Vanilla bases -----------------------------------------------------
    class IEDLandBig_F;
    class IEDUrbanBig_F;
    class IEDLandSmall_F;
    class IEDUrbanSmall_F;

    // --- ACE pressure-plate bases -----------------------------------------
    class ACE_IEDLandBig_Range;
    class ACE_IEDUrbanBig_Range;
    class ACE_IEDLandSmall_Range;
    class ACE_IEDUrbanSmall_Range;

    // --- TLB mines ---------------------------------------------------------
    class TLB_IEDLandBig: IEDLandBig_F {
        TLB_IED_MINE;
        displayName = "TLB IED (Large, Dug-in)";
        ammo = "TLB_IEDLandBig_Remote_Ammo";
    };
    class TLB_IEDLandBig_Range: ACE_IEDLandBig_Range {
        TLB_IED_MINE;
        displayName = "TLB IED (Large, Dug-in, Pressure Plate)";
        ammo = "TLB_IEDLandBig_Range_Ammo";
    };
    class TLB_IEDUrbanBig: IEDUrbanBig_F {
        TLB_IED_MINE;
        displayName = "TLB IED (Large, Urban)";
        ammo = "TLB_IEDUrbanBig_Remote_Ammo";
    };
    class TLB_IEDUrbanBig_Range: ACE_IEDUrbanBig_Range {
        TLB_IED_MINE;
        displayName = "TLB IED (Large, Urban, Pressure Plate)";
        ammo = "TLB_IEDUrbanBig_Range_Ammo";
    };
    class TLB_IEDLandSmall: IEDLandSmall_F {
        TLB_IED_MINE;
        displayName = "TLB IED (Small, Dug-in)";
        ammo = "TLB_IEDLandSmall_Remote_Ammo";
    };
    class TLB_IEDLandSmall_Range: ACE_IEDLandSmall_Range {
        TLB_IED_MINE;
        displayName = "TLB IED (Small, Dug-in, Pressure Plate)";
        ammo = "TLB_IEDLandSmall_Range_Ammo";
    };
    class TLB_IEDUrbanSmall: IEDUrbanSmall_F {
        TLB_IED_MINE;
        displayName = "TLB IED (Small, Urban)";
        ammo = "TLB_IEDUrbanSmall_Remote_Ammo";
    };
    class TLB_IEDUrbanSmall_Range: ACE_IEDUrbanSmall_Range {
        TLB_IED_MINE;
        displayName = "TLB IED (Small, Urban, Pressure Plate)";
        ammo = "TLB_IEDUrbanSmall_Range_Ammo";
    };

    // --- Zeus placement modules -------------------------------------------
    class ModuleExplosive_IEDLandBig_F;
    class ModuleExplosive_IEDUrbanBig_F;
    class ModuleExplosive_IEDLandSmall_F;
    class ModuleExplosive_IEDUrbanSmall_F;
    class ACE_ModuleExplosive_IEDLandBig_Range;
    class ACE_ModuleExplosive_IEDUrbanBig_Range;
    class ACE_ModuleExplosive_IEDLandSmall_Range;
    class ACE_ModuleExplosive_IEDUrbanSmall_Range;

    class TLB_ModuleExplosive_IEDLandBig: ModuleExplosive_IEDLandBig_F {
        author = "TLB";
        displayName = "TLB IED (Large, Dug-in)";
        explosive = "TLB_IEDLandBig_Remote_Ammo";
    };
    class TLB_ModuleExplosive_IEDLandBig_Range: ACE_ModuleExplosive_IEDLandBig_Range {
        author = "TLB";
        displayName = "TLB IED (Large, Dug-in, Pressure Plate)";
        explosive = "TLB_IEDLandBig_Range_Ammo";
    };
    class TLB_ModuleExplosive_IEDUrbanBig: ModuleExplosive_IEDUrbanBig_F {
        author = "TLB";
        displayName = "TLB IED (Large, Urban)";
        explosive = "TLB_IEDUrbanBig_Remote_Ammo";
    };
    class TLB_ModuleExplosive_IEDUrbanBig_Range: ACE_ModuleExplosive_IEDUrbanBig_Range {
        author = "TLB";
        displayName = "TLB IED (Large, Urban, Pressure Plate)";
        explosive = "TLB_IEDUrbanBig_Range_Ammo";
    };
    class TLB_ModuleExplosive_IEDLandSmall: ModuleExplosive_IEDLandSmall_F {
        author = "TLB";
        displayName = "TLB IED (Small, Dug-in)";
        explosive = "TLB_IEDLandSmall_Remote_Ammo";
    };
    class TLB_ModuleExplosive_IEDLandSmall_Range: ACE_ModuleExplosive_IEDLandSmall_Range {
        author = "TLB";
        displayName = "TLB IED (Small, Dug-in, Pressure Plate)";
        explosive = "TLB_IEDLandSmall_Range_Ammo";
    };
    class TLB_ModuleExplosive_IEDUrbanSmall: ModuleExplosive_IEDUrbanSmall_F {
        author = "TLB";
        displayName = "TLB IED (Small, Urban)";
        explosive = "TLB_IEDUrbanSmall_Remote_Ammo";
    };
    class TLB_ModuleExplosive_IEDUrbanSmall_Range: ACE_ModuleExplosive_IEDUrbanSmall_Range {
        author = "TLB";
        displayName = "TLB IED (Small, Urban, Pressure Plate)";
        explosive = "TLB_IEDUrbanSmall_Range_Ammo";
    };
};
