
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")
MyGenericAbility = require( GetScriptDirectory().."/MyLibs/MyGenericAbility")

OpenAI_Ability_Custom = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability_Custom")
OpenAI_Ability = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability")


------------------------------------------------------------
--- CONSTS
------------------------------------------------------------
abilityList_Basic = {	
	-- ["DS"]=
	-- {
		-- ["NAME"]="lina_dragon_slave",
		-- ["TARGET_TYPE"]= MyGenericAbility.TARGET_LOCATION,
	-- },
	-- ["LSA"]=
	-- {
		-- ["NAME"]="lina_light_strike_array",
		-- ["TARGET_TYPE"]= MyGenericAbility.TARGET_LOCATION,
	-- },
	["LB"]=
	{
		["NAME"]="lina_laguna_blade",
		["TARGET_TYPE"]= MyGenericAbility.TARGET_UNIT,
	},
};
-- abilityList_OpenAI = {};
abilityList_OpenAI = {
["LSA"]=
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
["DS"]=
	{
		["NAME"]="lina_dragon_slave",
		["DELTA_T"]=1.7,
		["DIST"]={
			["RANGE"]=900,
			["RADIUS"]=500,
		},
		["DMG"]={
			["BASE"]=10,
			["LVL"]=75,
		},
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
	
	-- for _,abilityId in pairs( abilityList_OpenAI ) do
		-- --local ability = npcBot:GetAbilityByName( abilityId["NAME"] );				
	-- end
	--OpenAI_Ability.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams);
	OpenAI_Ability_Custom.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores);
	
end











------------------------------------------------------------
--- OPEN AI :
------------------------------------------------------------

------------------------------------------------------------
--- CONSTs :
------------------------------------------------------------
contextIds = {
	{
		["ID"]="LSAH",
		["ABILITY_ID"] = "LSA",
		["FOCUS"] = "HEROES",
	},	
	{
		["ID"]="DSH",
		["ABILITY_ID"] = "DS",
		["FOCUS"] = "HEROES",
	},
	
	{
		["ID"]="DSC",
		["ABILITY_ID"] = "DS",
		["FOCUS"] = "CREEPS",
	},
	{
		["ID"]="LSAC",
		["ABILITY_ID"] = "LSA",
		["FOCUS"] = "CREEPS",
	},
};

------------------------------------------------------------
--- VARS
------------------------------------------------------------
var = {};
--ctxParams, ctxScores = OpenAI_Ability.InitVars( var, contextIds );
OpenAI_Ability.InitVars( var, contextIds );

--OpenAI_Ability_Custom.InitCtx_Params_Scores( );
ctxParams, ctxScores = OpenAI_Ability_Custom.InitCtx_Params_Scores( );


------------------------------------------------------------
--- CTX VARS
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
contexts["LSAC"] = OpenAI.InitTableFromStr(initCtxStr);

initCtxStr = "SCO_5.1,NBS_3,STUN_0,HHP1_0,HGRP_0,|";
contexts["LSAH"] = OpenAI.InitTableFromStr(initCtxStr);

