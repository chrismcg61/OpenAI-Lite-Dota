MyGenericAbility={};


------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")



------------------------------------------------------------
--- CONSTs :
------------------------------------------------------------
MyGenericAbility.TARGET_NONE = 0;
MyGenericAbility.TARGET_LOCATION = 1;
MyGenericAbility.TARGET_UNIT = 2;
MyGenericAbility.TARGET_UNIT_BUILDING = 3;
MyGenericAbility.TARGET_TREE = 4;

-- const = {};



------------------------------------------------------------
--- FUNCS :
------------------------------------------------------------
function MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const )
	local npcBot = GetBot();	
	const["defaultRange"] = 700;
	
	
	local infoStr = "";
	infoStr = "Abilities 'Basic'";
	--infoStr = infoStr .. " - " .. npcBot:GetUnitName();
	infoStr = infoStr .. " : ";
	for _,abilityId in pairs( abilityList_Basic ) do
		infoStr = infoStr .. abilityId["NAME"] .. " , ";
	end
	--npcBot:ActionImmediate_Chat( infoStr, true);
	print(infoStr);
	
	infoStr = "Abilities 'OpenAI'";
	--infoStr = infoStr .. " - " .. npcBot:GetUnitName();
	infoStr = infoStr .. " : ";
	for _,abilityId in pairs( abilityList_OpenAI ) do
		infoStr = infoStr .. abilityId["NAME"] .. " , ";
	end
	npcBot:ActionImmediate_Chat( infoStr, true);
	print(infoStr);
	
	
	
	print("GetAbilityInSlot:");
	local ability = npcBot:GetAbilityInSlot( 0 );	
	print(ability:GetName());
	ability = npcBot:GetAbilityInSlot( 1 );	
	print(ability:GetName());
	ability = npcBot:GetAbilityInSlot( 2 );	
	print(ability:GetName());
	ability = npcBot:GetAbilityInSlot( 3 );	
	print(ability:GetName());
	
	
end


function MyGenericAbility.ConsiderAbility_Mode( ability, mode, const )
	local npcBot = GetBot();	
	
	--if(range==nil)then  
	local range = const["defaultRange"];  
	--end
	
	-- Make sure it's castable
	if ( not ability:IsFullyCastable()  or  ability:IsHidden()  or  npcBot:IsIllusion()  or  npcBot:IsChanneling()) then  --or  ability:GetTargetType() == ABILITY_TARGET_TYPE_NONE) then 
		--return BOT_ACTION_DESIRE_NONE, 0;
		return false;
	end;
	
	
	
	-- Target :
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil  and   not (npcTarget:IsBuilding() and mode ~= MyGenericAbility.TARGET_UNIT_BUILDING) ) then
		if ( CanCastAbilityOnTarget( npcTarget ) )then
			local ennemyHP = npcTarget:GetHealth();
			if(ennemyHP > 0  and  GetUnitToLocationDistance(npcBot, npcTarget:GetLocation()) < range) then   --and  ennemyHP < npcTarget:GetMaxHealth()*0.5
				
				-- npcBot:ActionImmediate_Chat( 
					-- "Ability : " .. ability:GetName()
					-- .. " - Mode = " .. mode
					-- .. " - Range = " .. range
					-- , true);
					
				if(mode == MyGenericAbility.TARGET_NONE)then 
					npcBot:Action_UseAbility( ability ); 
					return true; 
				end
				if(mode == MyGenericAbility.TARGET_UNIT  or  mode == MyGenericAbility.TARGET_UNIT_BUILDING)then   
					npcBot:Action_UseAbilityOnEntity( ability, npcTarget ); 
					return true; 
				end
				if(mode == MyGenericAbility.TARGET_LOCATION)then 
					npcBot:Action_UseAbilityOnLocation( ability, npcTarget:GetLocation() ); 
					return true; 
				end
				if(mode == MyGenericAbility.TARGET_TREE)then   -- or  mode == MyGenericAbility.TARGET_UNIT_BUILDING
					local trees = npcBot:GetNearbyTrees( 600 );
					local closestTree = trees[1];
					if closestTree~=nil then 
						npcBot:Action_UseAbilityOnTree( ability, closestTree ); 
					end
					return true; 
				end
				--return BOT_ACTION_DESIRE_HIGH, npcTarget;
				
			end				
		end
	end
		
	
	--return BOT_ACTION_DESIRE_NONE, 0;
	return false;
end



function CanCastAbilityOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end



function MyGenericAbility.TalentLvl(_npcBot, _bTalents, _talents)		
	heroLvl = _npcBot:GetLevel();
	if (heroLvl == 10)or(heroLvl == 15)or(heroLvl == 20)or(heroLvl == 25) then	
		talentId = (heroLvl-10)/5 +1;
		if _bTalents[talentId]==0 then
			_bTalents[talentId]=1;			
			for _,talent in pairs( _talents ) do					
				bOk, retVal = pcall(TalentLvl_Try, talent, _npcBot);
				if bOk then
					if retVal then
						--return;
					end
				else
					print("Talent Error : " .. retVal);
				end
			end	
			
		end
	end		
end
function TalentLvl_Try( talent, _npcBot )	
	bActive = _npcBot:GetAbilityByName( talent ):GetLevel();	
	--bUpgradable = _npcBot:GetAbilityByName( talent ):CanAbilityBeUpgraded();	
	--nMaxLvl = _npcBot:GetAbilityByName( talent ):GetMaxLevel();
	--talentReqLvl = _npcBot:GetAbilityByName( talent ):GetHeroLevelRequiredToUpgrade();			
	if(bActive==0)then	  --(heroLvl >= talentReqLvl)   -- (bUpgradable)and
		print("Talent Active = " .. bActive);			
		nilRetVal = _npcBot:ActionImmediate_LevelAbility( talent ); 
		--return true;
	else
		--return false;
	end	
end




return MyGenericAbility;