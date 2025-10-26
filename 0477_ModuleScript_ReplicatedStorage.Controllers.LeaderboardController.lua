--[[
  Extracted from: ReplicatedStorage.Controllers.LeaderboardController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: LeaderboardController, time of decompilation: Sat Jul 12 14:21:10 2025 ]]
local _ = game:GetService("Players");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Workspace_0 = game:GetService("Workspace");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local l_Utils_0 = l_ReplicatedStorage_0:WaitForChild("Utils");
local v5 = require(l_Packages_0.Net);
local _ = require(l_Packages_0.Timer);
local v7 = require(l_Utils_0.NumberUtils);
local l_Map_0 = l_Workspace_0.Map;
local v9 = {};
local v10 = {};
local v11 = {
	Generation = {
		Model = l_Map_0:WaitForChild("GenerationBoard"), 
		PlayerData = {}
	}, 
	Steals = {
		Model = l_Map_0:WaitForChild("StealsBoard"), 
		PlayerData = {}
	}
};
local v12 = Color3.fromRGB(255, 213, 0);
local v13 = Color3.fromRGB(116, 116, 116);
local v14 = Color3.fromRGB(143, 87, 35);
local v15 = Color3.fromRGB(255, 255, 255);
local v16 = v5:RemoteFunction("Leaderboard/GetTopPlayers");
local v17 = v5:RemoteFunction("Leaderboard/GetDisplayNames");
local v18 = v5:RemoteEvent("Leaderboard/ReplicateUpdate");
local v19 = v5:RemoteEvent("Leaderboard/ReplicateDisplayNames");
return {
	UpdateBoard = function(_, v21) --[[ Line: 49 ]] --[[ Name: UpdateBoard ]]
		-- upvalues: v11 (copy), v10 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v9 (copy), v7 (copy)
		local v22 = v11[v21];
		if not v22 then
			return;
		else
			local l_ScrollingFrame_0 = v22.Model:WaitForChild("Main"):WaitForChild("SurfaceGui"):WaitForChild("MainFrame"):WaitForChild("ScrollingFrame");
			local l_LeaderboardTemplate_0 = l_ScrollingFrame_0:WaitForChild("LeaderboardTemplate");
			local l_PlayerData_0 = v22.PlayerData;
			for _, v27 in ipairs(l_ScrollingFrame_0:GetChildren()) do
				if v27:IsA("Frame") and v27.Name:sub(1, 4) == "Line" then
					local l_v27_Attribute_0 = v27:GetAttribute("UserId");
					local v29 = v10[l_v27_Attribute_0];
					local v30 = if v29 then table.find(v29, v27) else nil;
					if v30 then
						table.remove(v29, v30);
						if #v29 == 0 then
							v10[l_v27_Attribute_0] = nil;
						end;
					end;
					v27:Destroy();
				end;
			end;
			for v31 = 1, math.min(100, #l_PlayerData_0) do
				local v32 = l_PlayerData_0[v31];
				local v33 = l_LeaderboardTemplate_0:Clone();
				v33.Visible = true;
				v33.Name = "Line" .. v31;
				v33.LayoutOrder = v31;
				local l_PositionLabel_0 = v33:FindFirstChild("PositionLabel");
				local l_NameLabel_0 = v33:FindFirstChild("NameLabel");
				local l_v33_FirstChild_0 = v33:FindFirstChild(v21 .. "Label");
				local l_AvatarImage_0 = v33:FindFirstChild("AvatarImage");
				local l_UIStroke_0 = l_AvatarImage_0:FindFirstChild("UIStroke");
				local v39 = nil;
				v39 = if v32.Rank == 1 then v12 else if v32.Rank == 2 then v13 else if v32.Rank == 3 then v14 else v15;
				if l_PositionLabel_0 then
					l_PositionLabel_0.Text = tostring(v32.Rank) .. ".";
					l_PositionLabel_0.TextColor3 = v39;
				end;
				if l_NameLabel_0 then
					l_NameLabel_0.Text = v9[v32.UserId] or "Loading...";
					l_NameLabel_0.TextColor3 = v39;
				end;
				if l_v33_FirstChild_0 then
					local v40 = v7:ToString(math.round(v32.Value), 2);
					l_v33_FirstChild_0.Text = if v21 == "Generation" then v40 .. "/s" else v40;
					l_v33_FirstChild_0.TextColor3 = v39;
				end;
				if l_AvatarImage_0 then
					l_AvatarImage_0.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=100&h=100"):format(v32.UserId);
					if l_UIStroke_0 then
						l_UIStroke_0.Color = v39;
					end;
				end;
				if not v10[v32.UserId] then
					v10[v32.UserId] = {
						v33
					};
				else
					table.insert(v10[v32.UserId], v33);
				end;
				v33:SetAttribute("UserId", v32.UserId);
				v33.Parent = l_ScrollingFrame_0;
			end;
			return;
		end;
	end, 
	RefreshLeaderboard = function(v41, v42, v43) --[[ Line: 135 ]] --[[ Name: RefreshLeaderboard ]]
		-- upvalues: v16 (copy), v11 (copy)
		if not v43 then
			pcall(function() --[[ Line: 137 ]]
				-- upvalues: v43 (ref), v16 (ref), v42 (copy)
				v43 = v16:InvokeServer(v42);
			end);
		end;
		if type(v43) == "table" then
			v11[v42].PlayerData = v43;
			v41:UpdateBoard(v42);
		end;
	end, 
	Start = function(v44) --[[ Line: 148 ]] --[[ Name: Start ]]
		-- upvalues: v9 (copy), v10 (copy), v18 (copy), v19 (copy), v17 (copy), v11 (copy)
		task.spawn(function() --[[ Line: 149 ]]
			-- upvalues: v9 (ref), v10 (ref), v18 (ref), v44 (copy), v19 (ref), v17 (ref), v11 (ref)
			local function v53(v45) --[[ Line: 151 ]] --[[ Name: updateNameCache ]]
				-- upvalues: v9 (ref), v10 (ref)
				if type(v45) ~= "table" then
					return;
				else
					for v46, v47 in v45 do
						local v48 = tonumber(v46);
						if v48 then
							v9[v48] = v47;
							local v49 = v10[v48];
							if type(v49) == "table" then
								for _, v51 in v49 do
									local l_NameLabel_1 = v51:FindFirstChild("NameLabel");
									if l_NameLabel_1 then
										l_NameLabel_1.Text = v47;
									end;
								end;
							end;
						end;
					end;
					return;
				end;
			end;
			v18.OnClientEvent:Connect(function(v54, v55) --[[ Line: 178 ]]
				-- upvalues: v44 (ref)
				v44:RefreshLeaderboard(v54, v55);
			end);
			v19.OnClientEvent:Connect(v53);
			v53(v17:InvokeServer());
			for v56 in pairs(v11) do
				v44:RefreshLeaderboard(v56);
			end;
		end);
	end
};