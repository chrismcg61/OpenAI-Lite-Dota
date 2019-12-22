------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")
MyGenericAbility = require( GetScriptDirectory().."/MyLibs/MyGenericAbility")

OpenAI_Ability_Custom = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability_Custom")
OpenAI_Ability = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability")

------------------------------------------------------------
--- Inits
------------------------------------------------------------
npcBot = GetBot();
initBotMode = npcBot:GetDifficulty();

botStatus = {};
MyUtility.InitStatus( botStatus );

const = {};
var = {};

contextIds = {};
contexts = {};


------------------------------------------------------------
--- Hero CONSTS
------------------------------------------------------------
-- lina_dragon_slave
-- lina_light_strike_array
-- lina_fiery_soul
-- lina_laguna_blade
-- special_bonus_unique_lina_3
-- special_bonus_respawn_reduction_30
-- special_bonus_attack_damage_50
-- special_bonus_cast_range_125
-- special_bonus_spell_amplify_6
-- special_bonus_attack_range_150
-- special_bonus_unique_lina_1
-- special_bonus_unique_lina_2
abilitiesEarlyLvls = {  "lina_dragon_slave",  "lina_fiery_soul", "lina_dragon_slave", "lina_light_strike_array",};
abilitiesPriority = {  "lina_laguna_blade",  "lina_dragon_slave", "lina_fiery_soul",  "lina_light_strike_array"};

talents = {"special_bonus_attack_damage_35","special_bonus_cast_range_100","special_bonus_hp_350","special_bonus_spell_amplify_14","special_bonus_attack_range_175",  "special_bonus_unique_lina","special_bonus_unique_lina_1","special_bonus_unique_lina_2","special_bonus_unique_lina_3","special_bonus_unique_lina_4"};
bTalents = {0,0,0,0};

AoeID = "LINA_Q";
AoeID2 = "LINA_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_27.2,NBS_7,CHP1_1,LoLVL_1,|SCO_26.8,NBS_55,CHP1_1,LoLVL_0,|SCO_4.9,NBS_4,CHP1_0,LoLVL_0,|SCO_64.2,NBS_9,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_28.7,NBS_11,STUN_1,HHP1_0,HGRP_0,|SCO_20.9,NBS_11,STUN_0,HHP1_0,HGRP_2,|SCO_60.5,NBS_3,STUN_0,HHP1_1,HGRP_2,|SCO_26,NBS_2,STUN_1,HHP1_1,HGRP_2,|SCO_37,NBS_6,STUN_0,HHP1_1,HGRP_0,|SCO_73.3,NBS_3,STUN_1,HHP1_1,HGRP_0,|SCO_35,NBS_5,STUN_2,HHP1_0,HGRP_2,|SCO_12.1,NBS_3,STUN_1,HHP1_0,HGRP_2,|SCO_10,NBS_2,STUN_4,HHP1_0,HGRP_2,|",
	},
	[AoeID2]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_15.3,NBS_11,CHP1_1,LoLVL_1,|SCO_4.9,NBS_84,CHP1_0,LoLVL_0,|SCO_23.4,NBS_11,CHP1_1,LoLVL_0,|SCO_90,NBS_2,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_4.9,NBS_4,STUN_1,HHP1_0,HGRP_0,|SCO_62,NBS_11,STUN_0,HHP1_0,HGRP_2,|SCO_45,NBS_6,STUN_0,HHP1_1,HGRP_0,|SCO_117.7,NBS_5,STUN_1,HHP1_0,HGRP_2,|SCO_60,NBS_2,STUN_1,HHP1_1,HGRP_0,|SCO_77.8,NBS_3,STUN_0,HHP1_1,HGRP_2,|",
	},
};
abilityList_OpenAI = {
	[AoeID]=
	{
		["NAME"]="lina_dragon_slave",
		["DELTA_T"]=2.1,
		["DIST"]={
			["RANGE"]=800,
			["RADIUS"]=450,
		},
		["DMG"]={
			["BASE"]=10,
			["LVL"]=75,
		},
	},
	[AoeID2]=
	{
		["NAME"]="lina_light_strike_array",
		["DELTA_T"]=2.0,
		["DIST"]={
			["RANGE"]=500,
			["RADIUS"]=225,
		},
		["DMG"]={
			["BASE"]=40,
			["LVL"]=40,
		},		
	},
};

abilityList_Basic = {
	-- ["W"]=
	-- {
		-- ["NAME"]="earthshaker_enchant_totem",
		-- ["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	-- },
	["R"]=
	{
		["NAME"]="lina_laguna_blade",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
};

MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const );
-- const["defaultRange"] = 250;



OpenAI_Ability_Custom.InitSyncCtx_Ids( contexts, contextIds, abilityList_OpenAI);
OpenAI_Ability.InitVars( var, contextIds );
ctxParams, ctxScores = OpenAI_Ability_Custom.InitCtx_Params_Scores( );

------------------------------------------------------------
--- CONFIG LOAD from TEST Results :
------------------------------------------------------------
function InitTable( mode )
	for Id,Config in pairs( AoeID_Configs ) do
		initCtxStr = OpenAI_Ability_Custom.DefaultConfig_C;
		if(mode~=0)then
			initCtxStr = Config["C"];
		end
		contexts[Id.."C"] = OpenAI.InitTableFromStr( initCtxStr );
		
		initCtxStr = OpenAI_Ability_Custom.DefaultConfig_H;
		if(mode~=0)then
			initCtxStr = Config["H"];
		end
		contexts[Id.."H"] = OpenAI.InitTableFromStr( initCtxStr );		
	end
	
end
InitTable( 0 );
-- InitTable( 1 );





















------------------------------------------------------------
--- FUNCS :
------------------------------------------------------------
function ItemUsageThink()
	MyUtility.UseItems(botStatus);
end

function CourierUsageThink()
	MyUtility.UseCour();
end

function AbilityUsageThink()	

	initBotMode = OpenAI_Ability_Custom.Init_Intel(initBotMode, InitTable);

	for _,abilityId in pairs( abilityList_Basic ) do
		local ability = npcBot:GetAbilityByName( abilityId["NAME"] );		
		local used_ability = MyGenericAbility.ConsiderAbility_Mode( ability, abilityId["TARGET_TYPE"], const );  		--, 1000
		if used_ability then return BOT_ACTION_DESIRE_NONE, 0; end
	end
	
	OpenAI_Ability_Custom.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores);
	
end

function AbilityLevelUpThink()
	if npcBot:GetAbilityPoints()==0 then return; end	
		
	local listLength = table.getn( abilitiesEarlyLvls );		
	for i=1,listLength,1 do
		if i == npcBot:GetLevel() then
			npcBot:ActionImmediate_LevelAbility( abilitiesEarlyLvls[i] );
			return;
		end
	end
	
	MyGenericAbility.TalentLvl(npcBot, bTalents, talents);
	
	listLength = table.getn( abilitiesPriority );		
	for i=1,listLength,1 do
		if npcBot:GetAbilityByName( abilitiesPriority[i] ):CanAbilityBeUpgraded() then
			npcBot:ActionImmediate_LevelAbility( abilitiesPriority[i] );
			return;
		end
	end
	
end







