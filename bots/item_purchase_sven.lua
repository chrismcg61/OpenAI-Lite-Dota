
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
ItemBuild_Default = require( GetScriptDirectory().."/MyLibs/ItemBuild_Default")
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


------------------------------------------------------------
--- INIT TABLE
------------------------------------------------------------
iStatsMode = 1;  -- 1 = Str
tableItemsToBuy = {};
ItemBuild_Default.InitTable_Carry_Melee( tableItemsToBuy, iStatsMode );


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function ItemPurchaseThink()

	MyUtility.MyPurchaseThink( tableItemsToBuy );

end

