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
-- tusk_ice_shards
-- tusk_snowball
-- tusk_tag_team  -- tusk_frozen_sigil
-- tusk_launch_snowball
-- tusk_walrus_kick
-- tusk_walrus_punch
-- special_bonus_exp_boost_40
-- special_bonus_attack_damage_35
-- special_bonus_unique_tusk_2
-- special_bonus_gold_income_15
-- special_bonus_armor_6
-- special_bonus_magic_resistance_12
-- special_bonus_hp_700
-- special_bonus_unique_tusk
abilitiesEarlyLvls = {  };
abilitiesPriority = {  "tusk_walrus_punch",  "tusk_ice_shards", "tusk_snowball",  "tusk_tag_team"};
AoeID = "TUSK_Q";
-- AoeID2 = "LINA_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_25,NBS_4,CHP1_1,LoLVL_1,|SCO_4,NBS_5,CHP1_0,LoLVL_0,|SCO_29.6,NBS_36,CHP1_1,LoLVL_0,|SCO_80,NBS_3,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_25.8,NBS_17,STUN_0,HHP1_0,HGRP_2,|SCO_41.1,NBS_3,STUN_1,HHP1_0,HGRP_2,|SCO_4.9,NBS_4,STUN_0,HHP1_1,HGRP_0,|SCO_33.3,NBS_10,STUN_1,HHP1_0,HGRP_0,|SCO_23.4,NBS_2,STUN_2,HHP1_0,HGRP_2,|SCO_23.3,NBS_3,STUN_1,HHP1_1,HGRP_0,|SCO_27.2,NBS_2,STUN_2,HHP1_1,HGRP_2,|SCO_35,NBS_2,STUN_2,HHP1_0,HGRP_0,|SCO_35,NBS_2,STUN_1,HHP1_1,HGRP_2,|",
	},
	-- [AoeID2]=
	-- {
		-- ["C"]= "SCO_3.8,NBS_4,LoLVL_1,CHP1_0,|",
		-- ["H"]= "SCO_3.8,NBS_4,LoLVL_1,CHP1_0,|",
	-- },
};
abilityList_OpenAI = {
	[AoeID]=
	{
		["NAME"]="tusk_ice_shards",
		["DELTA_T"]=1.9,
		["DIST"]={
			["RANGE"]=800,
			["RADIUS"]=200,
		},
		["DMG"]={
			["BASE"]=0,
			["LVL"]=60,
		},
	},
	-- [AoeID2]=
	-- {
	
	-- },
};

abilityList_Basic = {
	["W"]=
	{
		["NAME"]="tusk_snowball",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
	["R"]=
	{
		["NAME"]="tusk_walrus_punch",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
};

MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const );
const["defaultRange"] = 900;



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
	
	listLength = table.getn( abilitiesPriority );		
	for i=1,listLength,1 do
		if npcBot:GetAbilityByName( abilitiesPriority[i] ):CanAbilityBeUpgraded() then
			npcBot:ActionImmediate_LevelAbility( abilitiesPriority[i] );
			return;
		end
	end
	
end







