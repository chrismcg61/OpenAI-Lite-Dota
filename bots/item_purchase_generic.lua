
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
ItemBuild_Default = require( GetScriptDirectory().."/MyLibs/ItemBuild_Default")
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


------------------------------------------------------------
--- INIT TABLE
------------------------------------------------------------
tableItemsToBuy = {};
--InitTable_Generic( tableItemsToBuy );

npcBot = GetBot();
atkRange = npcBot:GetAttackRange();
isMelee = atkRange < 200;
statType = npcBot:GetPrimaryAttribute();
--npcBot:ActionImmediate_Chat( "ATK Range = " .. atkRange , true);


items_Generic_StartRanged = { 	
	"item_tango",
	"item_magic_stick",	
	"item_branches", 
	"item_branches",
};
items_Generic_StartMelee = { 	
	"item_flask",
};
items_Generic_StartMana = { 	
	"item_clarity",
	"item_clarity",
	"item_clarity",
	
	"item_bottle",
	"DELIVER_NOW",
};

items_Generic = { 	
			
	"item_circlet",
	"item_gauntlets",
	"item_recipe_bracer",		
	
	"item_recipe_magic_wand",	
	"DELIVER_NOW",
	
	"item_boots",
	"DELIVER_NOW",
	
	--"item_wind_lace",	
	"item_infused_raindrop",
	
};

items_Generic_Melee = { 	
	-------------------------------------
	-- Phase Boots:
	"item_blades_of_attack",	
	"item_chainmail",
	"DELIVER_NOW",	
};
items_Generic_Ranged = { 	
	-------------------------------------
	-- P.Treads:
	"item_belt_of_strength",
	"item_gloves",	
	"DELIVER_NOW",	
};
items_Generic_Mana = { 	
	-------------------------------------
	-- ManaBoots:
	"item_energy_booster",
	--"DELIVER_NOW",	
	
	-- Glimmer
	"item_shadow_amulet",
	"item_cloak",
	"DELIVER_NOW",
};

items_Generic_Late = { 	
	-------------------------------------
	-- Drums:
	-- "item_wind_lace",
	-- "item_crown",	
	-- "item_gloves",	
	-- "item_recipe_ancient_janggo",
	-- "DELIVER_NOW",
	
};
items_Generic_LateCarry = { 
	-- Drums:
	"item_wind_lace",
	"item_crown",	
	"item_gloves",	
	"item_recipe_ancient_janggo",
	"DELIVER_NOW",
	
	-- BKB :	
	"item_mithril_hammer",		
	"item_ogre_axe",
	"item_recipe_black_king_bar",	
	"DELIVER_NOW",
	
	--Moon Shard:
	"item_hyperstone",
	"item_hyperstone",
	
	-- Rapier !! :
	"item_relic",
	"item_demon_edge",	
	
};
items_Generic_LateSupport = { 		
	-- Atos :
	"item_crown",
	"item_crown",						
	"item_staff_of_wizardry",
	"item_recipe_rod_of_atos",
	
	
	--"item_reaver",
	
	-- Halberd :
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",
	"item_talisman_of_evasion",
	
};


MyUtility.ConcatLists( tableItemsToBuy, items_Generic_StartRanged );
if statType == ATTRIBUTE_INTELLECT then
	MyUtility.ConcatLists( tableItemsToBuy, items_Generic_StartMana );
else
	if isMelee then
		MyUtility.ConcatLists( tableItemsToBuy, items_Generic_StartMelee );
	end	
end

MyUtility.ConcatLists( tableItemsToBuy, items_Generic );

if statType == ATTRIBUTE_INTELLECT then
	MyUtility.ConcatLists( tableItemsToBuy, items_Generic_Mana );
else
	if isMelee then
		MyUtility.ConcatLists( tableItemsToBuy, items_Generic_Melee );
	else
		MyUtility.ConcatLists( tableItemsToBuy, items_Generic_Ranged );
	end	
end

MyUtility.ConcatLists( tableItemsToBuy, items_Generic_Late );

if statType == ATTRIBUTE_INTELLECT then
	MyUtility.ConcatLists( tableItemsToBuy, items_Generic_LateSupport );
else
	MyUtility.ConcatLists( tableItemsToBuy, items_Generic_LateCarry );
end


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function ItemPurchaseThink()

	MyUtility.MyPurchaseThink( tableItemsToBuy );

end






