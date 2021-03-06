ItemBuild_Default={};

------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")

---------------------------------------------
-- All Item Names :
---------------------------------------------
--[[
item_abyssal_blade
item_aegis
item_aether_lens
item_ancient_janggo
item_arcane_boots
item_armlet
item_assault
item_banana
item_basher
item_belt_of_strength
item_bfury
item_black_king_bar
item_blade_mail
item_blade_of_alacrity
item_blades_of_attack
item_blight_stone
item_blink
item_bloodstone
item_bloodthorn
item_boots
item_boots_of_elves
item_bottle
item_bracer
item_branches
item_broadsword
item_buckler
item_butterfly
item_chainmail
item_cheese
item_circlet
item_clarity
item_claymore
item_cloak
item_courier
item_crimson_guard
item_cyclone
item_dagon
item_dagon_2
item_dagon_3
item_dagon_4
item_dagon_5
item_demon_edge
item_desolator
item_diffusal_blade
item_diffusal_blade_2
item_dragon_lance
item_dust
item_eagle
item_echo_sabre
item_enchanted_mango
item_energy_booster
item_ethereal_blade
item_faerie_fire
item_flask
item_flying_courier
item_force_staff
item_gauntlets
item_gem
item_ghost
item_glimmer_cape
item_gloves
item_greater_crit
item_greevil_whistle
item_greevil_whistle_toggle
item_guardian_greaves
item_halloween_candy_corn
item_halloween_rapier
item_hand_of_midas
item_headdress
item_heart
item_heavens_halberd
item_helm_of_iron_will
item_helm_of_the_dominator
item_hood_of_defiance
item_hurricane_pike
item_hyperstone
item_infused_raindrop
item_invis_sword
item_iron_talon
item_javelin
item_lesser_crit
item_lifesteal
item_lotus_orb
item_maelstrom
item_magic_stick
item_magic_wand
item_manta
item_mantle
item_mask_of_madness
item_medallion_of_courage
item_mekansm
item_mithril_hammer
item_mjollnir
item_monkey_king_bar
item_moon_shard
item_mystery_arrow
item_mystery_hook
item_mystery_missile
item_mystery_toss
item_mystery_vacuum
item_mystic_staff
item_necronomicon
item_necronomicon_2
item_necronomicon_3
item_null_talisman
item_oblivion_staff
item_octarine_core
item_ogre_axe
item_orb_of_venom
item_orchid
item_pers
item_phase_boots
item_pipe
item_platemail
item_point_booster
item_poor_mans_shield
item_power_treads
item_present
item_quarterstaff
item_quelling_blade
item_radiance
item_rapier
item_reaver
item_recipe_abyssal_blade
item_recipe_aether_lens
item_recipe_ancient_janggo
item_recipe_arcane_boots
item_recipe_armlet
item_recipe_assault
item_recipe_basher
item_recipe_bfury
item_recipe_black_king_bar
item_recipe_blade_mail
item_recipe_bloodstone
item_recipe_bloodthorn
item_recipe_bracer
item_recipe_buckler
item_recipe_butterfly
item_recipe_crimson_guard
item_recipe_cyclone
item_recipe_dagon
item_recipe_dagon_2
item_recipe_dagon_3
item_recipe_dagon_4
item_recipe_dagon_5
item_recipe_desolator
item_recipe_diffusal_blade
item_recipe_diffusal_blade_2
item_recipe_dragon_lance
item_recipe_echo_sabre
item_recipe_ethereal_blade
item_recipe_force_staff
item_recipe_glimmer_cape
item_recipe_greater_crit
item_recipe_guardian_greaves
item_recipe_hand_of_midas
item_recipe_headdress
item_recipe_heart
item_recipe_heavens_halberd
item_recipe_helm_of_the_dominator
item_recipe_hood_of_defiance
item_recipe_hurricane_pike
item_recipe_invis_sword
item_recipe_iron_talon
item_recipe_lesser_crit
item_recipe_lotus_orb
item_recipe_maelstrom
item_recipe_magic_wand
item_recipe_manta
item_recipe_mask_of_madness
item_recipe_medallion_of_courage
item_recipe_mekansm
item_recipe_mjollnir
item_recipe_monkey_king_bar
item_recipe_moon_shard
item_recipe_necronomicon
item_recipe_necronomicon_2
item_recipe_necronomicon_3
item_recipe_null_talisman
item_recipe_oblivion_staff
item_recipe_octarine_core
item_recipe_orchid
item_recipe_pers
item_recipe_phase_boots
item_recipe_pipe
item_recipe_poor_mans_shield
item_recipe_power_treads
item_recipe_radiance
item_recipe_rapier
item_recipe_refresher
item_recipe_ring_of_aquila
item_recipe_ring_of_basilius
item_recipe_rod_of_atos
item_recipe_sange
item_recipe_sange_and_yasha
item_recipe_satanic
item_recipe_sheepstick
item_recipe_shivas_guard
item_recipe_silver_edge
item_recipe_skadi
item_recipe_solar_crest
item_recipe_soul_booster
item_recipe_soul_ring
item_recipe_sphere
item_recipe_tranquil_boots
item_recipe_travel_boots
item_recipe_travel_boots_2
item_recipe_ultimate_scepter
item_recipe_urn_of_shadows
item_recipe_vanguard
item_recipe_veil_of_discord
item_recipe_vladmir
item_recipe_ward_dispenser
item_recipe_wraith_band
item_recipe_yasha
item_refresher
item_relic
item_ring_of_aquila
item_ring_of_basilius
item_ring_of_health
item_ring_of_protection
item_ring_of_regen
item_river_painter
item_river_painter2
item_river_painter3
item_river_painter4
item_river_painter5
item_river_painter6
item_river_painter7
item_robe
item_rod_of_atos
item_sange
item_sange_and_yasha
item_satanic
item_shadow_amulet
item_sheepstick
item_shivas_guard
item_silver_edge
item_skadi
item_slippers
item_smoke_of_deceit
item_sobi_mask
item_solar_crest
item_soul_booster
item_soul_ring
item_sphere
item_staff_of_wizardry
item_stout_shield
item_talisman_of_evasion
item_tango
item_tango_single
item_tome_of_knowledge
item_tpscroll
item_tranquil_boots
item_travel_boots
item_travel_boots_2
item_ultimate_orb
item_ultimate_scepter
item_urn_of_shadows
item_vanguard
item_veil_of_discord
item_vitality_booster
item_vladmir
item_void_stone
item_ward_dispenser
item_ward_observer
item_ward_sentry
item_wind_lace
item_winter_cake
item_winter_coco
item_winter_cookie
item_winter_greevil_chewy
item_winter_greevil_garbage
item_winter_greevil_treat
item_winter_ham
item_winter_kringle
item_winter_mushroom
item_winter_skates
item_winter_stocking
item_wraith_band
item_yasha
--]]



