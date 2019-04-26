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
-- windrunner_shackleshot
-- windrunner_powershot
-- windrunner_windrun
-- windrunner_focusfire
-- special_bonus_mp_regen_4
-- special_bonus_unique_windranger_2
-- special_bonus_movement_speed_40
-- special_bonus_intelligence_20
-- special_bonus_spell_amplify_15
-- special_bonus_magic_resistance_20
-- special_bonus_attack_range_100
-- special_bonus_unique_windranger
abilitiesEarlyLvls = { "windrunner_powershot", "windrunner_shackleshot", "windrunner_windrun", };
abilitiesPriority = {  "windrunner_focusfire",  "windrunner_powershot", "windrunner_windrun", "windrunner_shackleshot",  };
AoeID = "WIND_W";
-- AoeID2 = "LINA_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_24,NBS_9,CHP1_1,LoLVL_1,|SCO_4.8,NBS_33,CHP1_0,LoLVL_0,|SCO_33.7,NBS_74,CHP1_1,LoLVL_0,|SCO_34.8,NBS_21,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_73.5,NBS_13,STUN_0,HHP1_0,HGRP_2,|SCO_108.4,NBS_5,STUN_0,HHP1_1,HGRP_0,|SCO_15.2,NBS_3,STUN_0,HHP1_1,HGRP_2,|SCO_23.3,NBS_3,STUN_1,HHP1_1,HGRP_0,|SCO_28.7,NBS_9,STUN_1,HHP1_0,HGRP_0,|SCO_60,NBS_2,STUN_2,HHP1_0,HGRP_0,|SCO_36.3,NBS_3,STUN_1,HHP1_0,HGRP_2,|",
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
		["NAME"]="windrunner_powershot",
		["DELTA_T"]=2.1,
		["DIST"]={
			["RANGE"]=900,
			["RADIUS"]=200,
		},
		["DMG"]={
			["BASE"]=50,
			["LVL"]=80,
		},
	},
	-- [AoeID2]=
	-- {
	
	-- },
};

abilityList_Basic = {
	["Q"]=
	{
		["NAME"]="windrunner_shackleshot",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
	["E"]=
	{
		["NAME"]="windrunner_windrun",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	},
	["R"]=
	{
		["NAME"]="windrunner_focusfire",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT_BUILDING,
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







