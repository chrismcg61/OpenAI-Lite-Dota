------------------------------------------------------------
--- MyUtility
------------------------------------------------------------
MyUtility={}


------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
--Utility = require( GetScriptDirectory().."/MyLibs/Utility")


------------------------------------------------------------
--- VARS
------------------------------------------------------------
botStatus = {};
--MyUtility.InitStatus( botStatus )

alwaysCarryRegen = true;

botMode = 0;
botModeDesire = 0;
bNeedHp = false;
bDying = false;
bSafeToRegen = true;
bFighting = false;
allyNeedHP = nil;
allyNeedMana = nil;
allyChanneling = nil;
allyDying = nil;
Allies  = nil;
Enemies = nil;
lowEnnemy = nil;
trees = nil;
dominateCreepTarget = nil;



------------------------------------------------------------
--- CONSTs
------------------------------------------------------------
MyUtility.const = {};
MyUtility.const["maxCastRange"] = 1600;
MyUtility.const["safeDistHi"] = 1200;
MyUtility.const["safeDistLo"] = 800;
MyUtility.const["myFightDist"] = 400;
MyUtility.const["safeRegenTime"] = 3.0;


------------------------------
-- SOME OTHER LOCATIONS:
-- SHOPS:
------------------------------
MyUtility.shopLocations = {};
MyUtility.shopLocations["SIDE_SHOP_BOT"] = Vector(7249,-4113);
MyUtility.shopLocations["SIDE_SHOP_TOP"] = Vector(-7220,4430);
MyUtility.shopLocations["SECRET_SHOP_RADIANT"] = Vector(-4472,1328);
MyUtility.shopLocations["SECRET_SHOP_DIRE"] = Vector(4586,-1588);


------------------------------------------------------------
--- FUNCS
------------------------------------------------------------
function MyUtility.Test()
	print("MyUtility.Test");
end

function MyUtility.HasItem(item_name)
    local npcBot = GetBot();
    for i = 16, 0, -1 do
        local item = npcBot:GetItemInSlot(i);
		if(item~=nil and  item:GetName()==item_name)then 		--  and  item:IsFullyCastable()) then  --and  npcBot:GetItemSlotType(i)~=ITEM_SLOT_TYPE_STASH
			return item;
		end
    end
    return nil;
end
function MyUtility.IsItemAvailable(item_name)
    local npcBot = GetBot();

	local itemCount = 0;
    for i = 16, 0, -1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil and  item:GetName()==item_name) then 
			itemCount = itemCount + item:GetCurrentCharges();
		end
		
		if  i>5  and  item_name~="item_tpscroll"  then
			item=nil;
		end
		
		if (item~=nil) then
			if(item and  item:GetName()==item_name  and  item:IsFullyCastable()) then  --and  npcBot:GetItemSlotType(i)~=ITEM_SLOT_TYPE_STASH
				return item, itemCount;
			end
		end
    end
    return nil;
end
function MyUtility.GetCenter(Heroes)
	if Heroes==nil or #Heroes==0 then
		return nil;
	end
	
	local sum=Vector(0.0,0.0);
	local hn=0.0;
	
	for _,hero in pairs(Heroes) do
		if hero~=nil and hero:IsAlive() then
			sum=sum+hero:GetLocation();
			hn=hn+1;
		end
	end
	return sum/hn;
end


function MyUtility.Fountain(team)
	if team==TEAM_RADIANT then
		return Vector(-7093,-6542);
	end
	return Vector(7015,6534);