ItemBuild_Default.items_Auras_1 = { 

	"item_tango",
	--"item_tango",
	-- "item_flask",
	--90g
	
	"item_enchanted_mango",
	--"item_enchanted_mango",
	--160g
	
	"item_stout_shield", 
	--360g	
	
};
ItemBuild_Default.items_Auras_2 = { 	
	
	-- Basi:
	"item_sobi_mask",  --325g
	-- "item_ring_of_protection",  --175g	
	"DELIVER_NOW",
	
	-- "item_bottle",
	"item_magic_stick",
	
	"item_ring_of_protection",  --175g	
	
	--Headdress:
	-- "item_ring_of_regen",
	-- "item_branches",
	-- "item_recipe_headdress",
	-- "DELIVER_NOW",	
	
	
	"item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	
	-- Wand Complete:	
	"item_branches",
	"item_branches",
	"item_recipe_magic_wand",
	
	
	
	--Phase Boots:
	"item_chainmail",
	"item_boots",	
	"item_blades_of_attack",	
};
ItemBuild_Default.items_Auras_5 = { 

	-- Vlads:
	-- "item_ring_of_protection",	
	-- "item_sobi_mask",
	"item_lifesteal",	
	"item_recipe_vladmir",	
	
	-- Helm Dom :
	-- Headdress:
	"item_ring_of_regen",
	"item_recipe_headdress",	
	"item_branches",
	"DELIVER_NOW",	
	"item_ring_of_health",	
	"item_gloves",	
	"item_recipe_helm_of_the_dominator",	
	
	
	
	--Phase Boots:
	-- "item_boots",
	-- "item_chainmail",
	-- "item_blades_of_attack",	
		
	-- Drums
	-- "item_crown",
	-- "item_wind_lace",
	-- "item_sobi_mask",	
	-- "item_recipe_ancient_janggo",
	
	-- AC :
	"item_hyperstone",
	"item_platemail",
	"item_chainmail",
	"item_recipe_assault",	
};

