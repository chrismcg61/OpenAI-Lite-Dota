------------------------------------------------------------
--- OpenAI_Ability
------------------------------------------------------------
OpenAI_Ability={};


------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
OpenAI = require( GetScriptDirectory().."/MyLibs/MyOpenAI/OpenAI" )


------------------------------------------------------------
--- CONSTS
------------------------------------------------------------
npcBot = GetBot();

const = {};
const["playerId"] = npcBot:GetPlayerID();
const["rangeMax"] = 1200;
const["creepAoe"] = 500;
const["minScore"] = 5.0;
const["maxMisses"] = 4;
const["lhScore"] = 20.0;
const["heroDmgScore"] = 25.0;
const["assistScore"] = 50.0;
const["killScore"] = 100.0;
const["lowHeroHp"] = 250;

abilityList = {};
contextIds = {};

------------------------------------------------------------
--- VARS
------------------------------------------------------------
var = {};


------------------------------------------------------------
--- CTX VARS
------------------------------------------------------------
foundCtx = {};
contexts = {};
--lastId = contextIds[1];

-- for i, id in ipairs(contextIds) do
	-- contexts[ id["ID"] ] = {};
-- end




------------------------------------------------------------
--- DEFAULT CTX VARS
------------------------------------------------------------
abLvl = 0;

ctxParams = {};
--[[
{
	{
		["ID"]="LVL1",
		["FUNC"]= 
			function (abilityDesc)
				local ctxValue = nil;

				if var["lastId"]["FOCUS"] == "CREEPS" then
					ctxValue = 0;
					if abLvl<2 then ctxValue = 1; end
				end
				
				return ctxValue;
			end,
	},
}
--]]

ctxScores = {};
--[[
{
	["LH"]=
	{
		["ID"]="LH",
		["SCORE"]= 20.0,
		["FUNC"]= 
			function ()
				local ctxScore = npcBot:GetLastHits();				
				return ctxScore;
			end,
	},
}
--]]

------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function OpenAI_Ability.Test()
	print("OpenAI_Ability.Test");
	local abilityLSA = npcBot:GetAbilityByName( "lina_light_strike_array" );
	local target = npcBot:GetLocation();	
	npcBot:Action_UseAbilityOnLocation( abilityLSA, target );
end


function OpenAI_Ability.InitCtx_Params_Scores( )
	return ctxParams, ctxScores;
end
function OpenAI_Ability.InitVars( var, contextIds )
	var["atkDmg"] = 0;
	var["bEvalWaiting"] = false;
	var["lastTimeAbility"] = RealTime();
	var["lastAbilityDeltaT"] = 0;
	var["prevScore"] = 0;
	var["lastAbilityDmg"] = 0;

	var["foundCtx"] = {};
	var["lastId"] = contextIds[1]; 
	
	
	-- Debug Chat :
	npcBot = GetBot();
	local introChat = npcBot:GetUnitName() .. " : OpenAI Mode!";
	print(introChat);
	--npcBot:ActionImmediate_Chat( introChat ,true);

end 

function OpenAI_Ability.ConsiderAbilities(_abilityList, _contextIds, _var, _contexts, _ctxParams, _ctxScores)
	npcBot = GetBot();
	const["playerId"] = npcBot:GetPlayerID();
	
	abilityList = _abilityList;
	contextIds = _contextIds;
	var = _var;
	contexts = _contexts;
	ctxParams = _ctxParams;
	ctxScores = _ctxScores;

	---------------------------------------
	--- Eval Last Ability: 
	---------------------------------------
	local now = RealTime();
	if now - var["lastTimeAbility"] < var["lastAbilityDeltaT"] then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	if var["bEvalWaiting"] then
		var["bEvalWaiting"] = false;
		EvalLastAbility();		
		PrintAllContexts();
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	
	if npcBot:IsChanneling()  or  npcBot:IsIllusion() then
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	---------------------------------------
	-- Try LB: 
	---------------------------------------
	--local LB_Used = ConsiderLB();
	--if LB_Used then return BOT_ACTION_DESIRE_NONE, 0; end

	
	---------------------------------------
	-- Try Ability: 
	---------------------------------------	
	var["atkDmg"] = npcBot:GetAttackDamage();
	
	local abilityUsed = false;	
	for i, id in ipairs(contextIds) do
		var["lastId"] = id;
		local abilityDesc = abilityList[ var["lastId"]["ABILITY_ID"] ];		
		abilityUsed = considerAbility( abilityDesc );
		if abilityUsed then  break;  end
	end
	
end


