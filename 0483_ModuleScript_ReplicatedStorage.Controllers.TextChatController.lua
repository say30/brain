--[[
  Extracted from: ReplicatedStorage.Controllers.TextChatController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: TextChatController, time of decompilation: Sat Jun 28 18:35:02 2025 ]]
local l_TextChatService_0 = game:GetService("TextChatService");
local l_Players_0 = game:GetService("Players");
local l_Packages_0 = game:GetService("ReplicatedStorage").Packages;
local _ = require(l_Packages_0.Synchronizer);
return {
    Start = function(_) --[[ Line: 14 ]] --[[ Name: Start ]]
        -- upvalues: l_TextChatService_0 (copy), l_Players_0 (copy)
        l_TextChatService_0.OnIncomingMessage = function(v5) --[[ Line: 16 ]]
            -- upvalues: l_Players_0 (ref)
            local v6 = v5.TextSource and l_Players_0:GetPlayerByUserId(v5.TextSource.UserId);
            if not v6 then
                return;
            else
                local l_TextChatMessageProperties_0 = Instance.new("TextChatMessageProperties");
                local v8 = "";
                if v6:GetAttribute("VIP") then
                    v8 = v8 .. ("<font color=\"#FFD700\">[VIP]</font>%*"):format(v5.PrefixText or "");
                end;
                l_TextChatMessageProperties_0.PrefixText = v8;
                return l_TextChatMessageProperties_0;
            end;
        end;
    end
};