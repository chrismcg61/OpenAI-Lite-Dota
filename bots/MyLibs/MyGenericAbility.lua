MyGenericAbility={};


------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
--MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")



------------------------------------------------------------
--- CONSTs :
------------------------------------------------------------
MyGenericAbility.TARGET_NONE = 0;
MyGenericAbility.TARGET_UNIT = 1;
MyGenericAbility.TARGET_LOCATION = 2;

-- const = {};



------------------------------------------------------------
--- FUNCS :
------------------------------------------------------------
function MyGenericAbility.Init( abilityList_Basic, abilityList_OpenAI, const )
	local npcBot = GetBot();	
	const["defaultRange"] = 1000;
	
	
	local infoStr = "";
	infoStr = "Abilities 'Basic'";
	--infoStr = infoStr .. " - " .. npcBot:GetUnitName();
	infoStr = infoStr .. " : ";
	for _,abilityId in pairs( abilityList_Basic ) do
		infoStr = infoStr .. abilityId["NAME"] .. " , ";
	end
	npcBot:ActionImmediate_Chat( infoStr, true);
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
	if ( not ability:IsFullyCastable() ) then  --or  ability:GetTargetType() == ABILITY_TARGET_TYPE_NONE) then 
		--return BOT_ACTION_DESIRE_NONE, 0;
		return false;
	end;
	
	
	
	-- Target :
	local npcTarget = npcBot:GetTarget();
	if ( npcTarget ~= nil  and   not npcTarget:IsBuilding()) then
		if ( CanCastAbilityOnTarget( npcTarget ) )then
			local ennemyHP = npcTarget:GetHealth();
			if(ennemyHP > 0  and  GetUnitToLocationDistance(npcBot, npcTarget:GetLocation()) < range) then   --and  ennemyHP < npcTarget:GetMaxHealth()*0.5
				
				npcBot:ActionImmediate_Chat( 
					"Ability : " .. ability:GetName()
					.. " - Mode = " .. mode
					.. " - Range = " .. range
					, true);
					
				if(mode == MyGenericAbility.TARGET_NONE)then 
					npcBot:Action_UseAbility( ability ); 
					return true; 
				end
				if(mode == MyGenericAbility.TARGET_UNIT)then 
					npcBot:Action_UseAbilityOnEntity( ability, npcTarget ); 
					return true; 
				end
				if(mode == MyGenericAbility.TARGET_LOCATION)then 
					npcBot:Action_UseAbilityOnLocation( ability, npcTarget:GetLocation() ); 
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




return MyGenericAbility;