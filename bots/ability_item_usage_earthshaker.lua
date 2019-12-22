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
-- earthshaker_fissure
-- earthshaker_enchant_totem
-- earthshaker_aftershock
-- earthshaker_echo_slam

-- special_bonus_magic_resistance_50

abilitiesEarlyLvls = {  "earthshaker_fissure",  "earthshaker_aftershock", "earthshaker_enchant_totem" };
abilitiesPriority = {  "earthshaker_echo_slam",  "earthshaker_fissure", "earthshaker_enchant_totem",  "earthshaker_aftershock"};

talents = {"special_bonus_mp_250","special_bonus_movement_speed_30","special_bonus_armor_7", "special_bonus_unique_earthshaker","special_bonus_unique_earthshaker_1","special_bonus_unique_earthshaker_2","special_bonus_unique_earthshaker_3","special_bonus_unique_earthshaker_4"};
bTalents = {0,0,0,0};

AoeID = "ES_Q";
--AoeID2 = "TINY_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_43.4,NBS_12,CHP1_1,LoLVL_1,|SCO_4.9,NBS_24,CHP1_0,LoLVL_0,|SCO_37.1,NBS_50,CHP1_1,LoLVL_0,|SCO_42.6,NBS_6,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_98.7,NBS_12,STUN_0,HHP1_0,HGRP_2,|SCO_56,NBS_6,STUN_0,HHP1_1,HGRP_0,|SCO_67,NBS_3,STUN_1,HHP1_0,HGRP_2,|SCO_75.9,NBS_11,STUN_1,HHP1_0,HGRP_0,|SCO_115.1,NBS_2,STUN_0,HHP1_2,HGRP_2,|SCO_35,NBS_2,STUN_1,HHP1_1,HGRP_0,|SCO_54.4,NBS_2,STUN_2,HHP1_0,HGRP_2,|",
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
		["NAME"]="earthshaker_fissure",
		["DELTA_T"]=1.5,
		["DIST"]={
			["RANGE"]=900,
			["RADIUS"]=150,
		},
		["DMG"]={
			["BASE"]=60,
			["LVL"]=50,
		},
	},
	-- [AoeID2]=
	-- {
		
	-- },
};

abilityList_Basic = {
	["W"]=
	{
		["NAME"]="earthshaker_enchant_totem",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	},
	["R"]=
	{
		["NAME"]="earthshaker_echo_slam",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	},
};

MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const );
const["defaultRange"] = 250;



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







