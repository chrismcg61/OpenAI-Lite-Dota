
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
ItemBuild_Default = require( GetScriptDirectory().."/MyLibs/ItemBuild_Default")
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


------------------------------------------------------------
--- INIT TABLE
------------------------------------------------------------
iStatsMode = 2;  -- 1 = Str, 2 = Agi
iAuraMode = 1; -- 0 = None, 1 = Vlads, 2 = HelmDom
iManaMode = 1;
tableItemsToBuy = {};

-- ItemBuild_Default.InitTable_Carry_Melee( tableItemsToBuy, iStatsMode, iAuraMode, iManaMode );
ItemBuild_Default.InitTable_Auras( tableItemsToBuy );
--ItemBuild_Default.InitTable_Caster_ManaBoots( tableItemsToBuy );


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function ItemPurchaseThink()

	MyUtility.MyPurchaseThink( tableItemsToBuy );

end

