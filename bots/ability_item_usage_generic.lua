
------------------------------------------------------------
--- INCLUDES
------------------------------------------------------------
MyUtility = require( GetScriptDirectory().."/MyLibs/MyUtility")


---------------------------------------------------------
-- lastTime = RealTime();


------------------------------------------------------------
--- FUNCS :
------------------------------------------------------------

-- function BuybackUsageThink()
-- end

-- function ItemUsageThink()
	-- MyUtility.UseItems(botStatus);
-- end


function CourierUsageThink()
	local npcBot = GetBot();
	local courier = GetCourier(0);
	if( IsCourierAvailable()  and  npcBot:IsAlive()  and  npcBot:GetStashValue()>=300 )then
		npcBot:ActionImmediate_Courier( courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS );  --  COURIER_ACTION_SECRET_SHOP
	end
end




