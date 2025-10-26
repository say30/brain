--[[
  Extracted from: ReplicatedStorage.Controllers.EncryptedAssetsController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
game:GetService("Players")
local u3 = require(v1.Packages.Net)
local u4 = {}
return {
    ["WaitForAssetId"] = function(_, p5) --[[Function name: WaitForAssetId, line 12]]
        --[[
        Upvalues:
            [1] = u4
        --]]
        while not u4[p5] do
            task.wait()
        end
    end,
    ["Start"] = function(_) --[[Function name: Start, line 18]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u2
            [3] = u4
        --]]
        for u6, u7 in u3:Invoke("EncryptedAssetsService/Load") do
            task.spawn(function() --[[Anonymous function at line 20]]
                --[[
                Upvalues:
                    [1] = u2
                    [2] = u6
                    [3] = u7
                    [4] = u4
                --]]
                u2:RegisterSessionEncryptedAsset(u6, u7)
                u4[u6] = true
            end)
        end
    end
}