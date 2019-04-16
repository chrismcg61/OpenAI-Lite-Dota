OpenAI = {};

function OpenAI.Test()
	print("OpenAI.Test");
end

function OpenAI.FindOrCreateContext(newCtxData, ctxList, const)	
	local foundCtx = nil;
	
	for i, ctx in ipairs(ctxList) do
		if IsSameContext(ctx["data"], newCtxData ) then
			foundCtx = ctx;
		end
	end	
	
	if foundCtx==nil then
		foundCtx = CreateNewContext(newCtxData, const);
		local ctxListLength = table.getn( ctxList );
		ctxList[ctxListLength+1] = foundCtx;
	end
	
	return foundCtx;
end
function IsSameContext(contextData, curContextData)
	local bSameCtx = true;
	
	for j,_ in pairs(contextData) do
		if contextData[j] ~= curContextData[j] then
			bSameCtx = false;
			break;
		end
	end
	
	return bSameCtx;
end
function CreateNewContext(newCtxData, const)
	local newContext = {};
	newContext["data"] = newCtxData;
	newContext["SCO"] = const["maxMisses"] * const["minScore"];
	newContext["NBS"] = 1;
	return newContext;
end



function OpenAI.PrintCtx(ctxList, abilityName)	
	print("===== PrintCtx | "..abilityName.." =====");
	local ctxStr = "";
	
	for i, ctx in ipairs(ctxList) do		
		ctxStr = ctxStr.."SCO".."_"..ctx["SCO"]..",";
		ctxStr = ctxStr.."NBS".."_"..ctx["NBS"]..",";
		for j,_ in pairs(ctx["data"]) do
			ctxStr = ctxStr..j.."_"..ctx["data"][j]..",";
		end
		ctxStr = ctxStr.."|";
	end
	
	print(ctxStr);	
end
function OpenAI.InitTableFromStr(ctxStr)	
	local tableFromStr = {};
	for ctx in string.gmatch(ctxStr, "([^|]+)") do 
		local ctxFromStr = {};
		ctxFromStr["data"] = {};
		
		for ctxDataPairs in string.gmatch(ctx, "([^,]+)") do 
			local keyDataPair = {};
			for keyOrData in string.gmatch(ctxDataPairs, "([^_]+)") do 
				print(keyOrData);
				local keyDataPairLength = table.getn( keyDataPair );
				keyDataPair[keyDataPairLength+1] = keyOrData;
			end		
			
			if keyDataPair[1] == "SCO" then
				ctxFromStr["SCO"] = tonumber( keyDataPair[2] );
			elseif keyDataPair[1] == "NBS" then
				ctxFromStr["NBS"] = tonumber( keyDataPair[2] );
			else
				ctxFromStr["data"][ keyDataPair[1] ] = tonumber( keyDataPair[2] );
			end
		end
		
		local tableLength = table.getn( tableFromStr );
		tableFromStr[tableLength+1] = ctxFromStr;
	end
	
	return tableFromStr;
end



return OpenAI;