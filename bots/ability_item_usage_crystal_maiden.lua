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
-- crystal_maiden_crystal_nova
-- crystal_maiden_frostbite
-- crystal_maiden_brilliance_aura
-- crystal_maiden_freezing_field

-- special_bonus_hp_250
-- special_bonus_cast_range_100

-- special_bonus_gold_income_150
-- special_bonus_unique_crystal_maiden_4  -- L15: E Aura

-- special_bonus_unique_crystal_maiden_3  -- L20: R Dmg
-- special_bonus_attack_speed_250

-- special_bonus_unique_crystal_maiden_1  -- L25: W Duration
-- special_bonus_unique_crystal_maiden_2  -- L25: Q Dmg


abilitiesEarlyLvls = {  "crystal_maiden_crystal_nova",  "crystal_maiden_brilliance_aura", "crystal_maiden_brilliance_aura", "crystal_maiden_frostbite", };
abilitiesPriority = { "crystal_maiden_freezing_field",  "crystal_maiden_brilliance_aura", "crystal_maiden_crystal_nova",  "crystal_maiden_frostbite"};

talents = {"special_bonus_hp_250","special_bonus_gold_income_150","special_bonus_attack_speed_250", "special_bonus_unique_crystal_maiden_1","special_bonus_unique_crystal_maiden_2","special_bonus_unique_crystal_maiden_3","special_bonus_unique_crystal_maiden_4"};
bTalents = {0,0,0,0};

AoeID = "CM_Q";
--AoeID2 = "TINY_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_16.4,NBS_37,CHP1_1,LoLVL_1,|SCO_4.9,NBS_4,CHP1_0,LoLVL_0,|SCO_24.9,NBS_25,CHP1_1,LoLVL_0,|SCO_15,NBS_6,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_20.5,NBS_28,STUN_0,HHP1_0,HGRP_2,|SCO_36.8,NBS_13,STUN_1,HHP1_0,HGRP_0,|SCO_10,NBS_2,STUN_2,HHP1_0,HGRP_2,|SCO_35,NBS_2,STUN_0,HHP1_1,HGRP_2,|SCO_60.4,NBS_2,STUN_3,HHP1_0,HGRP_2,|SCO_35,NBS_2,STUN_1,HHP1_1,HGRP_0,|SCO_42.9,NBS_2,STUN_1,HHP1_0,HGRP_2,|",
	},
	-- [AoeID2]=
	-- {
		-- ["C"]= "SCO_3.8,NBS_4,LoLVL_1,CHP1_0,|SCO_4.9,NBS_4,LoLVL_1,CHP1_1,|SCO_4.9,NBS_8,LoLVL_0,CHP1_0,|SCO_12.8,NBS_24,LoLVL_0,CHP1_1,|",
		-- ["H"]= "SCO_3.8,NBS_4,LoLVL_1,CHP1_0,|SCO_4.9,NBS_4,LoLVL_1,CHP1_1,|SCO_4.9,NBS_8,LoLVL_0,CHP1_0,|SCO_12.8,NBS_24,LoLVL_0,CHP1_1,|",
	-- },
};
abilityList_OpenAI = {
	[AoeID]=
	{
		["NAME"]="crystal_maiden_crystal_nova",
		["DELTA_T"]=1.5,
		["DIST"]={
			["RANGE"]=600,
			["RADIUS"]=600,
		},
		["DMG"]={
			["BASE"]=90,
			["LVL"]=40,
		},
	},
	-- [AoeID2]=
	-- {
		-- ["NAME"]="tiny_toss",
		-- ["DELTA_T"]=2.5,
		-- ["DIST"]={
			-- ["RANGE"]=900,
			-- ["RADIUS"]=275,
		-- },
		-- ["DMG"]={
			-- ["BASE"]=20,
			-- ["LVL"]=70,
		-- },
	-- },
};

abilityList_Basic = {
	["W"]=
	{
		["NAME"]="crystal_maiden_frostbite",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
	["R"]=
	{
		["NAME"]="crystal_maiden_freezing_field",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	},
};

MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const );
const["defaultRange"] = 600;



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

--talentId = 0;
function AbilityLevelUpThink()
	--AbilityLevelUpThink=nil;
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










