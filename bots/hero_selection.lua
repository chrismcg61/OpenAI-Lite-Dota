---------------------------------------------------------------------
-- FILE : hero_selection.lua
---------------------------------------------------------------------  
  
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")  
  

---------------------------------------------------------------------
-- FUNCS :
--------------------------------------------------------------------- 
-- function Think()
 
    -- if ( GetTeam() == TEAM_RADIANT ) then
        -- print( "My Hero Selection : RADIANT" );
		
		-- -- SelectHero( 0, "npc_dota_hero_crystal_maiden" );  
		-- SelectHero( 1, "npc_dota_hero_phantom_assassin" );  
		
		-- SelectHero( 2, "npc_dota_hero_lina" );  
		
		-- SelectHero( 3, "npc_dota_hero_tidehunter" );  
		-- SelectHero( 4, "npc_dota_hero_skywrath_mage" );  		
		
    -- elseif ( GetTeam() == TEAM_DIRE ) then
        -- print( "My Hero Selection : DIRE" );
					
		-- SelectHero( 5, "npc_dota_hero_crystal_maiden" );  
		-- SelectHero( 6, "npc_dota_hero_luna" );  
		
		-- SelectHero( 7, "npc_dota_hero_bloodseeker" );  
		
		-- SelectHero( 8, "npc_dota_hero_axe" );  
		-- SelectHero( 9, "npc_dota_hero_oracle" );  
		
    -- end
 
-- end


--[[
function Think()
 
    if ( GetTeam() == TEAM_RADIANT ) then
        print( "My Hero Selection : RADIANT" );
		
		-- SelectHero( 0, "npc_dota_hero_crystal_maiden" );  
		SelectHero( 1, "npc_dota_hero_crystal_maiden" );  		
		SelectHero( 2, "npc_dota_hero_lina" );  
		
		SelectHero( 3, "npc_dota_hero_phantom_assassin" );  
		SelectHero( 4, "npc_dota_hero_axe" );  		
		
    elseif ( GetTeam() == TEAM_DIRE ) then
        print( "My Hero Selection : DIRE" );
					
		SelectHero( 5, "npc_dota_hero_earthshaker" );  
		SelectHero( 6, "npc_dota_hero_windrunner" );  
		
		SelectHero( 7, "npc_dota_hero_nevermore" );  
		
		SelectHero( 8, "npc_dota_hero_phantom_assassin" );  
		SelectHero( 9, "npc_dota_hero_skywrath_mage" );  
		
    end
 
end
 --]]
 
 
 --startTime = GameTime();
 function Think()
	-- PickStates :
	-- 58 = Turbo Ban Phase
	-- 1 = HEROPICK_STATE_AP_SELECT
	pickState = GetHeroPickState(); 
	--print( "State = ".. pickState ); 
	
	now = GameTime();
	--print( "T = ".. now ); 
 
	--if( DotaTime() > -65  )then   -- ||  GetSelectedHeroName(0) ~= ""		
	if(now > 18)or(GetSelectedHeroName(0)~="")or(GetSelectedHeroName(5)~="")then
 
		if ( GetTeam() == TEAM_RADIANT ) then
			--print( "My Hero Selection : RADIANT" );
			
			index = 0;
			playerTeam = GetTeamForPlayer(0);
			print("playerTeam = " .. playerTeam);
			if(playerTeam == 3)then  --DIRE
				index = index+1;
			end
			if(playerTeam == 5)then  --DIRE (Turbo)
				index = index+2;
			end
			
			--if(GetSelectedHeroName(0)=="")then 
				SelectHero( index, "npc_dota_hero_luna" );  
				--SelectHero( 5, "npc_dota_hero_luna" );  
			--end
			
			index = index+1;
			SelectHero( index, "npc_dota_hero_crystal_maiden" );  		
			
			index = index+1;
			--SelectHero( 2, "npc_dota_hero_bloodseeker" ); 
			SelectHero( index, "npc_dota_hero_lina" ); 
			
			index = index+1;
			--SelectHero( 3, "npc_dota_hero_bristleback" );  
			SelectHero( index, "npc_dota_hero_earthshaker" );  
			
			index = index+1;
			--SelectHero( 4, "npc_dota_hero_luna" );  				
			SelectHero( index, "npc_dota_hero_tiny" );  				
			--SelectHero( 4, "npc_dota_hero_oracle" );  
			 
		elseif ( GetTeam() == TEAM_DIRE ) then
			--print( "My Hero Selection : DIRE" );
						
			-- SelectHero( 5, "npc_dota_hero_oracle" );  			
			-- SelectHero( 7, "npc_dota_hero_bloodseeker" );  		
			-- SelectHero( 8, "npc_dota_hero_bristleback" );  
			-- SelectHero( 9, "npc_dota_hero_luna" );  
						
			
			--if(GetSelectedHeroName(5)=="")then 
				SelectHero( 0, "npc_dota_hero_luna" );  
				SelectHero( 1, "npc_dota_hero_luna" );  
				SelectHero( 5, "npc_dota_hero_luna" );  
			--end
			
			index = 6;
			playerTeam = GetTeamForPlayer(0);
			if(playerTeam == 5)then  --DIRE (Turbo)
				index = index+1;
			end
			SelectHero( index, "npc_dota_hero_crystal_maiden" );			
						
			index = index+1;
			SelectHero( index, "npc_dota_hero_lina" );	
			
			index = index+1;
			SelectHero( index, "npc_dota_hero_earthshaker" );
			index = index+1;
			SelectHero( index, "npc_dota_hero_tiny" ); 
			-- index = index+1;
			-- SelectHero( 10, "npc_dota_hero_tiny" ); 
			
		end
	end
 
end



function UpdateLaneAssignments()    
    if ( GetTeam() == TEAM_RADIANT )
    then		
        return {
        [1] = LANE_BOT,
        [2] = LANE_BOT,
        [3] = LANE_MID,
        [4] = LANE_TOP,
        [5] = LANE_TOP,
        };
    elseif ( GetTeam() == TEAM_DIRE )
    then
        return {
        [1] = LANE_TOP,
        [2] = LANE_TOP,
        [3] = LANE_MID,
        [4] = LANE_BOT,
        [5] = LANE_BOT,
        };
    end
end