end
function MyUtility.DestLane(mode)
	local npcBot=GetBot();
	--if( npcBot:GetActiveModeDesire() < BOT_ACTION_DESIRE_HIGH  and  npcBot:WasRecentlyDamagedByAnyHero(5.0) )then return  LANE_NONE; end
	
	if     (mode==BOT_MODE_LANING ) then
		local destLane = npcBot:GetAssignedLane();		
		return destLane, GetLaneFrontLocation( GetTeam(), destLane, 0 );  -- GetLocationAlongLane(destLane,0.4);
	elseif (mode==BOT_MODE_DEFEND_TOWER_TOP  or  mode==BOT_MODE_DEFEND_PUSH_TOP) then
		local destLane = LANE_TOP;
		return destLane, GetLaneFrontLocation( GetTeam(), destLane, 0 );
	elseif (mode==BOT_MODE_DEFEND_TOWER_MID  or  mode==BOT_MODE_DEFEND_PUSH_MID) then
		local destLane = LANE_MID;
		return destLane, GetLaneFrontLocation( GetTeam(), destLane, 0 );
	elseif (mode==BOT_MODE_DEFEND_TOWER_BOT  or  mode==BOT_MODE_DEFEND_PUSH_BOT) then
		local destLane = LANE_BOT;
		return destLane, GetLaneFrontLocation( GetTeam(), destLane, 0 );
	elseif (mode==BOT_MODE_RETREAT) then
		local destLane = LANE_NONE;
		return destLane, MyUtility.Fountain(GetTeam());
	else
		return LANE_NONE, MyUtility.Fountain(GetTeam());  --GetAncient( GetTeam() ):GetLocation();
	end
end


function MyUtility.UseSingleItem(itemName, itemMod, target, minCharges, tree)
	local npcBot = GetBot();	
	local item, itemCount = MyUtility.IsItemAvailable(itemName);
	
	-- Usable Item?
	if item == nil  or  not item:IsFullyCastable()  or  item:GetCurrentCharges() < minCharges then 
		return false; 
	end
		
	-- Don't Stack!
	local selfOrTarget = target;
	if selfOrTarget==nil then 
		selfOrTarget = npcBot;
	end
	if selfOrTarget:GetModifierByName( itemMod ) ~= -1 then 
		return false; 
	end
	
	-- Self Items :
	if target==nil then 
		if tree==nil then 
			npcBot:Action_UseAbility( item ); 
		else
			npcBot:Action_UseAbilityOnTree( item,  tree);	
		end
		
		return true;
	end
	
	-- AoE Items:
	-- if cpos~=nil then
		-- npcBot:Action_UseAbilityOnLocation( item, cpos);
		-- return true;
	-- end
	
	------------------------------------------------------------
	-- Always Renew Clarities/Salves:	
	------------------------------------------------------------
	if  alwaysCarryRegen==true
	and DotaTime() < 60*15 
	and (itemName == "item_clarity" or itemName == "item_flask") 
	and itemCount <= 2
	then
		if ( npcBot:GetGold() >= GetItemCost( itemName ) )  then
			npcBot:ActionImmediate_PurchaseItem( itemName );  --PURCHASE_ITEM_SUCCESS
			return true;
		else
			return false;					
		end	
	end
	
	
	------------------------------------------------------------
	-- Targeted Items :
	------------------------------------------------------------
	npcBot:ActionImmediate_Chat( "ITEM : "..itemName , false);
	npcBot:Action_UseAbilityOnEntity( item,  target);	
	
	return true;	
end

function MyUtility.InitStatus( _botStatus )
	_botStatus["lastEnnemySight"] = RealTime();
	_botStatus["abilityMode"] = 0;
end

