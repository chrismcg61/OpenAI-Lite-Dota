
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")
MyGenericAbility = require( GetScriptDirectory().."/MyLibs/MyGenericAbility")

OpenAI_Ability_Custom = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability_Custom")
OpenAI_Ability = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability")


------------------------------------------------------------
--- Hero CONSTS
------------------------------------------------------------
abilityList_Basic = {
	["FB"]=
	{
		["NAME"]="crystal_maiden_frostbite",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
	-- ["CN"]=
	-- {
		-- ["NAME"]="crystal_maiden_crystal_nova",
		-- ["TARGET_TYPE"]= MyGenericAbility.TARGET_LOCATION,
	-- },
	["FF"]=
	{
		["NAME"]="crystal_maiden_freezing_field",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_NONE,
	},
};
abilityList_OpenAI = {
	["CN"]=
	{
		["NAME"]="crystal_maiden_crystal_nova",
		["DELTA_T"]=1.5,
		["DIST"]={
			["RANGE"]=500,
			["RADIUS"]=500,
		},
		["DMG"]={
			["BASE"]=90,
			["LVL"]=40,
		},
	},
};



------------------------------------------------------------
--- Hero CONSTs - OpenAI Ctx :
------------------------------------------------------------
contextIds = {
	{
		["ID"]="CNC",
		["ABILITY_ID"] = "CN",
		["FOCUS"] = "CREEPS",
	},	
	{
		["ID"]="CNH",
		["ABILITY_ID"] = "CN",
		["FOCUS"] = "HEROES",
	},	
};



------------------------------------------------------------
--- INIT
------------------------------------------------------------
npcBot = GetBot();
lastTime = RealTime();

--modeName = "Basic";
const = {};
MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const );

botStatus = {};
MyUtility.InitStatus( botStatus );


------------------------------------------------------------
--- FUNCS :
------------------------------------------------------------
function ItemUsageThink()
	MyUtility.UseItems(botStatus);
end


function AbilityUsageThink()	
	
	for _,abilityId in pairs( abilityList_Basic ) do
		local ability = npcBot:GetAbilityByName( abilityId["NAME"] );		
		local used_ability = MyGenericAbility.ConsiderAbility_Mode( ability, abilityId["TARGET_TYPE"], const );  		--, 1000
		if used_ability then return BOT_ACTION_DESIRE_NONE, 0; end
	end
	
	OpenAI_Ability_Custom.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores);
	
end


function AbilityLevelUpThink()
	if npcBot:GetAbilityPoints()==0 then return; end	
	
	if npcBot:GetLevel()==1 then 
		npcBot:ActionImmediate_LevelAbility( "crystal_maiden_crystal_nova" ); 
		return; 
	end
	if npcBot:GetLevel()==2 then
		npcBot:ActionImmediate_LevelAbility( "crystal_maiden_frostbite" ); 
		return; 
	end
	if npcBot:GetLevel()==3 then
		npcBot:ActionImmediate_LevelAbility( "crystal_maiden_brilliance_aura" ); 
		return; 
	end

	
	--local abilities = { "special_bonus_unique_crystal_maiden_1", "special_bonus_gold_income_15", "special_bonus_cast_range_100", "special_bonus_hp_250", "crystal_maiden_freezing_field", "crystal_maiden_crystal_nova", "crystal_maiden_brilliance_aura" , "crystal_maiden_frostbite"};
	local abilities = { "special_bonus_hp_250", "crystal_maiden_brilliance_aura", "crystal_maiden_crystal_nova", "crystal_maiden_freezing_field", "crystal_maiden_frostbite"};
	local listLength = table.getn( abilities );	
	
	for i=1,listLength,1 do
		if npcBot:GetAbilityByName( abilities[i] ):CanAbilityBeUpgraded() then
			npcBot:ActionImmediate_LevelAbility( abilities[i] );
			return;
		end
	end
	
end























------------------------------------------------------------
------------------------------------------------------------
--- OPEN AI - Inits:
------------------------------------------------------------
------------------------------------------------------------


------------------------------------------------------------
--- GENERIC VARS
------------------------------------------------------------
var = {};
--ctxParams, ctxScores = OpenAI_Ability.InitVars( var, contextIds );
OpenAI_Ability.InitVars( var, contextIds );

--OpenAI_Ability_Custom.InitCtx_Params_Scores( );
ctxParams, ctxScores = OpenAI_Ability_Custom.InitCtx_Params_Scores( );


------------------------------------------------------------
--- GENERIC CTX VARS
------------------------------------------------------------
--foundCtx = {};
contexts = {};
--lastId = contextIds[1];

for i, id in ipairs(contextIds) do
	contexts[ id["ID"] ] = {};
end




------------------------------------------------------------
--- CONFIG LOAD from TEST Results :
------------------------------------------------------------
initCtxStr = "SCO_5.1,NBS_3,LVL1_1,CHP1_0,|";
contexts["CNC"] = OpenAI.InitTableFromStr(initCtxStr);

initCtxStr = "SCO_5.1,NBS_3,STUN_0,HHP1_0,HGRP_0,|";
contexts["CNH"] = OpenAI.InitTableFromStr(initCtxStr);

