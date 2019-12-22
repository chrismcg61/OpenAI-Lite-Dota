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
-- tiny_avalanche
-- tiny_toss
-- tiny_craggy_exterior   -- tiny_tree_grab   	
-- tiny_grow

-- special_bonus_movement_speed_20
-- special_bonus_attack_damage_30

-- "special_bonus_hp_400",

-- special_bonus_strength_20

-- "special_bonus_unique_tiny_1",
-- "special_bonus_unique_tiny_2",
-- "special_bonus_unique_tiny_3",
-- "special_bonus_unique_tiny_4",

abilitiesEarlyLvls = {  "tiny_avalanche",  "tiny_tree_grab", };
abilitiesPriority = {  "tiny_avalanche",  "tiny_toss", "tiny_tree_grab",  "tiny_grow"};

talents = {"special_bonus_movement_speed_20","special_bonus_hp_400","special_bonus_strength_20",  "special_bonus_unique_tiny_1","special_bonus_unique_tiny_2","special_bonus_unique_tiny_3","special_bonus_unique_tiny_4"};
bTalents = {0,0,0,0};

AoeID = "TINY_Q";
--AoeID2 = "TINY_W";
AoeID_Configs = {
	[AoeID]=
	{
		["C"]= "SCO_3.8,NBS_4,CHP1_0,LoLVL_1,|SCO_15.1,NBS_3,CHP1_1,LoLVL_1,|SCO_4.7,NBS_14,CHP1_0,LoLVL_0,|SCO_31.1,NBS_62,CHP1_1,LoLVL_0,|SCO_76.2,NBS_16,CHP1_2,LoLVL_0,|",
		["H"]= "SCO_3.8,NBS_4,STUN_0,HHP1_0,HGRP_0,|SCO_82,NBS_17,STUN_0,HHP1_0,HGRP_2,|SCO_52.2,NBS_6,STUN_0,HHP1_1,HGRP_0,|SCO_76.7,NBS_15,STUN_1,HHP1_0,HGRP_0,|SCO_29.8,NBS_3,STUN_0,HHP1_1,HGRP_2,|SCO_60,NBS_2,STUN_1,HHP1_2,HGRP_2,|SCO_60,NBS_2,STUN_1,HHP1_1,HGRP_0,|",
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
		["NAME"]="tiny_avalanche",
		["DELTA_T"]=2.9,
		["DIST"]={
			["RANGE"]=600,
			["RADIUS"]=400,
		},
		["DMG"]={
			["BASE"]=20,
			["LVL"]=70,
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
		["NAME"]="tiny_toss",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
	["E"]=
	{
		["NAME"]="tiny_tree_grab",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_TREE,
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
	
	-- if npcBot:GetLevel() == 19 then
		-- AbilityLevelUpThink=nil; --Revert to C++ Default API	
		-- return;
	-- end
		
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