function MyUtility.UseItems( _botStatus )
	local npcBot=GetBot();
	if(_botStatus~=nil) then botStatus = _botStatus; end
	
	if npcBot:IsIllusion() then  return;  end
	
	MyUtility.AnalyseContext();

	-- DEBUG :
	-- bNeedHp = true;
	-- allyNeedMana = npcBot;
	-- allyNeedHP = npcBot;
	------------------------
	
	if MyUtility.UseSingleItem( "item_courier", "-", nil, 0) then return; end
	
	-- Channeling OK:
	local allyChannelingOrDying = allyChanneling;
	if allyChannelingOrDying==nil then allyChannelingOrDying = allyDying; end
	if allyChannelingOrDying~=nil and  not allyChannelingOrDying:IsInvulnerable()  and  not allyChannelingOrDying:IsInvisible()  then	
		if MyUtility.UseSingleItem( "item_glimmer_cape", "modifier_item_glimmer_cape_fade", allyChannelingOrDying, 0) then return; end
		if MyUtility.UseSingleItem( "item_shadow_amulet", "modifier_item_shadow_amulet_fade", allyChannelingOrDying, 0) then return; end
	end
	
	-- Other Items => Channeling Bad!
	if allyChanneling == npcBot then
		return;
	end
	
	
	-- REGEN :
	if allyNeedMana~=nil  then	
		if MyUtility.UseSingleItem( "item_arcane_boots", "-", nil, 0) then return; end
		if MyUtility.UseSingleItem( "item_enchanted_mango", "-", allyNeedMana, 0) then return; end
		
		if bSafeToRegen then
			if MyUtility.UseSingleItem( "item_clarity", "modifier_clarity_potion", allyNeedMana, 0) then  return; end	
			if MyUtility.UseSingleItem( "item_bottle", "modifier_bottle_regeneration", allyNeedMana, 1) then return; end	
		end
	end	

	
	if bNeedHp then		
			
		if MyUtility.UseSingleItem( "item_faerie_fire", "", nil, 0) then return; end	
	
		if MyUtility.UseSingleItem( "item_magic_wand", "", nil, 4) then return; end
		if MyUtility.UseSingleItem( "item_magic_stick", "", nil, 4) then return; end		
	end	

	
	if npcBot:GetMaxHealth() - npcBot:GetHealth() > 150  then		
		if (trees~=nil and #trees >= 1) then
			-- local item = MyUtility.IsItemAvailable("item_tango");
			-- npcBot:Action_UseAbilityOnTree( item,  trees[1]);	
			if MyUtility.UseSingleItem( "item_tango_single", "modifier_tango_heal", nil, 0, trees[1]) then return; end
			if MyUtility.UseSingleItem( "item_tango", "modifier_tango_heal", nil, 0, trees[1]) then return; end			
		end
	end
	
	
	--Shrine
	local shrines = npcBot:GetNearbyShrines( 1600, false);
	for _,Shrine in pairs(shrines) do
		local shrineCD = GetShrineCooldown(Shrine);
		local infoStr = "Shrine CD = " ..  shrineCD;
		--npcBot:ActionImmediate_Chat( infoStr,  false);
		--print( infoStr );
		if( allyNeedHP~=nil  and  shrineCD == 0 )then 
			npcBot:Action_UseShrine( Shrine ); 
			return; 
		end
		if( IsShrineHealing(Shrine) )then 
			npcBot:Action_MoveToLocation( Shrine:GetLocation() );	 
			return; 
		end
		--return;
	end
	
	
	if allyNeedHP~=nil and bSafeToRegen then
		if MyUtility.UseSingleItem( "item_flask", "modifier_flask_healing", allyNeedHP, 0) then  return;  end
		if MyUtility.UseSingleItem( "item_bottle", "modifier_bottle_regeneration", allyNeedHP, 1) then return; end	
		if MyUtility.UseSingleItem( "item_urn_of_shadows", "modifier_item_urn_heal", allyNeedHP, 1) then return; end	
	end	
	
	
	-- ATTACK :
	if MyUtility.UseSingleItem( "item_phase_boots", "modifier_item_phase_boots", nil, 0) then return; end	
	
	if dominateCreepTarget~=nil then
		if MyUtility.UseSingleItem( "item_helm_of_the_dominator", "", dominateCreepTarget, 0) then return; end	
	end
	
	if(bFighting)then
		if MyUtility.UseSingleItem( "item_black_king_bar", "modifier_item_black_king_bar", nil, 0) then return; end
		if MyUtility.UseSingleItem( "item_mask_of_madness", "modifier_item_mask_of_madness", nil, 0) then return; end
	end
	
	if(Allies~=nil and #Allies >= 3 and not bSafeToRegen)then
		if MyUtility.UseSingleItem( "item_ancient_janggo", "modifier_item_ancient_janggo_active", nil, 1) then return; end			
		if MyUtility.UseSingleItem( "item_buckler", "modifier_item_buckler_effect", nil, 0) then return; end	
	end
	
	if lowEnnemy~=nil then
		if MyUtility.UseSingleItem( "item_urn_of_shadows", "modifier_item_urn_damage", lowEnnemy, 1) then return; end
		if  not lowEnnemy:IsStunned()  and  not lowEnnemy:IsRooted()  and  not lowEnnemy:IsMuted() then 
			if MyUtility.UseSingleItem( "item_rod_of_atos", "modifier_rod_of_atos_debuff", lowEnnemy, 0) then return; end			
			if MyUtility.UseSingleItem( "item_sheepstick", "modifier_sheepstick_debuff", lowEnnemy, 0) then return; end
		end
	end
	
	
	-- DEFENSE :
	if bDying then 
		if MyUtility.UseSingleItem( "item_cyclone", "-", npcBot, 0) then return; end
	end
	
	if allyDying~=nil then	
		if MyUtility.UseSingleItem( "item_force_staff", "-", allyDying, 0) then return; end
	end
	
	
	--------------------------------
	--------------------------------
	-- AoE Veil:
	if Enemies~=nil and #Enemies>=1 then
		local cpos = MyUtility.GetCenter(Enemies);
		local veil = MyUtility.IsItemAvailable("item_veil_of_discord");
		npcBot:Action_UseAbilityOnLocation(veil,cpos);			
		--if MyUtility.UseSingleItem( "item_veil_of_discord", "modifier_item_veil_of_discord_debuff", nil, 0, cpos) then return; end
	end
	
	
	
	-------------------------------------
	-- TP:
	if bSafeToRegen then
		local tp = MyUtility.IsItemAvailable("item_tpscroll");
		if tp ~= nil  and tp:IsFullyCastable() and  not npcBot:IsUsingAbility() then
			--npcBot:ActionImmediate_Chat( "TP found" , true);
		
			if (botMode == BOT_MODE_LANING and  not bNeedHp)
			 or (botModeDesire > 0.85)
			then	
				local destLane, dest = MyUtility.DestLane( botMode );	
				if destLane ~= LANE_NONE and GetUnitToLocationDistance(npcBot, dest) > 6000 then
					local infoStr = "TPing__"..botMode.."__"..botModeDesire;
					--npcBot:ActionImmediate_Chat( infoStr , false);
					--tp = MyUtility.IsItemAvailable("item_tpscroll");
					--if tp ~= nil  and tp:IsFullyCastable() and  not npcBot:IsUsingAbility() then
						local buyRes = npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );-- PURCHASE_ITEM_SUCCESS
						if buyRes == PURCHASE_ITEM_SUCCESS then
							npcBot:Action_UseAbilityOnLocation(tp, dest);
							return;
						end
					--end
					
					-- if npcBot:GetGold() > 50 and not npcBot:IsChanneling() then
						-- if MyUtility.UseSingleItem( "item_tpscroll", "-", nil, 0, dest) then 
							-- local buyRes = npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );-- PURCHASE_ITEM_SUCCESS
							-- return; 
						-- end
					-- end
				end	
			end
		end
	end
				
			
	
