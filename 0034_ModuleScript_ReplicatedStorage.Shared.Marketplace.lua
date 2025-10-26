--[[
  Extracted from: ReplicatedStorage.Shared.Marketplace
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Marketplace, time of decompilation: Sat Jun 28 18:34:41 2025 ]]
local l_MarketplaceService_0 = game:GetService("MarketplaceService");
local v1 = {};
return {
    GetProductInfo = function(_, v3, v4) --[[ Line: 25 ]] --[[ Name: GetProductInfo ]]
        -- upvalues: v1 (copy), l_MarketplaceService_0 (copy)
        local v5 = v1[v3];
        if not v5 or os.time() - v5.LastUpdate >= 600 then
            local l_status_0, l_result_0 = pcall(function() --[[ Line: 31 ]]
                -- upvalues: l_MarketplaceService_0 (ref), v3 (copy), v4 (copy)
                return l_MarketplaceService_0:GetProductInfo(v3, v4 == "Gamepass" and Enum.InfoType.GamePass or Enum.InfoType.Product);
            end);
            v1[v3] = {
                PriceInRobux = l_status_0 and l_result_0.PriceInRobux or 999999999, 
                Title = l_status_0 and l_result_0.Name or "Failed to load", 
                Icon = l_status_0 and l_result_0.IconImageAssetId and ("rbxassetid://%*"):format(l_result_0.IconImageAssetId) or "Failed to load", 
                LastUpdate = os.time()
            };
        end;
        return v1[v3];
    end
};