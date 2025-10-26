--[[
  Extracted from: ReplicatedStorage.Controllers.VoiceChatController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: VoiceChatController, time of decompilation: Sat Jul 12 14:21:44 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_VoiceChatService_0 = game:GetService("VoiceChatService");
local l_TeleportService_0 = game:GetService("TeleportService");
local l_Players_0 = game:GetService("Players");
local v4 = require(l_ReplicatedStorage_0.Controllers.InterfaceController);
local v5 = require(l_ReplicatedStorage_0.Controllers.NotificationController);
local v6 = require(l_ReplicatedStorage_0.Packages.TopbarPlus);
local v7 = require(l_ReplicatedStorage_0.Classes.AnimatedButton);
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local l_PlayerGui_0 = l_LocalPlayer_0.PlayerGui;
local v10 = nil;
local v11 = v6.new():setLabel("VC Servers"):setOrder(3);
local v12 = game.GameId == 0 and 0 or 0; -- CHANGE HERE UR ID
local l_VoiceChat_0 = l_PlayerGui_0:WaitForChild("VoiceChat").VoiceChat;
local l_Close_0 = l_VoiceChat_0.Close;
local l_Yes_0 = l_VoiceChat_0.Yes;
local l_Cancel_0 = l_VoiceChat_0.Cancel;
return {
	Start = function(_) --[[ Line: 33 ]] --[[ Name: Start ]]
		-- upvalues: v10 (ref), v4 (copy), l_VoiceChat_0 (copy), l_Close_0 (copy), l_Cancel_0 (copy), v11 (copy), v7 (copy), l_Yes_0 (copy), l_VoiceChatService_0 (copy), l_LocalPlayer_0 (copy), l_TeleportService_0 (copy), v12 (copy), v5 (copy)
		v10 = v4:Register("VoiceChat", l_VoiceChat_0, "TopQuint");
		v10:AttachCloseButton(l_Close_0);
		v10:AttachCloseButton(l_Cancel_0);
		v10:Close();
		v11.selected:Connect(function() --[[ Line: 41 ]]
			-- upvalues: v4 (ref)
			v4:SetState("VoiceChat", true);
		end);
		v11.deselected:Connect(function() --[[ Line: 45 ]]
			-- upvalues: v4 (ref)
			v4:SetState("VoiceChat", false);
		end);
		v10.OnOpen:Connect(function() --[[ Line: 49 ]]
			-- upvalues: v11 (ref)
			v11:select();
		end);
		v10.OnClose:Connect(function() --[[ Line: 53 ]]
			-- upvalues: v11 (ref)
			v11:deselect();
		end);
		local v18 = v7.new(l_Yes_0);
		v18:Animate();
		v18.OnActivated:Connect(function() --[[ Line: 59 ]]
			-- upvalues: l_VoiceChatService_0 (ref), l_LocalPlayer_0 (ref), l_TeleportService_0 (ref), v12 (ref), v5 (ref)
			local l_status_0, l_result_0 = pcall(function() --[[ Line: 60 ]]
				-- upvalues: l_VoiceChatService_0 (ref), l_LocalPlayer_0 (ref)
				return l_VoiceChatService_0:IsVoiceEnabledForUserIdAsync(l_LocalPlayer_0.UserId);
			end);
			if l_status_0 and l_result_0 then
				l_TeleportService_0:Teleport(v12, l_LocalPlayer_0);
				return;
			else
				v5:Error("You must have Voice Chat enabled to join this experience.");
				return;
			end;
		end);
	end
};