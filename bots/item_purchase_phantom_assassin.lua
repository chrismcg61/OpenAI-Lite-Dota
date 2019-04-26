
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
ItemBuild_Default = require( GetScriptDirectory().."/MyLibs/ItemBuild_Default")
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


------------------------------------------------------------
--- INIT TABLE
------------------------------------------------------------
iStatsMode = 2;  -- 2 = Agi
iAuraMode = 0; -- 0 = None, 1 = Vlads, 2 = HelmDom
iManaMode = 0;

tableItemsToBuy = {};
-- ItemBuild_Default.InitTable_Carry_Melee( tableItemsToBuy, iStatsMode, iAuraMode );
ItemBuild_Default.InitTable_Carry_Melee( tableItemsToBuy, iStatsMode, iAuraMode, iManaMode );


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function ItemPurchaseThink()

	MyUtility.MyPurchaseThink( tableItemsToBuy );

end