ItemBuild_Default.items_Carry_0 = { 
	
	"item_branches",
	"item_branches",
	-- "item_circlet",
	-- "item_gauntlets",
	--100g
};

ItemBuild_Default.items_Carry_Bottle_1 = { 
	"item_circlet",
	"item_gauntlets",
	
	-- "item_clarity", "item_clarity",
	-- "item_enchanted_mango",
	"item_faerie_fire",
	"item_bottle",
};
ItemBuild_Default.items_Carry_Ranged_1 = { 
	--"item_blight_stone",
	-- "item_faerie_fire",	

	"item_tango",
	--90g
	
	"item_circlet",
	"item_gauntlets",
};
ItemBuild_Default.items_Carry_Melee_1 = { 
	"item_stout_shield",
	--200g
	
	"item_tango",
	"item_tango",
	--380g
	
	"item_circlet",
	"item_gauntlets",
};

ItemBuild_Default.items_Carry_Melee_1a_Hp = { 
	--"item_flask",		
	
	-- "item_blight_stone",	
	
	-- Magic Stick
	"item_magic_stick",			
	-- Wand Complete:	
	"item_recipe_magic_wand",
	"DELIVER_NOW",
	
	-- Basi:
	"item_ring_of_protection",	
	"item_sobi_mask",	
	
	-- "item_infused_raindrop",	
	
	-- BKB :
	-- "item_mithril_hammer",
	-- "item_ogre_axe",
	-- "item_recipe_black_king_bar",	
};
ItemBuild_Default.items_Carry_Melee_1a_Mana = { 
	"item_enchanted_mango",
	"item_enchanted_mango",
	"item_clarity",
	--190g
	
	"item_bottle",
};


ItemBuild_Default.items_Carry_Melee_2_Quelling = { 
	"item_quelling_blade",
	
	-- Magic Stick
	"item_magic_stick",
	
	"item_blight_stone",
};
ItemBuild_Default.items_Carry_Melee_2_Stats_Str = { 	
	-- Bracers Complete
	-- "item_circlet",
	"item_gauntlets",
	"item_recipe_bracer",
};
ItemBuild_Default.items_Carry_Melee_2_Stats_Agi = { 	
	-- Wraith Bands Complete
	-- "item_circlet",
	-- "item_slippers",
	-- "item_recipe_wraith_band",	
	
	-- Bracers Complete
	-- "item_circlet",
	"item_gauntlets",
	"item_recipe_bracer",
};

ItemBuild_Default.items_Carry_Melee_3 = { 	
	"item_boots",
	
	"item_infused_raindrop",	
};

ItemBuild_Default.items_Carry_Melee_4_PhaseBoots = { 
	"item_blades_of_attack",
	"item_chainmail",
};
ItemBuild_Default.items_Carry_Melee_4_PowerTreads = { 
	"item_belt_of_strength",
	"item_gloves",	
};

ItemBuild_Default.items_Carry_Melee_4a_Vlads = { 
	-- Basi:
	"item_ring_of_protection",	
	"item_sobi_mask",
	
	"item_lifesteal",	
	"item_recipe_vladmir",	
};
ItemBuild_Default.items_Carry_Melee_4a_HelmDom = { 
	-- Headdress:
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	
	"item_gloves",		
	"item_ring_of_health",
};

ItemBuild_Default.items_Carry_Melee_5_MomBasher = { 
	
	-- MoM :
	"item_lifesteal",
	"item_quarterstaff",
	
	-- Skull Basher :
	"item_mithril_hammer",
	"item_belt_of_strength",
	"item_recipe_basher",
					
};
ItemBuild_Default.items_Carry_Ranged_5_DragonLance_Deso = { 
	
	-- DL :
	"item_ogre_axe",
	"item_boots_of_elves",
	"item_boots_of_elves",
	
	-- Maelstrom :
	-- "item_mithril_hammer",
	-- "item_javelin",
	
	-- Desolator :
	-- "item_mithril_hammer",
	-- "item_mithril_hammer",
	-- "item_blight_stone",
					
};