function considerAbility( abilityDesc )
	local ability = npcBot:GetAbilityByName( abilityDesc["NAME"] );	
	if ( not ability:IsFullyCastable() ) then 
		--return BOT_ACTION_DESIRE_NONE, 0;
		return false;
	end;	
		
	local newCtxData = GetContextDataAbility( abilityDesc );
	var["foundCtx"] = OpenAI.FindOrCreateContext(newCtxData, contexts[ var["lastId"]["ID"] ], const);
	
	if var["foundCtx"]["SCO"] >= const["minScore"] then
		TryAbility(abilityDesc, var["lastId"]["ID"]);
		return true;
	else
		return false;
	end
end






function GetContextData_Generic( abilityDesc )	
	local ability = npcBot:GetAbilityByName( abilityDesc["NAME"] );	
	abLvl = ability:GetLevel();
	var["lastAbilityDmg"] = abilityDesc["DMG"]["BASE"] + abilityDesc["DMG"]["LVL"] * abLvl;
end
function GetContextDataAbility( abilityDesc )	
	local newCtxData = {};
	
	target = npcBot:GetLocation();	
	
	GetContextData_Generic( abilityDesc );
	
	for _,ctxParam in pairs( ctxParams ) do
		local ctxVal = ctxParam["FUNC"](abilityDesc);
		if(ctxVal~=nil)then newCtxData[ ctxParam["ID"] ] = ctxVal; end
	end
	
	return newCtxData;
end

function myFindAoeLoc(bEnnemy, bHeroes, pos, radius, aoe, hp)
	local unitsLocationAoE = npcBot:FindAoELocation( bEnnemy, bHeroes, pos, radius, aoe, 0.2, hp );
	local count = unitsLocationAoE.count;
	if count > 2 then count = 2 end
	--ctxData[ctxParamName] = count;
	if count>0 then 
		target = unitsLocationAoE.targetloc;
	end 
	
	return count;
end


function TryAbility( abilityDesc, abId )	
	local ability = npcBot:GetAbilityByName( abilityDesc["NAME"] );	
	print("Trying "..abId);
	
	var["bEvalWaiting"] = true;
	var["lastTimeAbility"] = RealTime();
	var["lastAbilityDeltaT"] = abilityDesc["DELTA_T"];
	
	var["prevScore"] = GetScore();
	
	npcBot:Action_UseAbilityOnLocation( ability, target );
end


function EvalLastAbility()	
		
	local newScore = GetScore();
	local deltaScore = 0;
	for _,ctxScore in pairs( ctxScores ) do
		local scoreItem = (newScore[ ctxScore["ID"] ] - var["prevScore"][ ctxScore["ID"] ]);
		if(scoreItem<0)then scoreItem=0; end
		deltaScore = deltaScore  +  scoreItem * ctxScore["SCORE"];
	end	
	
	local decimalApprox = 10;
	var["foundCtx"]["SCO"] = (var["foundCtx"]["SCO"]*var["foundCtx"]["NBS"] + deltaScore) / (var["foundCtx"]["NBS"]+1);	
	var["foundCtx"]["SCO"] = math.floor( var["foundCtx"]["SCO"]*decimalApprox ) / decimalApprox;
	var["foundCtx"]["NBS"] = var["foundCtx"]["NBS"] + 1;	
	
	-- DEBUG CHAT :
	local logStr = "OpenAI Ability Score = ";
	--npcBot:ActionImmediate_Chat( logStr ,true);	
	
	logStr = "S: "..deltaScore .." | ";
	logStr = logStr .. "Avg:"..var["foundCtx"]["SCO"] .." | ";
	logStr = logStr .. "N:"..var["foundCtx"]["NBS"] .." | ";	
	--npcBot:ActionImmediate_Chat( logStr ,true);	
	
	logStr = logStr .. " |__| ";
	
	--logStr = "";
	for _,ctxScore in pairs( ctxScores ) do
		logStr = logStr .. ctxScore["ID"]..":".. newScore[ ctxScore["ID"] ] .. " | ";
	end	
	npcBot:ActionImmediate_Chat( logStr ,true);	
	
end



function GetScore()	
	local tempScore = {}; -- npcBot:GetLastHits() * const["lhScore"];	
	
	for _,ctxScore in pairs( ctxScores ) do
		local ctxVal = ctxScore["FUNC"]( );
		if(ctxVal~=nil)then tempScore[ ctxScore["ID"] ] = ctxVal; end
	end
	
	return tempScore;
end

function PrintAllContexts()	
	for i, id in ipairs(contextIds) do
		OpenAI.PrintCtx( contexts[ id["ID"] ], id["ID"] );
	end
end



return OpenAI_Ability;