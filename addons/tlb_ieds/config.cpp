// TLB - IEDs
// Adds TLB-branded copies of the vanilla / ACE IED types that leave a
// persistent crater behind when they detonate.

class CfgPatches {
    class TLB_IEDs {
        name = "TLB - IEDs";
        author = "TLB";
        version = "1.0.0";
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Weapons_F", "A3_Modules_F_Curator", "cba_main", "ace_explosives"};
        weapons[] = {};
        units[] = {
            // Editor / Zeus placeable mines
            "TLB_IEDLandBig",         "TLB_IEDLandBig_Range",
            "TLB_IEDUrbanBig",        "TLB_IEDUrbanBig_Range",
            "TLB_IEDLandSmall",       "TLB_IEDLandSmall_Range",
            "TLB_IEDUrbanSmall",      "TLB_IEDUrbanSmall_Range",
            // Zeus placement modules
            "TLB_ModuleExplosive_IEDLandBig",    "TLB_ModuleExplosive_IEDLandBig_Range",
            "TLB_ModuleExplosive_IEDUrbanBig",   "TLB_ModuleExplosive_IEDUrbanBig_Range",
            "TLB_ModuleExplosive_IEDLandSmall",  "TLB_ModuleExplosive_IEDLandSmall_Range",
            "TLB_ModuleExplosive_IEDUrbanSmall", "TLB_ModuleExplosive_IEDUrbanSmall_Range"
        };
    };
};

class Extended_PreInit_EventHandlers {
    class TLB_IEDs {
        init = "call compile preprocessFileLineNumbers '\tlb\ieds\XEH_preInit.sqf'";
    };
};

class CfgEditorSubcategories {
    class TLB_EdSubcat_IEDs {
        displayName = "TLB IEDs";
    };
};

#include "CfgAmmo.hpp"
#include "CfgVehicles.hpp"
