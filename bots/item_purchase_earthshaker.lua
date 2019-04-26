
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
ItemBuild_Default = require( GetScriptDirectory().."/MyLibs/ItemBuild_Default")
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


------------------------------------------------------------
--- INIT TABLE
------------------------------------------------------------
regenMode = 0;  -- 0 = Hp&Mana   -- 1 = Hp Only

tableItemsToBuy = {};
ItemBuild_Default.InitTable_Caster_ManaBoots( tableItemsToBuy, regenMode );


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function ItemPurchaseThink()

	MyUtility.MyPurchaseThink( tableItemsToBuy );

end

