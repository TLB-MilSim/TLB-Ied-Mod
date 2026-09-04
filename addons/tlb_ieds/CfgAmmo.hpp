// The crater hook lives on the AMMO, not the mine object, so it fires no matter
// how the IED got into the world: Eden, Zeus module, createMine, or ACE placement.
//
// TLB_craterType   - object spawned at the detonation point
// TLB_craterRadius - search radius for vehicles/infantry that need collision
//                    suppression so they are not trapped by the new crater mesh

#define TLB_CRATER_LARGE "Land_ShellCrater_02_large_F"
#define TLB_CRATER_SMALL "Land_ShellCrater_02_small_F"

#define TLB_IED_CRATER(CRATER,RADIUS) \
    TLB_craterType = CRATER; \
    TLB_craterRadius = RADIUS; \
    class EventHandlers { \
        init = "call TLB_IEDs_fnc_initMine"; \
    }

class CfgAmmo {
    // Forward declarations only - never re-state a parent for a class we do not
    // own, or we would rebase the original instead of just referencing it.

    // --- Vanilla bases -----------------------------------------------------
    class IEDLandBig_Remote_Ammo;
    class IEDUrbanBig_Remote_Ammo;
    class IEDLandSmall_Remote_Ammo;
    class IEDUrbanSmall_Remote_Ammo;

    // --- ACE pressure-plate bases -----------------------------------------
    class ACE_IEDLandBig_Range_Ammo;
    class ACE_IEDUrbanBig_Range_Ammo;
    class ACE_IEDLandSmall_Range_Ammo;
    class ACE_IEDUrbanSmall_Range_Ammo;

    // --- TLB large --------------------------------------------------------
    class TLB_IEDLandBig_Remote_Ammo: IEDLandBig_Remote_Ammo {
        TLB_IED_CRATER(TLB_CRATER_LARGE,18);
    };
    class TLB_IEDLandBig_Range_Ammo: ACE_IEDLandBig_Range_Ammo {
        TLB_IED_CRATER(TLB_CRATER_LARGE,18);
    };
    class TLB_IEDUrbanBig_Remote_Ammo: IEDUrbanBig_Remote_Ammo {
        TLB_IED_CRATER(TLB_CRATER_LARGE,18);
    };
    class TLB_IEDUrbanBig_Range_Ammo: ACE_IEDUrbanBig_Range_Ammo {
        TLB_IED_CRATER(TLB_CRATER_LARGE,18);
    };

    // --- TLB small --------------------------------------------------------
    class TLB_IEDLandSmall_Remote_Ammo: IEDLandSmall_Remote_Ammo {
        TLB_IED_CRATER(TLB_CRATER_SMALL,10);
    };
    class TLB_IEDLandSmall_Range_Ammo: ACE_IEDLandSmall_Range_Ammo {
        TLB_IED_CRATER(TLB_CRATER_SMALL,10);
    };
    class TLB_IEDUrbanSmall_Remote_Ammo: IEDUrbanSmall_Remote_Ammo {
        TLB_IED_CRATER(TLB_CRATER_SMALL,10);
    };
    class TLB_IEDUrbanSmall_Range_Ammo: ACE_IEDUrbanSmall_Range_Ammo {
        TLB_IED_CRATER(TLB_CRATER_SMALL,10);
    };
};