end


function MyUtility.AnalyseContext()
	local npcBot=GetBot();
	local now = RealTime();
	
	trees = npcBot:GetNearbyTrees( MyUtility.const["maxCastRange"] );
	
	dominateCreepTarget = nil;
	local creeps = npcBot:GetNearbyCreeps( MyUtility.const["maxCastRange"], true);
	for _,creep in pairs(creeps) do
		if string.find(creep:GetUnitName(),"siege")~=nil then
			dominateCreepTarget = creep;
			break;
		end
	end
	
	--Ennemies:
	bSafeToRegen = true;
	bFighting = false;
	lowEnnemy = nil;
	local regenEnnemy = nil;
	local EnemiesFar = npcBot:GetNearbyHeroes( MyUtility.const["maxCastRange"], true,BOT_MODE_NONE);		
	local EnemiesClose = npcBot:GetNearbyHeroes( MyUtility.const["myFightDist"], true,BOT_MODE_NONE);		
	if EnemiesClose~=nil and #EnemiesClose>=1 then
		bFighting = true;
	end
	
	if  (now - botStatus["lastEnnemySight"]) < MyUtility.const["safeRegenTime"]  then
		bSafeToRegen = false;
	end
	
	Enemies = npcBot:GetNearbyHeroes( MyUtility.const["safeDistLo"], true,BOT_MODE_NONE);		--mySafeDistHi
	if Enemies~=nil and #Enemies>=1 then
		bSafeToRegen = false;
		botStatus["lastEnnemySight"] = now;
	end
	
	if EnemiesFar~=nil and #EnemiesFar>=1 then
		for _,Ennemy in pairs(EnemiesFar) do
			if Ennemy:GetHealth() / Ennemy:GetMaxHealth() < 0.5 then
				lowEnnemy = Ennemy;
			end
			
			if Ennemy:GetModifierByName("modifier_flask_healing") ~= -1 
			or Ennemy:GetModifierByName("modifier_clarity_potion") ~= -1
			or Ennemy:GetModifierByName("modifier_bottle_regeneration") ~= -1		
			or Ennemy:GetModifierByName("modifier_item_urn_heal") ~= -1					
			then
				regenEnnemy = Ennemy;
			end
		end
	end

	-- Allies:
	botMode = npcBot:GetActiveMode();
	botModeDesire = npcBot:GetActiveModeDesire();
	
	local nMods = npcBot:NumModifiers();
	for i=0,nMods-1,1 do
		--npcBot:ActionImmediate_Chat( "Mod : "..npcBot:GetModifierName(i) , false);
		--npcBot:ActionImmediate_Chat( "Clarity? : "..npcBot:GetModifierByName("modifier_clarity_potion") , false);
	end
	
	local AlliesFar = npcBot:GetNearbyHeroes( MyUtility.const["maxCastRange"], false,BOT_MODE_NONE);
	Allies = npcBot:GetNearbyHeroes( MyUtility.const["safeDistLo"], false,BOT_MODE_NONE);
	
	bNeedHp = false;
	bDying = false;
	allyNeedHP = nil;
	allyNeedMana = nil;
	allyChanneling = nil;
	allyDying = nil;
	
	-- if npcBot:GetMaxHealth() - npcBot:GetHealth() > 300 and npcBot:GetHealthRegen() < 30 then
		-- allyNeedHP = npcBot;
		-- bNeedHp = true;
	-- else 		
	-- end
	for _,Ally in pairs(Allies) do
		if not Ally:IsIllusion()  and  Ally:GetMaxHealth() - Ally:GetHealth() > 350 and Ally:GetHealthRegen() < 30 then
			allyNeedHP = Ally;
			if allyNeedHP == npcBot then bNeedHp = true; end
		end
	end
	-- if npcBot:GetMaxMana() - npcBot:GetMana() > 200 and npcBot:GetManaRegen() < 30 then
		-- allyNeedMana = npcBot;
	-- else 		
	-- end
	for _,Ally in pairs(Allies) do
		if  not Ally:IsIllusion()  and  Ally:GetManaRegen() < 30  and (Ally:GetMana()<100  or  Ally:GetMaxMana() - Ally:GetMana() > 200)  then
			allyNeedMana = Ally;
		end
	end
	
	-- if npcBot:IsChanneling() then
		-- allyChanneling = npcBot;
	-- else 		
	-- end
	for _,Ally in pairs(AlliesFar) do
		if Ally:IsChanneling() then
			allyChanneling = Ally;
			if allyChanneling == npcBot then return; end
		end
	end	
	
	-- if npcBot:GetHealth() < 300 then
		-- allyDying = npcBot;
		-- bDying = true;
	-- else 		
	-- end
	for _,Ally in pairs(AlliesFar) do
		if Ally:GetHealth()/Ally:GetMaxHealth() < 0.4
		--or Ally:GetHealth() < 800 
		--or (Ally:GetActiveMode() == BOT_MODE_RETREAT  and  Ally:GetActiveModeDesire() > 0.85)
		then
			allyDying = Ally;
			if allyDying == npcBot then 
				bDying = true; 
				return;
			end
		end
	end		