ItemBuild_Default.items_Carry_Melee_6 = { 
	
	-- BKB :
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",				
					
	-- Desolator :
	-- "item_mithril_hammer",
	-- "item_mithril_hammer",
	-- "item_blight_stone",	
	
	--MKB:
	"item_demon_edge",	
	"item_javelin",
	"item_quarterstaff",
	
	--Moon Shard:
	"item_hyperstone",
	"item_hyperstone",
				
};


ItemBuild_Default.items_Carry_5_PreBkb_Dmg = { 

	-- MoM :
	"item_lifesteal",
	"item_quarterstaff",

	--MKB:
	-- "item_quarterstaff",
	-- "item_javelin",
	-- "item_demon_edge",		
	
	-- Maelstrom :
	-- "item_mithril_hammer",
	-- "item_javelin",
	
	-- Desolator :
	-- "item_mithril_hammer",
	-- "item_mithril_hammer",
	-- "item_blight_stone",	
	
	-- SB :
	-- "item_claymore",
	-- "item_shadow_amulet",	
					
};
ItemBuild_Default.items_Carry_6_Bkb_Late = { 
	
	-- BKB :
	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",	
		
	-- S&Y :
	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",	
	
	"item_boots_of_elves",	
	"item_blade_of_alacrity",	
	"item_recipe_yasha",	
	
	
	--MKB Complete:
	"item_demon_edge",	
	"item_javelin",
	"item_quarterstaff",
	
	
	--- UPGRADES :
	-- Mjollnir :
	-- "item_hyperstone",
	-- "item_recipe_mjollnir",		
	
	-- -- Silver Edge :
	-- "item_claymore",
	-- "item_shadow_amulet",		
	-- "item_ultimate_orb",
	-- "item_recipe_silver_edge",
	
	
	-- Satanic :
	"item_reaver",
	"item_claymore",
	"item_lifesteal",
	
	
					
};




ItemBuild_Default.items_Caster_0 = { 	
	--"item_enchanted_mango",
	"item_enchanted_mango",
	"item_enchanted_mango",
	--140g
};
ItemBuild_Default.items_Caster_1 = { 		
	"item_branches",
	"item_branches",
	--100g
};
ItemBuild_Default.items_Caster_1a_Clarity = { 
	--2x Clarity
	"item_clarity",
	"item_clarity",
};
ItemBuild_Default.items_Caster_1a_Salve = { 	
	--2x Flask
	"item_flask",	
	"item_flask",	
};
ItemBuild_Default.items_Caster_1a_ClaritySalve = { 
	"item_clarity",
	"item_flask",	
};
ItemBuild_Default.items_Caster_2 = { 

	-- Sage Mask:
	"item_sobi_mask",
	-- "item_ring_of_protection",	
	
	"DELIVER_NOW",

	"item_magic_stick",	
	"item_bottle",
	"item_boots",		
	
	-- Wand Complete:	
	-- "item_branches",
	-- "item_branches",
	"item_recipe_magic_wand",
	
	"DELIVER_NOW",
	
	-- "item_infused_raindrop",	

};
ItemBuild_Default.items_Caster_3_ManaBoots = { 

	"item_energy_booster",	

};
ItemBuild_Default.items_Caster_3_TranquilBoots = { 

	"item_wind_lace",	
	"item_ring_of_regen",

};
ItemBuild_Default.items_Caster_4 = { 

	-- Drums
	"item_wind_lace",
	-- "item_sobi_mask",
	"item_crown",
	"item_recipe_ancient_janggo",
	
	-- Glimmer
	"item_shadow_amulet",
	"item_cloak",

	-- Veil
	-- "item_crown",
	-- "item_helm_of_iron_will",	
	-- "item_recipe_veil_of_discord",
	
	-- Kaya:
	-- "item_staff_of_wizardry",
	-- "item_robe",
	-- "item_recipe_kaya",

	-- Euls:
	-- "item_staff_of_wizardry",	
	-- "item_void_stone",												
	-- "item_wind_lace",
	-- "item_recipe_cyclone",
	
	-- Atos :
	"item_staff_of_wizardry",
	"item_crown",
	"item_crown",						
	"item_recipe_rod_of_atos",
	
	--Sheep:				
	"item_mystic_staff",	
	"item_void_stone",	
	"item_ultimate_orb",

};


