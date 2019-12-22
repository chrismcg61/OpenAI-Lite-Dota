------------------------------------------------------------
--- OpenAI_Ability_Custom
------------------------------------------------------------
OpenAI_Ability_Custom = {};

------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
OpenAI_Ability = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability")



------------------------------------------------------------
--- CONSTS
------------------------------------------------------------
OpenAI_Ability_Custom.DefaultConfig_C = "SCO_5.1,NBS_3,LoLVL_1,CHP1_0,|";
OpenAI_Ability_Custom.DefaultConfig_H = "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|";

------------------------------------------------------------
--- VARS
------------------------------------------------------------
-- ctxParams = {};
-- ctxScores = {};


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function OpenAI_Ability_Custom.InitSyncCtx_Ids( contexts, contextIds, abilityList_OpenAI)
	for id,_ in pairs( abilityList_OpenAI ) do
		local listLength = table.getn( contextIds );	
		contextIds[listLength+1] = {
			["ID"]= id.."C",
			["ABILITY_ID"] = id,
			["FOCUS"] = "CREEPS",
		};
		contextIds[listLength+2] = {
			["ID"]= id.."H",
			["ABILITY_ID"] = id,
			["FOCUS"] = "HEROES",
		};
	end

	for i, id in ipairs(contextIds) do
		contexts[ id["ID"] ] = {};
	end
end

function OpenAI_Ability_Custom.InitCtx_Params_Scores( )
	local ctxParams, ctxScores = OpenAI_Ability.InitCtx_Params_Scores( );
	
	-- ADD CONTEXT PARAMS :
	ctxParams["LoLVL"] = {
		["ID"]="LoLVL",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;

				if var["lastId"]["FOCUS"] == "CREEPS" then
					ctxValue = 0;
					if  abLvl<=1  or  var["lastAbilityDmg"] < 100  then
						ctxValue = 1;
					end
					-- if abLvl<2 then ctxValue = 1; end
				end
				
				return ctxValue;
			end,
	};
	ctxParams["CHP1"] = {
		["ID"]="CHP1",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;
				
				if var["lastId"]["FOCUS"] == "CREEPS" then
					local bEnnemy = true;
					local bHeroes = false;		
					local hp = var["lastAbilityDmg"];
					ctxValue = myFindAoeLoc(bEnnemy, bHeroes, npcBot:GetLocation(), abilityDesc["DIST"]["RANGE"], abilityDesc["DIST"]["RADIUS"], hp);
				end
				
				return ctxValue;
			end,
	};	
	ctxParams["HHP1"] = {
		["ID"]="HHP1",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;
				
				if var["lastId"]["FOCUS"] == "HEROES" then
					local bEnnemy = true;
					local bHeroes = true;	
					local hp = const["lowHeroHp"] + 0.75*var["lastAbilityDmg"];
					ctxValue = myFindAoeLoc(bEnnemy, bHeroes, npcBot:GetLocation(), abilityDesc["DIST"]["RANGE"], abilityDesc["DIST"]["RADIUS"], hp);
				end
				
				return ctxValue;
			end,
	};
	ctxParams["HGRP"] = {
		["ID"]="HGRP",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;
				
				if var["lastId"]["FOCUS"] == "HEROES" then
					local bEnnemy = true;
					local bHeroes = true;	
					local hp = 0;
					ctxValue = myFindAoeLoc(bEnnemy, bHeroes, npcBot:GetLocation(), abilityDesc["DIST"]["RANGE"], abilityDesc["DIST"]["RADIUS"], hp);	
					if(ctxValue <=1)then ctxValue = 0; end
				end
				
				return ctxValue;
			end,
	};
	ctxParams["STUN"] = {
		["ID"]="STUN",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;
				
				if var["lastId"]["FOCUS"] == "HEROES" then
					local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( const["rangeMax"], true, BOT_MODE_NONE );
					local stuns = 0;
					for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
						if npcEnemy:IsStunned() or npcEnemy:IsRooted() or npcEnemy:IsChanneling() then
							stuns = stuns + 1;
							target = npcEnemy:GetLocation();	
						end
					end
					ctxValue = stuns;	
				end
				
				return ctxValue;
			end,
	};
	
	
	-- ADD ABILITY SCORE COMPONENT :
	ctxScores["LH"] = {
		["ID"]="LH",
		["SCORE"]= 20.0,
		["FUNC"]= 
			function ()
				local ctxScore = npcBot:GetLastHits();				
				return ctxScore;
			end,
	};
	ctxScores["K"] = {
		["ID"]="K",
		["SCORE"]= 100.0,
		["FUNC"]= 
			function ()	
				return GetHeroKills(const["playerId"]);	
			end,
	};
	ctxScores["A"] = {
		["ID"]="A",
		["SCORE"]= 50.0,
		["FUNC"]= 
			function ()
				local ctxScore = GetHeroAssists(const["playerId"]);				
				return ctxScore;
			end,
	};
	ctxScores["STUNS"] = {
		["ID"]="CC",
		["SCORE"]= 50.0,
		["FUNC"]= 
			function ()
				local ctxScore = 0;			

				local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( const["rangeMax"], true, BOT_MODE_NONE );
				for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do
					if npcEnemy:IsStunned() then
						ctxScore = ctxScore + 1;
					end
				end
				
				return ctxScore;
			end,
	};
	ctxScores["HeroDmg"] = {
		["ID"]="HDmg",
		["SCORE"]= 0.1,
		["FUNC"]= 
			function ()
				local ctxScore = 0;			

				local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( const["rangeMax"], true, BOT_MODE_NONE );
				local minHeroHp = 9999;
				local minHero = nil;
				for _,npcEnemy in pairs( tableNearbyEnemyHeroes ) do					
					local ennemyHP = npcEnemy:GetHealth();
					if ennemyHP < minHeroHp then
						minHeroHp = ennemyHP;
						minHero = npcEnemy;
					end							
				end
				
				if  minHero~=nil   then 
					--local maxMissingHp = minHero:GetMaxHealth() - minHeroHp;
					ctxScore = minHero:GetMaxHealth() - minHeroHp;
				end
				
				return ctxScore;
			end,
	};
	
	
	return ctxParams, ctxScores;
end

function OpenAI_Ability_Custom.Init_Intel(initBotMode, InitTable)
	local npcBot = GetBot();
	local botMode = npcBot:GetDifficulty();
	if(botMode~=initBotMode)then		
		local infoStr = "OpenAI : Learning Data Loaded!";
		npcBot:ActionImmediate_Chat( infoStr, true);
		--print(infoStr);
		
		InitTable( 1 );
		--initBotMode = botMode;
	end
	
	return botMode;
end

function OpenAI_Ability_Custom.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores)
	
	OpenAI_Ability.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores);
	
end



return OpenAI_Ability_Custom;




















