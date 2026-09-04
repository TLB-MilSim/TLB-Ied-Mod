// The crater hook lives on the AMMO, not the mine object, so it fires no matter
// how the IED got into the world: Eden, Zeus module, createMine, or ACE
// placement.
//
// The crater itself is NOT chosen here. Each ammo class only names the CBA
// setting that decides it, plus the index that setting defaults to, so the
// crater for every IED type stays configurable at runtime:
//
//   0 None   1 Small   2 Medium   3 Large   4 Extra Large   5 Random
//
// Index -> classname lives in TLB_IEDs_craterTypes (XEH_preInit.sqf).

#define TLB_CRATER_MEDIUM 2
#define TLB_CRATER_LARGE  3

#define TLB_IED_CRATER(SETTING,DEFAULT) \
    TLB_craterSetting = SETTING; \
    TLB_craterDefault = DEFAULT; \
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
        TLB_IED_CRATER("TLB_IEDs_craterLandBig",TLB_CRATER_LARGE);
    };
    class TLB_IEDLandBig_Range_Ammo: ACE_IEDLandBig_Range_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterLandBigPP",TLB_CRATER_LARGE);
    };
    class TLB_IEDUrbanBig_Remote_Ammo: IEDUrbanBig_Remote_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterUrbanBig",TLB_CRATER_LARGE);
    };
    class TLB_IEDUrbanBig_Range_Ammo: ACE_IEDUrbanBig_Range_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterUrbanBigPP",TLB_CRATER_LARGE);
    };

    // --- TLB small --------------------------------------------------------
    class TLB_IEDLandSmall_Remote_Ammo: IEDLandSmall_Remote_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterLandSmall",TLB_CRATER_MEDIUM);
    };
    class TLB_IEDLandSmall_Range_Ammo: ACE_IEDLandSmall_Range_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterLandSmallPP",TLB_CRATER_MEDIUM);
    };
    class TLB_IEDUrbanSmall_Remote_Ammo: IEDUrbanSmall_Remote_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterUrbanSmall",TLB_CRATER_MEDIUM);
    };
    class TLB_IEDUrbanSmall_Range_Ammo: ACE_IEDUrbanSmall_Range_Ammo {
        TLB_IED_CRATER("TLB_IEDs_craterUrbanSmallPP",TLB_CRATER_MEDIUM);
    };
};