ItemBuild_Default.items_TankAuras_1 = { 
	
	"item_stout_shield", 

	"item_tango",	"item_tango",	"item_tango",
	-- "item_flask",
	--470g
	
	-- "item_branches",
	-- "item_branches",	
	-- "item_branches",
	---------------------
	"item_magic_stick",	
	
	"item_ring_of_regen",
	"DELIVER_NOW",		
	
	"item_gauntlets",
	"item_gauntlets",	
			
	-- Wand Complete:	
	"item_branches",
	"item_branches",	
	"item_recipe_magic_wand",	
	"DELIVER_NOW",	

	-- "item_ring_of_protection",
	
	--Headdress:
	-- "item_ring_of_regen",
	"item_branches",
	"item_recipe_headdress",
	"DELIVER_NOW",
	
	-- "item_infused_raindrop",
	-- "item_chainmail",		

	"item_boots",		
	
	--------------------------------------
	--COMPLETE:
	--Bracer:
	-- "item_gauntlets",
	"item_circlet",
	"item_recipe_bracer",
	"DELIVER_NOW",	
	
	-- Helm Dom :
	"item_ring_of_health",	
	"item_recipe_helm_of_the_dominator",
	"DELIVER_NOW",	
	"item_gloves",	
	
	-- Basi :
	"item_ring_of_protection",  --175g	
	"item_sobi_mask",  --325g	
	
	-- Phase Boots:
	-- "item_boots",	
	"item_blades_of_attack",	
	"item_chainmail",		
	
	
	----------------------------------------------------
	-- "item_chainmail",
	
	-- Vlads:
	-- "item_ring_of_protection",	
	-- "item_sobi_mask",
	"item_lifesteal",	
	"item_recipe_vladmir",	
	
	-- AC :
	"item_platemail",
	"item_hyperstone",	
	"item_chainmail",
	"item_recipe_assault",	
	
	-- Radiance:
	"item_relic",
	"item_recipe_radiance",
	
};
ItemBuild_Default.items_HardSupport_1 = { 	
	"item_enchanted_mango",
	"item_enchanted_mango",
	--"item_flask",
	"item_clarity",  "item_clarity", "item_clarity",
	
	"item_branches",  
	"item_branches",
	
	"item_circlet",
	--505g
	
	"item_bottle",	
	
	--Complete Wand:
	"item_magic_stick",
	"item_recipe_magic_wand",	
	"DELIVER_NOW",
	
	"item_boots",		
	
	"item_infused_raindrop",
	"item_wind_lace",
	
	
	---------------------------	
	--Complete Bracers:
	"item_gauntlets", "item_recipe_bracer",
	"DELIVER_NOW",	
	-- "item_circlet", "item_recipe_bracer",
	
	--Complete ManaBoots:
	"item_energy_booster",
	
	--Complete Drums:
	"item_crown",
	"DELIVER_NOW",	
	"item_sobi_mask",	
	"item_recipe_ancient_janggo",
	
	-- Glimmer
	"item_shadow_amulet",
	"item_cloak",
	
	
	---------------------------
	-- Atos :
	"item_crown",
	"item_crown",		
	"item_staff_of_wizardry",	
	"item_recipe_rod_of_atos",
		
	--Sheep:				
	"item_mystic_staff",	
	"item_void_stone",	
	"item_ultimate_orb",	
	
	-- Octarine :
	-- "item_point_booster",
	-- "item_vitality_booster",
	-- "item_energy_booster",
	-- "item_mystic_staff",	
	
	-- Aghs :
	"item_point_booster",
	"item_ogre_axe",
	"item_staff_of_wizardry",						
	"item_blade_of_alacrity",	
	
};

function ItemBuild_Default.InitTable_TankAuras( heroItems )
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_TankAuras_1 );	
	
	LogItemBuild( "'Tank_Auras'" );