end

itemsToSell = {
	"item_enchanted_mango",
	"item_flask",
	"item_clarity",
	"item_tango",
	
	"item_stout_shield",
	"item_quelling_blade",
};
function MyUtility.MyPurchaseThink( tableItemsToBuy )

	local npcBot = GetBot();
	local courier = GetCourier(0);

	-- TEST :
	-- npcBot:ActionImmediate_PurchaseItem( "item_clarity");

	if ( #tableItemsToBuy == 0 )  or  ( npcBot:IsIllusion() )
	then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	-- Check COURIER:
	local itemCour = "item_courier";
	if( GetItemStockCount(itemCour)>0 )then 
		npcBot:ActionImmediate_PurchaseItem( itemCour );
		local infoStr = "Buying Cour!";
		--npcBot:ActionImmediate_Chat( infoStr, true);
		print(infoStr);
	end
	
	
	local sNextItem = tableItemsToBuy[1];
	
	if (sNextItem == "DELIVER_NOW") then
		if( IsCourierAvailable() )then
			npcBot:ActionImmediate_Courier( courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS );
			table.remove( tableItemsToBuy, 1 );	
		end
		
		return;		
	end

	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	
	
	-- SELL JUNK MIDGAME :
	if npcBot:DistanceFromFountain() == 0  
	and( DotaTime() > 60*20  or  npcBot:GetNetWorth() > 6000 )then
		for _,itemName in ipairs(itemsToSell) do 
			local item = MyUtility.HasItem( itemName );
			if item~=nil then 
				npcBot:ActionImmediate_SellItem( item ); 
				local str = "Selling Junk = " .. itemName  ..  " - NetWorth = " .. npcBot:GetNetWorth();
				npcBot:ActionImmediate_Chat( str, true);
				print(str);
			end
		end
	end
	
	
-- MyUtility.shopLocations["SIDE_SHOP_BOT"] = Vector(7249,-4113);
-- MyUtility.shopLocations["SIDE_SHOP_TOP"] = Vector(7249,-4113);
-- MyUtility.shopLocations["SECRET_SHOP_RADIANT"] = Vector(-4472,1328);
-- MyUtility.shopLocations["SECRET_SHOP_DIRE"] = Vector(4586,-1588);


	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) )
	then
		
		-- if IsItemPurchasedFromSecretShop( sNextItem )
		-- and IsItemPurchasedFromSideShop( sNextItem )
		-- then
			-- --Find Closest Secret/Side Shop:
			-- local shopLocation = MyUtility.shopLocations["SIDE_SHOP_BOT"];
			-- local minDist = GetUnitToLocationDistance(npcBot, shopLocation);
			
			-- for _,shopLoc in pairs(MyUtility.shopLocations) do
				-- local newDist = GetUnitToLocationDistance(npcBot, shopLoc);
				-- if  newDist < minDist then
					-- shopLocation = shopLoc;
					-- minDist = newDist;
				-- end
			-- end
			
			-- npcBot:Action_MoveToLocation( shopLocation );	
			-- npcBot:ActionImmediate_Chat( "SHOP : SIDE", false);
			
		-- else		
	
			if IsItemPurchasedFromSecretShop( sNextItem )
			--and not ( IsItemPurchasedFromSideShop( sNextItem )  and  npcBot:DistanceFromSideShop() < npcBot:DistanceFromSecretShop() )
			and  npcBot:DistanceFromSecretShop() > 0 
			then
				local shopLocation = MyUtility.shopLocations["SECRET_SHOP_RADIANT"];
				if GetUnitToLocationDistance(npcBot, MyUtility.shopLocations["SECRET_SHOP_RADIANT"]) > GetUnitToLocationDistance(npcBot, MyUtility.shopLocations["SECRET_SHOP_DIRE"]) then
					shopLocation = MyUtility.shopLocations["SECRET_SHOP_DIRE"];
				end
				
				-- if npcBot:GetHealth() > 0.25*npcBot:GetMaxHealth() then
					npcBot:Action_MoveToLocation( shopLocation );		
				-- end
				local infoStr = "SHOP : SECRET";
				-- npcBot:ActionImmediate_Chat( infoStr, false);
				-- print(infoStr);				
				return;
			end
			
			
			if IsItemPurchasedFromSideShop( sNextItem )
			and not IsItemPurchasedFromSecretShop( sNextItem )
			and npcBot:DistanceFromSideShop() > 0 
			and npcBot:DistanceFromSideShop() < 2800 * 1.5  -- ~Nb Screen Dist  		--npcBot:DistanceFromFountain()		-- 
			and npcBot:GetHealth() > 0.25*npcBot:GetMaxHealth()
			--and not ( IsItemPurchasedFromSecretShop( sNextItem )  and  npcBot:DistanceFromSecretShop() < npcBot:DistanceFromSideShop() )
			then
				local shopLocation = MyUtility.shopLocations["SIDE_SHOP_BOT"];
				if GetUnitToLocationDistance(npcBot, MyUtility.shopLocations["SIDE_SHOP_BOT"]) > GetUnitToLocationDistance(npcBot, MyUtility.shopLocations["SIDE_SHOP_TOP"]) then
					shopLocation = MyUtility.shopLocations["SIDE_SHOP_TOP"];
				end			
				npcBot:Action_MoveToLocation( shopLocation );	
				local infoStr = "SHOP : SIDE";
				-- npcBot:ActionImmediate_Chat( infoStr, false);
				-- print(infoStr);
				-- local sideShopPos = GetShopLocation( TEAM_RADIANT, SHOP_SIDE);
				-- local courier = npcBot:GetCourier(0);
				-- npcBot:ActionImmediate_Courier( courier , COURIER_ACTION_SECRET_SHOP );			
				return;
			end
			
		
			
			
		-- end
	
		
		

		
		local result = npcBot:ActionImmediate_PurchaseItem( sNextItem );
		if(result~=PURCHASE_ITEM_SUCCESS)then 			
			local str = "ITEM PURCHASE : ERROR : " .. sNextItem;
			npcBot:ActionImmediate_Chat( str, false);	
			print(str);
			
			--tableItemsToBuy = {};
			for _,itemName in ipairs(tableItemsToBuy) do 
				table.remove( tableItemsToBuy, 1 );	
			end
			-- if( IsCourierAvailable()  and  courier:DistanceFromFountain() < 2000 )then  -- npcBot:IsAlive()
				-- npcBot:ActionImmediate_Courier( courier, COURIER_ACTION_SECRET_SHOP );  -- COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS
			-- end
			-- result = courier:ActionImmediate_PurchaseItem( sNextItem );
		end
		
		if( result == PURCHASE_ITEM_SUCCESS) then
			table.remove( tableItemsToBuy, 1 );			
		end

	end



end


function MyUtility.ConcatLists( list1, list2)
	local list1_L = table.getn( list1 );
	for _,item in ipairs(list2) do list1_L=list1_L+1; list1[list1_L] = item; end
end

return MyUtility;