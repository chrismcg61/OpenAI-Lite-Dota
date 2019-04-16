------------------------------------------------------------
--- OpenAI_Ability_Custom
------------------------------------------------------------
OpenAI_Ability_Custom = {};

------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
OpenAI_Ability = require( GetScriptDirectory().."/MyLibs/OpenAI_Ability")

------------------------------------------------------------
--- VARS
------------------------------------------------------------
-- ctxParams = {};
-- ctxScores = {};


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function OpenAI_Ability_Custom.InitCtx_Params_Scores( )
	local ctxParams, ctxScores = OpenAI_Ability.InitCtx_Params_Scores( );
	
	-- ADD CONTEXT PARAMS :
	ctxParams["LVL1"] = {
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
	ctxScores["KILs"] = {
		["ID"]="KILs",
		["SCORE"]= 100.0,
		["FUNC"]= 
			function ()	
				return GetHeroKills(const["playerId"]);	
			end,
	};
	ctxScores["ASS"] = {
		["ID"]="ASS",
		["SCORE"]= 50.0,
		["FUNC"]= 
			function ()
				local ctxScore = GetHeroAssists(const["playerId"]);				
				return ctxScore;
			end,
	};
	ctxScores["STUNS"] = {
		["ID"]="STUNS",
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
		["ID"]="HeroDmg",
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


function OpenAI_Ability_Custom.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores)
	
	OpenAI_Ability.ConsiderAbilities(abilityList_OpenAI, contextIds, var, contexts, ctxParams, ctxScores);
	
end



return OpenAI_Ability_Custom;