end
function ItemBuild_Default.InitTable_Auras( heroItems )
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Auras_1 );	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Auras_2 );	
	
	--MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_3 );	
	--MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4_PhaseBoots );
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Auras_5 );	
	
	-- Log :
	LogItemBuild( "'Auras'" );
end
function ItemBuild_Default.InitTable_Carry_Melee_OLD( heroItems, statsMode, auraMode, manaMode )
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1 );
	
	if manaMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1a_Mana );
	else
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1a_Hp );
	end	
	
	
	if statsMode==0 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Quelling );
	end
	if statsMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Str );
	end
	if statsMode==2 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Agi );
	end
		
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_3 );	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4_PhaseBoots );
	
	if auraMode~=nil then
		if auraMode==1 then
			MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4a_Vlads );
		end
		if auraMode==2 then
			MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4a_HelmDom );
		end
	end
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_5_MomBasher );
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_6 );
	
	
	-- Log :
	LogItemBuild( "'Carry_Melee'" );
	
	return heroItems;
end
function ItemBuild_Default.InitTable_Carry_Ranged_OLD( heroItems, statsMode, auraMode, manaMode )
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Ranged_1 );
	
	if manaMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1a_Mana );
	else
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1a_Hp );
	end	
	
	
	if statsMode==0 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Quelling );
	end
	if statsMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Str );
	end
	if statsMode==2 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Agi );
	end
		
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_3 );	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4_PowerTreads );
	
	if auraMode~=nil then
		if auraMode==1 then
			MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4a_Vlads );
		end
		if auraMode==2 then
			MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4a_HelmDom );
		end
	end
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Ranged_5_DragonLance_Deso );
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_6 );
	
	
	-- Log :
	LogItemBuild( "'Carry_Ranged'" );
	
	return heroItems;
end

function ItemBuild_Default.InitTable_Carry_Melee( heroItems, statsMode, auraMode, manaMode )
	ItemBuild_Default.InitTable_Carry_Generic( heroItems, 0, statsMode, 0 );
end
function ItemBuild_Default.InitTable_Carry_Ranged( heroItems, statsMode, auraMode, manaMode )
	ItemBuild_Default.InitTable_Carry_Generic( heroItems, 1, statsMode, 1 );
end
function ItemBuild_Default.InitTable_Carry_Generic( heroItems, rangeMode, statsMode, bootsMode )
		
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_0 );
		
	if rangeMode==0 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1 );		
	end	
	if rangeMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Ranged_1 );
	end
	if rangeMode==2 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Bottle_1 );
	end
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_1a_Hp );
	
	
	if statsMode==0 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Quelling );
	end
	if statsMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Str );
	end
	if statsMode==2 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_2_Stats_Agi );
	end
		
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_3 );	
	
	if bootsMode==1 then
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4_PowerTreads );
	else
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_Melee_4_PhaseBoots );		
	end	
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_5_PreBkb_Dmg );
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Carry_6_Bkb_Late );
	
	
	-- Log :
	LogItemBuild( "'Carry_Generic'" );
	
	return heroItems;
end

function ItemBuild_Default.InitTable_HardSupport( heroItems )
	

	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_HardSupport_1 );
	
	-- Log :
	LogItemBuild( "'HardSup'" );
	
	return heroItems;
end
function ItemBuild_Default.InitTable_Caster_ManaBoots( heroItems, regenMode )
	
	if regenMode~=nil and regenMode==1 then
		--
	else
		MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_0 );	
	end
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_1 );
	--MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_1a_Salve );	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_1a_ClaritySalve );		
	
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_2 );
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_3_ManaBoots );
	MyUtility.ConcatLists( heroItems, ItemBuild_Default.items_Caster_4 );
	
	
	-- Log :
	LogItemBuild( "'Caster_ManaBoots'" );
	
	return heroItems;
end

function LogItemBuild( buildName )
	npcBot = GetBot();
	local introChat = "ITEM_BUILD '".. npcBot:GetUnitName() .."' = " .. buildName;	
	print(introChat);
	npcBot:ActionImmediate_Chat( introChat ,true);
end





----------------------------------------------------------------------------------------------------
--[[
function ItemPurchaseThink()

	Utility.MyPurchaseThink( tableItemsToBuy );

end
--]]

----------------------------------------------------------------------------------------------------


return ItemBuild_Default;