--[[
abaddon
abaddon_death_coil
abaddon_aphotic_shield
abaddon_frostmourne
abaddon_borrowed_time
special_bonus_attack_damage_25
special_bonus_exp_boost_20
special_bonus_mp_200
special_bonus_armor_5
special_bonus_movement_speed_25
special_bonus_cooldown_reduction_15
special_bonus_strength_25
special_bonus_unique_abaddon
abyssal_underlord
abyssal_underlord_firestorm
abyssal_underlord_pit_of_malice
abyssal_underlord_atrophy_aura
abyssal_underlord_dark_rift
abyssal_underlord_cancel_dark_rift
special_bonus_armor_4
special_bonus_mp_regen_2
special_bonus_movement_speed_35
special_bonus_spell_amplify_10
special_bonus_attack_speed_60
special_bonus_cast_range_125
special_bonus_hp_regen_50
special_bonus_unique_underlord
alchemist
alchemist_acid_spray
alchemist_unstable_concoction
alchemist_goblins_greed
alchemist_chemical_rage
alchemist_unstable_concoction_throw
special_bonus_attack_damage_20
special_bonus_armor_4
special_bonus_unique_alchemist_2
special_bonus_all_stats_6
special_bonus_attack_speed_30
special_bonus_hp_300
special_bonus_lifesteal_30
special_bonus_unique_alchemist
ancient_apparition
ancient_apparition_cold_feet
ancient_apparition_ice_vortex
ancient_apparition_chilling_touch
ancient_apparition_ice_blast
ancient_apparition_ice_blast_release
special_bonus_gold_income_10
special_bonus_spell_amplify_8
special_bonus_unique_ancient_apparition_3
special_bonus_hp_regen_30
special_bonus_movement_speed_35
special_bonus_respawn_reduction_35
special_bonus_unique_ancient_apparition_1
special_bonus_unique_ancient_apparition_2
antimage
antimage_mana_break
antimage_blink
antimage_spell_shield
antimage_mana_void
special_bonus_hp_150
special_bonus_attack_damage_20
special_bonus_attack_speed_20
special_bonus_unique_antimage
special_bonus_evasion_15
special_bonus_all_stats_10
special_bonus_agility_25
special_bonus_unique_antimage_2
arc_warden
arc_warden_flux
arc_warden_magnetic_field
arc_warden_spark_wraith
arc_warden_tempest_double
special_bonus_unique_arc_warden_2
special_bonus_attack_speed_25
special_bonus_attack_damage_30
special_bonus_hp_200
special_bonus_cooldown_reduction_10
special_bonus_attack_range_100
special_bonus_lifesteal_30
special_bonus_unique_arc_warden
axe
axe_berserkers_call
axe_battle_hunger
axe_counter_helix
axe_culling_blade
special_bonus_strength_6
special_bonus_mp_regen_3
special_bonus_attack_damage_75
special_bonus_hp_250
special_bonus_hp_regen_25
special_bonus_movement_speed_35
special_bonus_armor_15
special_bonus_unique_axe
bane
bane_enfeeble
bane_brain_sap
bane_nightmare
bane_fiends_grip
bane_nightmare_end
special_bonus_armor_6
special_bonus_mp_200
special_bonus_hp_250
special_bonus_exp_boost_25
special_bonus_unique_bane_1
special_bonus_cast_range_175
special_bonus_movement_speed_100
special_bonus_unique_bane_2
batrider
batrider_sticky_napalm
batrider_flamebreak
batrider_firefly
batrider_flaming_lasso
special_bonus_intelligence_10
special_bonus_armor_4
special_bonus_spell_amplify_5
special_bonus_hp_200
special_bonus_cooldown_reduction_15
special_bonus_movement_speed_35
special_bonus_unique_batrider_1
special_bonus_unique_batrider_2
beastmaster
beastmaster_wild_axes
beastmaster_call_of_the_wild
beastmaster_call_of_the_wild_boar
beastmaster_inner_beast
beastmaster_primal_roar
special_bonus_exp_boost_20
special_bonus_movement_speed_20
special_bonus_strength_12
special_bonus_respawn_reduction_35
special_bonus_cooldown_reduction_12
special_bonus_hp_400
special_bonus_attack_damage_120
special_bonus_unique_beastmaster
bloodseeker
bloodseeker_bloodrage
bloodseeker_blood_bath
bloodseeker_thirst
bloodseeker_rupture
special_bonus_attack_damage_25
special_bonus_hp_225
special_bonus_attack_speed_30
special_bonus_unique_bloodseeker_2
special_bonus_unique_bloodseeker_3
special_bonus_all_stats_10
special_bonus_unique_bloodseeker
special_bonus_lifesteal_30
bounty_hunter
bounty_hunter_shuriken_toss
bounty_hunter_jinada
bounty_hunter_wind_walk
bounty_hunter_track
special_bonus_hp_175
special_bonus_exp_boost_20
special_bonus_attack_speed_40
special_bonus_movement_speed_15
special_bonus_unique_bounty_hunter_2
special_bonus_attack_damage_120
special_bonus_evasion_25
special_bonus_unique_bounty_hunter
brewmaster
brewmaster_thunder_clap
brewmaster_drunken_haze
brewmaster_drunken_brawler
brewmaster_primal_split
special_bonus_attack_speed_30
special_bonus_mp_regen_3
special_bonus_unique_brewmaster_2
special_bonus_magic_resistance_12
special_bonus_respawn_reduction_35
special_bonus_strength_20
special_bonus_attack_damage_75
special_bonus_unique_brewmaster
bristleback
bristleback_viscous_nasal_goo
bristleback_quill_spray
bristleback_bristleback
bristleback_warpath
special_bonus_strength_8
special_bonus_mp_regen_2
special_bonus_hp_200
special_bonus_unique_bristleback
special_bonus_attack_speed_50
special_bonus_respawn_reduction_40
special_bonus_hp_regen_25
special_bonus_unique_bristleback_2
broodmother
broodmother_spawn_spiderlings
broodmother_spin_web
broodmother_incapacitating_bite
broodmother_insatiable_hunger
special_bonus_unique_broodmother_3
special_bonus_exp_boost_25
special_bonus_cooldown_reduction_20
special_bonus_hp_250
special_bonus_unique_broodmother_4
special_bonus_attack_speed_50
special_bonus_unique_broodmother_1
special_bonus_unique_broodmother_2
centaur
centaur_hoof_stomp
centaur_double_edge
centaur_return
centaur_stampede
special_bonus_attack_damage_35
special_bonus_mp_regen_2
special_bonus_evasion_10
special_bonus_magic_resistance_10
special_bonus_spell_amplify_10
special_bonus_strength_15
special_bonus_unique_centaur_1
special_bonus_unique_centaur_2
chaos_knight
chaos_knight_chaos_bolt
chaos_knight_reality_rift
chaos_knight_chaos_strike
chaos_knight_phantasm
special_bonus_attack_speed_15
special_bonus_intelligence_8
special_bonus_movement_speed_20
special_bonus_strength_10
special_bonus_gold_income_20
special_bonus_all_stats_12
special_bonus_cooldown_reduction_20
special_bonus_unique_chaos_knight
chen
chen_penitence
chen_test_of_faith
chen_test_of_faith_teleport
chen_holy_persuasion
chen_hand_of_god
special_bonus_movement_speed_25
special_bonus_cast_range_125
special_bonus_hp_250
special_bonus_unique_chen_3
special_bonus_gold_income_15
special_bonus_respawn_reduction_40
special_bonus_unique_chen_1
special_bonus_unique_chen_2
clinkz
clinkz_strafe
clinkz_searing_arrows
clinkz_wind_walk
clinkz_death_pact
special_bonus_intelligence_10
special_bonus_magic_resistance_10
special_bonus_strength_15
special_bonus_unique_clinkz_1
special_bonus_evasion_20
special_bonus_all_stats_10
special_bonus_attack_range_125
special_bonus_unique_clinkz_2
crystal_maiden
crystal_maiden_crystal_nova
crystal_maiden_frostbite
crystal_maiden_brilliance_aura
crystal_maiden_freezing_field
special_bonus_magic_resistance_15
special_bonus_attack_damage_60
special_bonus_cast_range_125
special_bonus_hp_250
special_bonus_gold_income_20
special_bonus_respawn_reduction_35
special_bonus_unique_crystal_maiden_1
special_bonus_unique_crystal_maiden_2
dark_seer
dark_seer_vacuum
dark_seer_ion_shell
dark_seer_surge
dark_seer_wall_of_replica
special_bonus_evasion_12
special_bonus_cast_range_100
special_bonus_attack_damage_120
special_bonus_hp_regen_14
special_bonus_cooldown_reduction_10
special_bonus_unique_dark_seer_2
special_bonus_strength_25
special_bonus_unique_dark_seer
dazzle
dazzle_poison_touch
dazzle_shallow_grave
dazzle_shadow_wave
dazzle_weave
special_bonus_intelligence_10
special_bonus_hp_125
special_bonus_cast_range_100
special_bonus_attack_damage_60
special_bonus_movement_speed_25
special_bonus_respawn_reduction_30
special_bonus_unique_dazzle_1
special_bonus_unique_dazzle_2
death_prophet
death_prophet_carrion_swarm
death_prophet_silence
death_prophet_spirit_siphon
death_prophet_exorcism
special_bonus_spell_amplify_5
special_bonus_magic_resistance_10
special_bonus_unique_death_prophet_2
special_bonus_cast_range_100
special_bonus_cooldown_reduction_10
special_bonus_movement_speed_50
special_bonus_hp_600
special_bonus_unique_death_prophet
disruptor
disruptor_thunder_strike
disruptor_glimpse
disruptor_kinetic_field
disruptor_static_storm
special_bonus_cast_range_100
special_bonus_gold_income_10
special_bonus_unique_disruptor_2
special_bonus_respawn_reduction_30
special_bonus_hp_400
special_bonus_spell_amplify_10
special_bonus_unique_disruptor
special_bonus_magic_resistance_30
doom_bringer
doom_bringer_devour
doom_bringer_scorched_earth
doom_bringer_infernal_blade
doom_bringer_empty1
doom_bringer_empty2
doom_bringer_doom
special_bonus_hp_250
special_bonus_unique_doom_3
special_bonus_movement_speed_20
special_bonus_unique_doom_4
special_bonus_unique_doom_5
special_bonus_hp_regen_25
special_bonus_unique_doom_1
special_bonus_unique_doom_2
dragon_knight
dragon_knight_breathe_fire
dragon_knight_dragon_tail
dragon_knight_dragon_blood
dragon_knight_elder_dragon_form
special_bonus_strength_9
special_bonus_attack_speed_25
special_bonus_exp_boost_35
special_bonus_attack_damage_40
special_bonus_gold_income_20
special_bonus_hp_300
special_bonus_movement_speed_75
special_bonus_unique_dragon_knight
drow_ranger
drow_ranger_frost_arrows
drow_ranger_wave_of_silence
drow_ranger_trueshot
drow_ranger_marksmanship
special_bonus_movement_speed_15
special_bonus_all_stats_5
special_bonus_hp_175
special_bonus_attack_speed_20
special_bonus_unique_drow_ranger_1
special_bonus_strength_14
special_bonus_unique_drow_ranger_2
special_bonus_unique_drow_ranger_3
earth_spirit
earth_spirit_boulder_smash
earth_spirit_rolling_boulder
earth_spirit_geomagnetic_grip
earth_spirit_stone_caller
earth_spirit_petrify
earth_spirit_magnetize
special_bonus_intelligence_10
special_bonus_armor_4
special_bonus_magic_resistance_15
special_bonus_gold_income_15
special_bonus_spell_amplify_15
special_bonus_hp_300
special_bonus_respawn_reduction_45
special_bonus_unique_earth_spirit
earthshaker
earthshaker_fissure
earthshaker_enchant_totem
earthshaker_aftershock
earthshaker_echo_slam
special_bonus_strength_10
special_bonus_mp_250
special_bonus_movement_speed_20
special_bonus_attack_damage_50
special_bonus_unique_earthshaker_2
special_bonus_respawn_reduction_35
special_bonus_hp_600
special_bonus_unique_earthshaker
elder_titan
elder_titan_echo_stomp
elder_titan_ancestral_spirit
elder_titan_natural_order
elder_titan_return_spirit
elder_titan_earth_splitter
special_bonus_respawn_reduction_20
special_bonus_strength_10
special_bonus_hp_275
special_bonus_unique_elder_titan_2
special_bonus_magic_resistance_12
special_bonus_attack_speed_50
special_bonus_armor_15
special_bonus_unique_elder_titan
ember_spirit
ember_spirit_searing_chains
ember_spirit_sleight_of_fist
ember_spirit_flame_guard
ember_spirit_activate_fire_remnant
ember_spirit_fire_remnant
special_bonus_spell_amplify_10
special_bonus_attack_damage_25
special_bonus_movement_speed_20
special_bonus_all_stats_6
special_bonus_unique_ember_spirit_1
special_bonus_armor_10
special_bonus_cooldown_reduction_20
special_bonus_unique_ember_spirit_2
enchantress
enchantress_untouchable
enchantress_enchant
enchantress_natures_attendants
enchantress_impetus
special_bonus_all_stats_6
special_bonus_movement_speed_25
special_bonus_unique_enchantress_1
special_bonus_attack_damage_50
special_bonus_magic_resistance_15
special_bonus_unique_enchantress_3
special_bonus_respawn_reduction_50
special_bonus_unique_enchantress_2
enigma
enigma_malefice
enigma_demonic_conversion
enigma_midnight_pulse
enigma_black_hole
special_bonus_movement_speed_20
special_bonus_magic_resistance_12
special_bonus_cooldown_reduction_15
special_bonus_gold_income_20
special_bonus_hp_300
special_bonus_respawn_reduction_40
special_bonus_armor_12
special_bonus_unique_enigma
faceless_void
faceless_void_time_walk
faceless_void_time_dilation
faceless_void_time_lock
faceless_void_chronosphere
special_bonus_attack_speed_15
special_bonus_strength_8
special_bonus_armor_7
special_bonus_attack_damage_25
special_bonus_hp_300
special_bonus_gold_income_20
special_bonus_evasion_20
special_bonus_unique_faceless_void
furion
furion_sprout
furion_teleportation
furion_force_of_nature
furion_wrath_of_nature
special_bonus_attack_damage_30
special_bonus_hp_225
special_bonus_intelligence_20
special_bonus_movement_speed_35
special_bonus_attack_speed_35
special_bonus_armor_10
special_bonus_respawn_reduction_40
special_bonus_unique_furion
gyrocopter
gyrocopter_rocket_barrage
gyrocopter_homing_missile
gyrocopter_flak_cannon
gyrocopter_call_down
special_bonus_spell_amplify_6
special_bonus_hp_225
special_bonus_magic_resistance_15
special_bonus_attack_damage_30
special_bonus_movement_speed_35
special_bonus_cooldown_reduction_20
special_bonus_unique_gyrocopter_1
special_bonus_unique_gyrocopter_2
huskar
huskar_inner_vitality
huskar_burning_spear
huskar_berserkers_blood
huskar_life_break
special_bonus_hp_175
special_bonus_unique_huskar_2
special_bonus_attack_damage_30
special_bonus_lifesteal_15
special_bonus_strength_15
special_bonus_attack_speed_40
special_bonus_attack_range_100
special_bonus_unique_huskar
invoker
invoker_quas
invoker_wex
invoker_exort
invoker_empty1
invoker_empty2
invoker_invoke
invoker_cold_snap
invoker_ghost_walk
invoker_tornado
invoker_emp
invoker_alacrity
invoker_chaos_meteor
invoker_sun_strike
invoker_forge_spirit
invoker_ice_wall
invoker_deafening_blast
special_bonus_attack_damage_15
special_bonus_hp_125
special_bonus_unique_invoker_1
special_bonus_exp_boost_30
special_bonus_all_stats_7
special_bonus_attack_speed_35
special_bonus_unique_invoker_2
special_bonus_unique_invoker_3
jakiro
jakiro_dual_breath
jakiro_ice_path
jakiro_liquid_fire
jakiro_macropyre
special_bonus_exp_boost_25
special_bonus_spell_amplify_8
special_bonus_cast_range_125
special_bonus_unique_jakiro_2
special_bonus_attack_range_400
special_bonus_gold_income_25
special_bonus_respawn_reduction_50
special_bonus_unique_jakiro
juggernaut
juggernaut_blade_fury
juggernaut_healing_ward
juggernaut_blade_dance
juggernaut_omni_slash
special_bonus_hp_175
special_bonus_attack_damage_20
special_bonus_attack_speed_20
special_bonus_armor_7
special_bonus_movement_speed_20
special_bonus_all_stats_8
special_bonus_agility_20
special_bonus_unique_juggernaut
keeper_of_the_light
keeper_of_the_light_illuminate
keeper_of_the_light_mana_leak
keeper_of_the_light_chakra_magic
keeper_of_the_light_recall
keeper_of_the_light_blinding_light
keeper_of_the_light_spirit_form
keeper_of_the_light_illuminate_end
keeper_of_the_light_spirit_form_illuminate
keeper_of_the_light_spirit_form_illuminate_end
special_bonus_strength_7
special_bonus_movement_speed_20
special_bonus_exp_boost_20
special_bonus_respawn_reduction_25
special_bonus_magic_resistance_10
special_bonus_armor_7
special_bonus_cast_range_400
special_bonus_unique_keeper_of_the_light
kunkka
kunkka_torrent
kunkka_tidebringer
kunkka_x_marks_the_spot
kunkka_ghostship
kunkka_return
special_bonus_attack_damage_25
special_bonus_unique_kunkka_2
special_bonus_hp_regen_15
special_bonus_movement_speed_20
special_bonus_hp_300
special_bonus_gold_income_20
special_bonus_magic_resistance_35
special_bonus_unique_kunkka
legion_commander
legion_commander_overwhelming_odds
legion_commander_press_the_attack
legion_commander_moment_of_courage
legion_commander_duel
special_bonus_strength_7
special_bonus_exp_boost_20
special_bonus_attack_damage_30
special_bonus_movement_speed_20
special_bonus_armor_7
special_bonus_respawn_reduction_20
special_bonus_unique_legion_commander
special_bonus_unique_legion_commander_2
leshrac
leshrac_split_earth
leshrac_diabolic_edict
leshrac_lightning_storm
leshrac_pulse_nova
special_bonus_hp_125
special_bonus_movement_speed_15
special_bonus_mp_400
special_bonus_magic_resistance_10
special_bonus_spell_amplify_5
special_bonus_strength_15
special_bonus_unique_leshrac_1
special_bonus_unique_leshrac_2
lich
lich_frost_nova
lich_frost_armor
lich_dark_ritual
lich_chain_frost
special_bonus_hp_175
special_bonus_movement_speed_25
special_bonus_cast_range_125
special_bonus_unique_lich_3
special_bonus_attack_damage_150
special_bonus_gold_income_20
special_bonus_unique_lich_1
special_bonus_unique_lich_2
life_stealer
life_stealer_rage
life_stealer_feast
life_stealer_open_wounds
life_stealer_assimilate
life_stealer_assimilate_eject
life_stealer_infest
life_stealer_control
life_stealer_consume
special_bonus_all_stats_5
special_bonus_attack_speed_15
special_bonus_hp_250
special_bonus_attack_damage_25
special_bonus_evasion_15
special_bonus_movement_speed_25
special_bonus_armor_15
special_bonus_unique_lifestealer
lina
lina_dragon_slave
lina_light_strike_array
lina_fiery_soul
lina_laguna_blade
special_bonus_unique_lina_3
special_bonus_respawn_reduction_30
special_bonus_attack_damage_50
special_bonus_cast_range_125
special_bonus_spell_amplify_6
special_bonus_attack_range_150
special_bonus_unique_lina_1
special_bonus_unique_lina_2
lion
lion_impale
lion_voodoo
lion_mana_drain
lion_finger_of_death
special_bonus_respawn_reduction_30
special_bonus_attack_damage_60
special_bonus_unique_lion_2
special_bonus_gold_income_15
special_bonus_magic_resistance_20
special_bonus_spell_amplify_8
special_bonus_all_stats_20
special_bonus_unique_lion
lone_druid
lone_druid_spirit_bear
lone_druid_rabid
lone_druid_savage_roar
lone_druid_true_form_battle_cry
lone_druid_true_form
lone_druid_true_form_druid
special_bonus_hp_250
special_bonus_attack_range_175
special_bonus_attack_damage_50
special_bonus_unique_lone_druid_1
special_bonus_unique_lone_druid_2
special_bonus_respawn_reduction_40
special_bonus_unique_lone_druid_3
special_bonus_unique_lone_druid_4
luna
luna_lucent_beam
luna_moon_glaive
luna_lunar_blessing
luna_eclipse
special_bonus_attack_damage_15
special_bonus_movement_speed_15
special_bonus_hp_150
special_bonus_unique_luna_1
special_bonus_attack_speed_25
special_bonus_magic_resistance_10
special_bonus_all_stats_15
special_bonus_unique_luna_2
lycan
lycan_summon_wolves
lycan_howl
lycan_feral_impulse
lycan_shapeshift
special_bonus_attack_damage_15
special_bonus_hp_175
special_bonus_respawn_reduction_25
special_bonus_strength_12
special_bonus_evasion_15
special_bonus_cooldown_reduction_15
special_bonus_unique_lycan_2
special_bonus_unique_lycan_1
magnataur
magnataur_shockwave
magnataur_empower
magnataur_skewer
magnataur_reverse_polarity
special_bonus_attack_speed_25
special_bonus_spell_amplify_15
special_bonus_gold_income_15
special_bonus_strength_12
special_bonus_unique_magnus_2
special_bonus_movement_speed_40
special_bonus_respawn_reduction_35
special_bonus_unique_magnus
medusa
medusa_split_shot
medusa_mystic_snake
medusa_mana_shield
medusa_stone_gaze
special_bonus_intelligence_12
special_bonus_attack_damage_15
special_bonus_attack_speed_20
special_bonus_evasion_15
special_bonus_unique_medusa_2
special_bonus_mp_600
special_bonus_lifesteal_25
special_bonus_unique_medusa
meepo
meepo_earthbind
meepo_poof
meepo_geostrike
meepo_divided_we_stand
special_bonus_armor_4
special_bonus_attack_damage_15
special_bonus_lifesteal_15
special_bonus_movement_speed_25
special_bonus_evasion_10
special_bonus_attack_speed_25
special_bonus_hp_400
special_bonus_unique_meepo
mirana
mirana_starfall
mirana_arrow
mirana_leap
mirana_invis
special_bonus_agility_8
special_bonus_hp_150
special_bonus_spell_amplify_5
special_bonus_attack_speed_30
special_bonus_attack_damage_50
special_bonus_unique_mirana_3
special_bonus_unique_mirana_1
special_bonus_unique_mirana_2
monkey_king
monkey_king_boundless_strike
monkey_king_tree_dance
monkey_king_primal_spring
monkey_king_primal_spring_early
monkey_king_jingu_mastery
monkey_king_mischief
monkey_king_untransform
monkey_king_wukongs_command
special_bonus_attack_speed_20
special_bonus_armor_5
special_bonus_hp_275
special_bonus_unique_monkey_king_2
special_bonus_attack_damage_40
special_bonus_magic_resistance_20
special_bonus_strength_25
special_bonus_unique_monkey_king
morphling
morphling_waveform
morphling_adaptive_strike
morphling_morph_agi
morphling_morph_str
morphling_hybrid
morphling_replicate
morphling_morph
morphling_morph_replicate
special_bonus_agility_8
special_bonus_mp_200
special_bonus_attack_speed_25
special_bonus_cooldown_reduction_12
special_bonus_movement_speed_25
special_bonus_attack_damage_40
special_bonus_unique_morphling_1
special_bonus_unique_morphling_2
naga_siren
naga_siren_mirror_image
naga_siren_ensnare
naga_siren_rip_tide
naga_siren_song_of_the_siren
naga_siren_song_of_the_siren_cancel
special_bonus_mp_250
special_bonus_hp_125
special_bonus_attack_speed_30
special_bonus_unique_naga_siren_2
special_bonus_agility_15
special_bonus_strength_20
special_bonus_movement_speed_40
special_bonus_unique_naga_siren
necrolyte
necrolyte_death_pulse
necrolyte_sadist
necrolyte_heartstopper_aura
necrolyte_reapers_scythe
special_bonus_attack_damage_40
special_bonus_strength_6
special_bonus_all_stats_6
special_bonus_movement_speed_20
special_bonus_spell_amplify_5
special_bonus_magic_resistance_10
special_bonus_hp_400
special_bonus_unique_necrophos
nevermore
nevermore_shadowraze1
nevermore_shadowraze2
nevermore_shadowraze3
nevermore_necromastery
nevermore_dark_lord
nevermore_requiem
special_bonus_movement_speed_15
special_bonus_attack_speed_20
special_bonus_spell_amplify_6
special_bonus_hp_175
special_bonus_lifesteal_15
special_bonus_unique_nevermore_1
special_bonus_attack_range_150
special_bonus_unique_nevermore_2
night_stalker
night_stalker_void
night_stalker_crippling_fear
night_stalker_hunter_in_the_night
night_stalker_darkness
special_bonus_strength_7
special_bonus_cast_range_100
special_bonus_mp_300
special_bonus_attack_speed_25
special_bonus_movement_speed_30
special_bonus_attack_damage_50
special_bonus_armor_12
special_bonus_unique_night_stalker
nyx_assassin
nyx_assassin_impale
nyx_assassin_mana_burn
nyx_assassin_spiked_carapace
nyx_assassin_burrow
nyx_assassin_unburrow
nyx_assassin_vendetta
special_bonus_spell_amplify_5
special_bonus_hp_175
special_bonus_magic_resistance_12
special_bonus_unique_nyx_2
special_bonus_gold_income_20
special_bonus_agility_40
special_bonus_movement_speed_40
special_bonus_unique_nyx
obsidian_destroyer
obsidian_destroyer_arcane_orb
obsidian_destroyer_astral_imprisonment
obsidian_destroyer_essence_aura
obsidian_destroyer_sanity_eclipse
special_bonus_mp_250
special_bonus_movement_speed_10
special_bonus_armor_5
special_bonus_attack_speed_20
special_bonus_intelligence_15
special_bonus_hp_275
special_bonus_unique_outworld_devourer
special_bonus_spell_amplify_8
ogre_magi
ogre_magi_fireblast
ogre_magi_ignite
ogre_magi_bloodlust
ogre_magi_unrefined_fireblast
ogre_magi_multicast
special_bonus_gold_income_10
special_bonus_cast_range_100
special_bonus_attack_damage_50
special_bonus_magic_resistance_8
special_bonus_hp_250
special_bonus_movement_speed_25
special_bonus_spell_amplify_15
special_bonus_unique_ogre_magi
omniknight
omniknight_purification
omniknight_repel
omniknight_degen_aura
omniknight_guardian_angel
special_bonus_gold_income_10
special_bonus_exp_boost_20
special_bonus_cast_range_75
special_bonus_strength_8
special_bonus_attack_damage_100
special_bonus_mp_regen_6
special_bonus_unique_omniknight_1
special_bonus_unique_omniknight_2
oracle
oracle_fortunes_end
oracle_fates_edict
oracle_purifying_flames
oracle_false_promise
special_bonus_respawn_reduction_20
special_bonus_exp_boost_20
special_bonus_hp_200
special_bonus_gold_income_10
special_bonus_movement_speed_25
special_bonus_intelligence_20
special_bonus_cast_range_250
special_bonus_unique_oracle
phantom_assassin
phantom_assassin_stifling_dagger
phantom_assassin_phantom_strike
phantom_assassin_blur
phantom_assassin_coup_de_grace
special_bonus_hp_150
special_bonus_attack_damage_15
special_bonus_lifesteal_10
special_bonus_movement_speed_20
special_bonus_attack_speed_35
special_bonus_all_stats_10
special_bonus_agility_25
special_bonus_unique_phantom_assassin
phantom_lancer
phantom_lancer_spirit_lance
phantom_lancer_doppelwalk
phantom_lancer_phantom_edge
phantom_lancer_juxtapose
special_bonus_unique_phantom_lancer_2
special_bonus_attack_speed_20
special_bonus_all_stats_8
special_bonus_cooldown_reduction_15
special_bonus_magic_resistance_15
special_bonus_evasion_15
special_bonus_strength_20
special_bonus_unique_phantom_lancer
phoenix
phoenix_icarus_dive
phoenix_fire_spirits
phoenix_sun_ray
phoenix_sun_ray_toggle_move_empty
phoenix_supernova
phoenix_launch_fire_spirit
phoenix_icarus_dive_stop
phoenix_sun_ray_stop
phoenix_sun_ray_toggle_move
special_bonus_respawn_reduction_20
special_bonus_hp_175
special_bonus_unique_phoenix_3
special_bonus_gold_income_20
special_bonus_armor_10
special_bonus_spell_amplify_8
special_bonus_unique_phoenix_1
special_bonus_unique_phoenix_2
puck
puck_illusory_orb
puck_waning_rift
puck_phase_shift
puck_ethereal_jaunt
puck_dream_coil
special_bonus_intelligence_8
special_bonus_hp_175
special_bonus_attack_damage_50
special_bonus_magic_resistance_20
special_bonus_spell_amplify_10
special_bonus_unique_puck_2
special_bonus_gold_income_70
special_bonus_unique_puck
pudge
pudge_meat_hook
pudge_rot
pudge_flesh_heap
pudge_dismember
special_bonus_strength_8
special_bonus_mp_regen_2
special_bonus_armor_5
special_bonus_movement_speed_15
special_bonus_gold_income_25
special_bonus_respawn_reduction_40
special_bonus_unique_pudge_1
special_bonus_unique_pudge_2
pugna
pugna_nether_blast
pugna_decrepify
pugna_nether_ward
pugna_life_drain
special_bonus_mp_regen_3
special_bonus_hp_225
special_bonus_respawn_reduction_35
special_bonus_unique_pugna_4
special_bonus_unique_pugna_3
special_bonus_cast_range_150
special_bonus_unique_pugna_1
special_bonus_unique_pugna_2
queenofpain
queenofpain_shadow_strike
queenofpain_blink
queenofpain_scream_of_pain
queenofpain_sonic_wave
special_bonus_attack_damage_25
special_bonus_strength_9
special_bonus_cooldown_reduction_12
special_bonus_gold_income_15
special_bonus_attack_range_100
special_bonus_hp_300
special_bonus_unique_queen_of_pain
special_bonus_spell_lifesteal_70
rattletrap
rattletrap_battery_assault
rattletrap_power_cogs
rattletrap_rocket_flare
rattletrap_hookshot
special_bonus_armor_4
special_bonus_mp_200
special_bonus_attack_damage_50
special_bonus_unique_clockwerk_2
special_bonus_respawn_reduction_25
special_bonus_magic_resistance_12
special_bonus_hp_400
special_bonus_unique_clockwerk
razor
razor_plasma_field
razor_static_link
razor_unstable_current
razor_eye_of_the_storm
special_bonus_movement_speed_20
special_bonus_agility_15
special_bonus_unique_razor_2
special_bonus_cast_range_150
special_bonus_hp_275
special_bonus_attack_speed_30
special_bonus_attack_range_175
special_bonus_unique_razor
riki
riki_smoke_screen
riki_blink_strike
riki_permanent_invisibility
riki_tricks_of_the_trade
special_bonus_hp_150
special_bonus_movement_speed_15
special_bonus_agility_10
special_bonus_exp_boost_30
special_bonus_cast_range_250
special_bonus_all_stats_8
special_bonus_unique_riki_1
special_bonus_unique_riki_2
rubick
rubick_telekinesis
rubick_telekinesis_land
rubick_fade_bolt
rubick_null_field
rubick_empty1
rubick_empty2
rubick_spell_steal
rubick_hidden1
rubick_hidden2
rubick_hidden3
special_bonus_gold_income_10
special_bonus_attack_damage_60
special_bonus_hp_150
special_bonus_intelligence_15
special_bonus_cast_range_75
special_bonus_spell_amplify_8
special_bonus_cooldown_reduction_20
special_bonus_unique_rubick
sand_king
sandking_burrowstrike
sandking_sand_storm
sandking_caustic_finale
sandking_epicenter
special_bonus_magic_resistance_10
special_bonus_armor_5
special_bonus_unique_sand_king_2
special_bonus_respawn_reduction_30
special_bonus_hp_350
special_bonus_gold_income_20
special_bonus_hp_regen_50
special_bonus_unique_sand_king
shadow_demon
shadow_demon_disruption
shadow_demon_soul_catcher
shadow_demon_shadow_poison
shadow_demon_shadow_poison_release
shadow_demon_demonic_purge
special_bonus_strength_6
special_bonus_movement_speed_10
special_bonus_cast_range_75
special_bonus_spell_amplify_6
special_bonus_magic_resistance_10
special_bonus_respawn_reduction_25
special_bonus_unique_shadow_demon_1
special_bonus_unique_shadow_demon_2
shadow_shaman
shadow_shaman_ether_shock
shadow_shaman_voodoo
shadow_shaman_shackles
shadow_shaman_mass_serpent_ward
special_bonus_hp_175
special_bonus_movement_speed_20
special_bonus_cast_range_100
special_bonus_exp_boost_30
special_bonus_respawn_reduction_30
special_bonus_magic_resistance_20
special_bonus_unique_shadow_shaman_1
special_bonus_unique_shadow_shaman_2
shredder
shredder_whirling_death
shredder_timber_chain
shredder_reactive_armor
shredder_chakram_2
shredder_return_chakram_2
shredder_chakram
shredder_return_chakram
special_bonus_hp_150
special_bonus_exp_boost_20
special_bonus_hp_regen_14
special_bonus_intelligence_20
special_bonus_spell_amplify_5
special_bonus_cast_range_150
special_bonus_unique_timbersaw
special_bonus_strength_20
silencer
silencer_curse_of_the_silent
silencer_glaives_of_wisdom
silencer_last_word
silencer_global_silence
special_bonus_armor_4
special_bonus_intelligence_7
special_bonus_hp_200
special_bonus_gold_income_10
special_bonus_attack_speed_30
special_bonus_magic_resistance_12
special_bonus_attack_range_200
special_bonus_unique_silencer
skeleton_king
skeleton_king_hellfire_blast
skeleton_king_vampiric_aura
skeleton_king_mortal_strike
skeleton_king_reincarnation
special_bonus_attack_damage_15
special_bonus_intelligence_10
special_bonus_movement_speed_15
special_bonus_unique_wraith_king_3
special_bonus_attack_speed_40
special_bonus_strength_20
special_bonus_unique_wraith_king_1
special_bonus_unique_wraith_king_2
skywrath_mage
skywrath_mage_arcane_bolt
skywrath_mage_concussive_shot
skywrath_mage_ancient_seal
skywrath_mage_mystic_flare
special_bonus_hp_125
special_bonus_intelligence_7
special_bonus_attack_damage_75
special_bonus_gold_income_15
special_bonus_movement_speed_20
special_bonus_magic_resistance_15
special_bonus_mp_regen_14
special_bonus_unique_skywrath
slardar
slardar_sprint
slardar_slithereen_crush
slardar_bash
slardar_amplify_damage
special_bonus_hp_regen_6
special_bonus_mp_175
special_bonus_hp_225
special_bonus_attack_speed_25
special_bonus_attack_damage_35
special_bonus_armor_7
special_bonus_strength_20
special_bonus_unique_slardar
slark
slark_dark_pact
slark_pounce
slark_essence_shift
slark_shadow_dance
special_bonus_lifesteal_10
special_bonus_attack_damage_15
special_bonus_agility_15
special_bonus_strength_15
special_bonus_cooldown_reduction_10
special_bonus_attack_speed_25
special_bonus_all_stats_12
special_bonus_unique_slark
sniper
sniper_shrapnel
sniper_headshot
sniper_take_aim
sniper_assassinate
special_bonus_mp_regen_5
special_bonus_attack_speed_15
special_bonus_unique_sniper_1
special_bonus_hp_200
special_bonus_armor_8
special_bonus_cooldown_reduction_25
special_bonus_attack_range_100
special_bonus_unique_sniper_2
spectre
spectre_spectral_dagger
spectre_desolate
spectre_dispersion
spectre_reality
spectre_haunt
special_bonus_attack_damage_20
special_bonus_armor_5
special_bonus_all_stats_8
special_bonus_movement_speed_20
special_bonus_attack_speed_30
special_bonus_strength_20
special_bonus_hp_400
special_bonus_unique_spectre
spirit_breaker
spirit_breaker_charge_of_darkness
spirit_breaker_empowering_haste
spirit_breaker_greater_bash
spirit_breaker_nether_strike
special_bonus_all_stats_5
special_bonus_movement_speed_20
special_bonus_attack_damage_20
special_bonus_armor_5
special_bonus_gold_income_20
special_bonus_respawn_reduction_40
special_bonus_unique_spirit_breaker_1
special_bonus_unique_spirit_breaker_2
storm_spirit
storm_spirit_static_remnant
storm_spirit_electric_vortex
storm_spirit_overload
storm_spirit_ball_lightning
special_bonus_attack_damage_20
special_bonus_mp_regen_3
special_bonus_hp_200
special_bonus_intelligence_10
special_bonus_attack_speed_40
special_bonus_armor_8
special_bonus_spell_amplify_10
special_bonus_unique_storm_spirit
sven
sven_storm_bolt
sven_great_cleave
sven_warcry
sven_gods_strength
special_bonus_strength_6
special_bonus_mp_200
special_bonus_movement_speed_20
special_bonus_all_stats_8
special_bonus_attack_speed_30
special_bonus_evasion_15
special_bonus_attack_damage_65
special_bonus_unique_sven
techies
techies_land_mines
techies_stasis_trap
techies_suicide
techies_focused_detonate
techies_minefield_sign
techies_remote_mines
special_bonus_movement_speed_20
special_bonus_mp_regen_2
special_bonus_exp_boost_30
special_bonus_cast_range_200
special_bonus_gold_income_20
special_bonus_respawn_reduction_60
special_bonus_cooldown_reduction_20
special_bonus_unique_techies
templar_assassin
templar_assassin_refraction
templar_assassin_meld
templar_assassin_psi_blades
templar_assassin_trap
templar_assassin_psionic_trap
special_bonus_attack_speed_25
special_bonus_movement_speed_20
special_bonus_all_stats_6
special_bonus_evasion_12
special_bonus_hp_275
special_bonus_attack_damage_40
special_bonus_respawn_reduction_30
special_bonus_unique_templar_assassin
terrorblade
terrorblade_reflection
terrorblade_conjure_image
terrorblade_metamorphosis
terrorblade_sunder
special_bonus_hp_regen_6
special_bonus_attack_speed_15
special_bonus_attack_damage_25
special_bonus_hp_200
special_bonus_agility_15
special_bonus_movement_speed_25
special_bonus_all_stats_15
special_bonus_unique_terrorblade
tidehunter
tidehunter_gush
tidehunter_kraken_shell
tidehunter_anchor_smash
tidehunter_ravage
special_bonus_attack_damage_50
special_bonus_hp_150
special_bonus_armor_7
special_bonus_exp_boost_35
special_bonus_mp_regen_6
special_bonus_strength_15
special_bonus_cooldown_reduction_20
special_bonus_unique_tidehunter
tinker
tinker_laser
tinker_heat_seeking_missile
tinker_march_of_the_machines
tinker_rearm
special_bonus_intelligence_8
special_bonus_armor_6
special_bonus_hp_225
special_bonus_spell_amplify_4
special_bonus_cast_range_75
special_bonus_magic_resistance_15
special_bonus_spell_lifesteal_20
special_bonus_unique_tinker
tiny
tiny_avalanche
tiny_toss
tiny_craggy_exterior
tiny_grow
special_bonus_strength_6
special_bonus_intelligence_12
special_bonus_attack_damage_60
special_bonus_movement_speed_35
special_bonus_attack_speed_25
special_bonus_mp_regen_14
special_bonus_cooldown_reduction_20
special_bonus_unique_tiny
treant
treant_natures_guise
treant_leech_seed
treant_living_armor
treant_eyes_in_the_forest
treant_overgrowth
special_bonus_attack_speed_30
special_bonus_mp_regen_2
special_bonus_gold_income_15
special_bonus_movement_speed_25
special_bonus_cooldown_reduction_15
special_bonus_attack_damage_90
special_bonus_respawn_reduction_50
special_bonus_unique_treant
troll_warlord
troll_warlord_berserkers_rage
troll_warlord_whirling_axes_ranged
troll_warlord_whirling_axes_melee
troll_warlord_fervor
troll_warlord_battle_trance
special_bonus_strength_7
special_bonus_agility_10
special_bonus_movement_speed_15
special_bonus_armor_6
special_bonus_hp_350
special_bonus_attack_damage_40
special_bonus_magic_resistance_20
special_bonus_unique_troll_warlord
tusk
tusk_ice_shards
tusk_snowball
tusk_frozen_sigil
tusk_launch_snowball
tusk_walrus_kick
tusk_walrus_punch
special_bonus_exp_boost_40
special_bonus_attack_damage_35
special_bonus_unique_tusk_2
special_bonus_gold_income_15
special_bonus_armor_6
special_bonus_magic_resistance_12
special_bonus_hp_700
special_bonus_unique_tusk
undying
undying_decay
undying_soul_rip
undying_tombstone
undying_flesh_golem
special_bonus_respawn_reduction_30
special_bonus_gold_income_15
special_bonus_exp_boost_35
special_bonus_hp_300
special_bonus_unique_undying
special_bonus_movement_speed_30
special_bonus_armor_15
special_bonus_unique_undying_2
ursa
ursa_earthshock
ursa_overpower
ursa_fury_swipes
ursa_enrage
special_bonus_attack_damage_25
special_bonus_magic_resistance_10
special_bonus_armor_5
special_bonus_attack_speed_20
special_bonus_movement_speed_15
special_bonus_hp_250
special_bonus_all_stats_14
special_bonus_unique_ursa
vengefulspirit
vengefulspirit_magic_missile
vengefulspirit_wave_of_terror
vengefulspirit_command_aura
vengefulspirit_nether_swap
special_bonus_magic_resistance_8
special_bonus_attack_speed_25
special_bonus_all_stats_8
special_bonus_unique_vengeful_spirit_1
special_bonus_attack_damage_65
special_bonus_movement_speed_35
special_bonus_unique_vengeful_spirit_2
special_bonus_unique_vengeful_spirit_3
venomancer
venomancer_venomous_gale
venomancer_poison_sting
venomancer_plague_ward
venomancer_poison_nova
special_bonus_exp_boost_30
special_bonus_movement_speed_30
special_bonus_hp_200
special_bonus_cast_range_150
special_bonus_attack_damage_75
special_bonus_magic_resistance_15
special_bonus_respawn_reduction_60
special_bonus_unique_venomancer
viper
viper_poison_attack
viper_nethertoxin
viper_corrosive_skin
viper_viper_strike
special_bonus_attack_damage_15
special_bonus_hp_150
special_bonus_strength_8
special_bonus_agility_14
special_bonus_armor_7
special_bonus_attack_range_75
special_bonus_unique_viper_1
special_bonus_unique_viper_2
visage
visage_grave_chill
visage_soul_assumption
visage_gravekeepers_cloak
visage_summon_familiars
special_bonus_gold_income_15
special_bonus_exp_boost_30
special_bonus_attack_damage_50
special_bonus_cast_range_100
special_bonus_hp_300
special_bonus_respawn_reduction_40
special_bonus_spell_amplify_20
special_bonus_unique_visage_2
warlock
warlock_fatal_bonds
warlock_shadow_word
warlock_upheaval
warlock_rain_of_chaos
special_bonus_exp_boost_20
special_bonus_all_stats_6
special_bonus_cast_range_150
special_bonus_unique_warlock_3
special_bonus_hp_350
special_bonus_respawn_reduction_30
special_bonus_unique_warlock_1
special_bonus_unique_warlock_2
weaver
weaver_the_swarm
weaver_shukuchi
weaver_geminate_attack
weaver_time_lapse
special_bonus_strength_6
special_bonus_unique_weaver_1
special_bonus_attack_damage_25
special_bonus_all_stats_7
special_bonus_hp_200
special_bonus_agility_15
special_bonus_magic_resistance_35
special_bonus_unique_weaver_2
windrunner
windrunner_shackleshot
windrunner_powershot
windrunner_windrun
windrunner_focusfire
special_bonus_mp_regen_4
special_bonus_unique_windranger_2
special_bonus_movement_speed_40
special_bonus_intelligence_20
special_bonus_spell_amplify_15
special_bonus_magic_resistance_20
special_bonus_attack_range_100
special_bonus_unique_windranger
winter_wyvern
winter_wyvern_arctic_burn
winter_wyvern_splinter_blast
winter_wyvern_cold_embrace
winter_wyvern_winters_curse
special_bonus_intelligence_8
special_bonus_strength_7
special_bonus_movement_speed_15
special_bonus_attack_damage_40
special_bonus_gold_income_20
special_bonus_respawn_reduction_35
special_bonus_unique_winter_wyvern_1
special_bonus_unique_winter_wyvern_2
wisp
wisp_tether
wisp_tether_break
wisp_spirits
wisp_overcharge
wisp_empty1
wisp_empty2
wisp_relocate
wisp_spirits_in
wisp_spirits_out
special_bonus_magic_resistance_10
special_bonus_armor_6
special_bonus_mp_regen_10
special_bonus_strength_10
special_bonus_hp_regen_20
special_bonus_gold_income_20
special_bonus_respawn_reduction_50
special_bonus_unique_wisp
witch_doctor
witch_doctor_paralyzing_cask
witch_doctor_voodoo_restoration
witch_doctor_maledict
witch_doctor_death_ward
special_bonus_hp_200
special_bonus_exp_boost_25
special_bonus_attack_damage_90
special_bonus_respawn_reduction_40
special_bonus_armor_8
special_bonus_magic_resistance_15
special_bonus_unique_witch_doctor_1
special_bonus_unique_witch_doctor_2
zuus
zuus_arc_lightning
zuus_lightning_bolt
zuus_static_field
zuus_cloud
zuus_thundergods_wrath
special_bonus_mp_regen_2
special_bonus_hp_200
special_bonus_armor_5
special_bonus_magic_resistance_10
special_bonus_movement_speed_35
special_bonus_respawn_reduction_40
special_bonus_cast_range_200
special_bonus_unique_zeus
Misc
fountain_buyback
fountain_glyph
ghost_frost_attack
giant_wolf_critical_strike
gnoll_assassin_envenomed_weapon
greevil_black_hole
greevil_blade_fury
greevil_bloodlust
greevil_decrepify
greevil_echo_slam
greevil_fatal_bonds
greevil_flesh_golem
greevil_hook
greevil_ice_wall
greevil_laguna_blade
greevil_leech_seed
greevil_magic_missile
greevil_maledict
greevil_natures_attendants
greevil_phantom_strike
greevil_poison_nova
greevil_purification
greevil_rot
greevil_shadow_wave
greevil_time_lock
harpy_storm_chain_lightning
kobold_taskmaster_speed_aura
leoric_critical_strike
leoric_hellfire_blast
leoric_lifesteal_aura
leoric_reincarnate
modifier_buyback_gold_penalty
modifier_illusion
modifier_invulnerable
modifier_magicimmune
neutral_spell_immunity
polar_furbolg_ursa_warrior_thunder_clap
roshan_bash
roshan_halloween_angry
roshan_halloween_apocalypse
roshan_halloween_candy
roshan_halloween_fed
roshan_halloween_levels
roshan_halloween_toss
roshan_halloween_wave_of_force
roshan_slam
roshan_spell_block
roshan__halloween_shell
rune_doubledamage
rune_haste
rune_invis
rune_regen
satyr_hellcaller_shockwave
satyr_hellcaller_unholy_aura
satyr_soulstealer_mana_burn
satyr_trickster_purge
tornado_tempest
--]]

