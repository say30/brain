--[[
  Extracted from: ReplicatedStorage.Datas.Items
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Items, time of decompilation: Sat Jul 12 13:53:53 2025 ]]
--!native
local l_RunService_0 = game:GetService("RunService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_ServerScriptService_0 = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net);
local v5 = require(l_Packages_0.Debounce);
local v6 = {};
local v7 = 0;
l_RunService_0.Heartbeat:Connect(function(v8) --[[ Line: 16 ]]
	-- upvalues: v7 (ref), v6 (copy)
	v7 = v7 + v8 * 0.2;
	if v7 > 1 then
		v7 = v7 - 1;
	end;
	local v9 = Color3.fromHSV(v7, 1, 1);
	for _, v11 in v6 do
		if v11 and v11.Parent then
			v11.FillColor = v9;
		end;
	end;
end);
local v12 = nil;
local v13 = nil;
local v14 = nil;
local v15 = nil;
return {
	Slap = {
		Name = "Slap", 
		Icon = "rbxassetid://111744314864127", 
		Cooldown = 0.7, 
		Force = 550, 
		RagdollDuration = 3
	}, 
	["Lava Slap"] = {
		["Name"] = "Lava Slap",
		["Icon"] = "rbxassetid://80560167115825",
		["Cooldown"] = 0.7,
		["Force"] = 1200,
		["RagdollDuration"] = 3,
		["HasHighlight"] = true
	},
	["Iron Slap"] = {
		Name = "Iron Slap", 
		Icon = "rbxassetid://126416331206871", 
		Cooldown = 0.7, 
		Force = 600, 
		RagdollDuration = 3
	}, 
	["Gold Slap"] = {
		Name = "Gold Slap", 
		Icon = "rbxassetid://73587459668895", 
		Cooldown = 0.7, 
		Force = 650, 
		RagdollDuration = 3
	}, 
	["Diamond Slap"] = {
		Name = "Diamond Slap", 
		Icon = "rbxassetid://103400414014905", 
		Cooldown = 0.7, 
		Force = 700, 
		RagdollDuration = 3
	}, 
	["Emerald Slap"] = {
		Name = "Emerald Slap", 
		Icon = "rbxassetid://125486072175077", 
		Cooldown = 0.7, 
		Force = 750, 
		RagdollDuration = 3
	}, 
	["Ruby Slap"] = {
		Name = "Ruby Slap", 
		Icon = "rbxassetid://135484448648993", 
		Cooldown = 0.7, 
		Force = 800, 
		RagdollDuration = 3
	}, 
	["Blackhole Slap"] = {
		Name = "Blackhole Slap", 
		Icon = "rbxassetid://105133618369836", 
		Cooldown = 0.7, 
		Force = 850, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		HighlightConfig = {
			FillColor = Color3.fromRGB(255, 0, 0), 
			FillTransparency = 0.5
		}
	}, 
	["Flame Slap"] = {
		Name = "Flame Slap", 
		Icon = "rbxassetid://107751993012682", 
		Cooldown = 0.7, 
		Force = 850, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		HighlightConfig = {
			OutlineColor = Color3.fromRGB(), 
			OutlineTransparency = 0
		}
	}, 
	["Dark Matter Slap"] = {
		Name = "Dark Matter Slap", 
		Icon = "rbxassetid://116359699709899", 
		Cooldown = 0.7, 
		Force = 900, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		HighlightConfig = {
			FillTransparency = 0.9, 
			OutlineTransparency = 0
		}
	}, 
	["Nuclear Slap"] = {
		Name = "Nuclear Slap", 
		Icon = "rbxassetid://94800671695541", 
		Cooldown = 0.7, 
		Force = 950, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		HighlightConfig = {
			OutlineColor = Color3.fromRGB(234, 255, 0), 
			OutilineTransparency = 0
		}
	}, 
	["Galaxy Slap"] = {
		Name = "Galaxy Slap", 
		Icon = "rbxassetid://79582982176990", 
		Cooldown = 0.7, 
		Force = 1050, 
		RagdollDuration = 3, 
		HasHighlight = true
	}, 
	["Bloodmoon Slap"] = {
		Name = "Bloodmoon Slap", 
		Icon = "rbxassetid://105241258528205", 
		Cooldown = 0.7, 
		Force = 1050, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		HighlightConfig = {
			FillTransparency = 0.9, 
			OutlineTransparency = 0
		}
	}, 
	["Glitched Slap"] = {
		Name = "Glitched Slap", 
		Icon = "rbxassetid://87821905406599", 
		Cooldown = 0.7, 
		Force = 1150, 
		RagdollDuration = 3, 
		HasHighlight = true
	}, 
	["Rainbow Slap"] = {
		Name = "Rainbow Slap", 
		Icon = "rbxassetid://76888105480836", 
		Cooldown = 0.7, 
		Force = 1150, 
		RagdollDuration = 3, 
		HasHighlight = true
	}, 
	["Candy Slap"] = {
		Name = "Candy Slap", 
		Icon = "rbxassetid://116411677446062", 
		Cooldown = 0.7, 
		Force = 1200, 
		RagdollDuration = 3, 
		HasHighlight = true
	}, 
	["Splatter Slap"] = {
		Name = "Splatter Slap", 
		Icon = "rbxassetid://88294870214352", 
		Cooldown = 0.7, 
		Force = 1200, 
		RagdollDuration = 3, 
		HasHighlight = true, 
		OnHit = function(v18) --[[ Line: 228 ]] --[[ Name: OnHit ]]
			-- upvalues: l_RunService_0 (copy), v4 (copy)
			if l_RunService_0:IsServer() then
				v4:RemoteEvent("UseItem"):FireClient(v18, "PaintballHitted", 9);
			end;
		end
	}, 
	["Ban Hammer"] = {
		Name = "Ban Hammer", 
		Icon = "rbxassetid://102903994473061", 
		Cooldown = 0.7, 
		Force = 900, 
		RagdollDuration = 3, 
		HasParticles = function(v19, v20) --[[ Line: 243 ]] --[[ Name: HasParticles ]]
			local l_Part_0 = Instance.new("Part");
			l_Part_0.CanCollide = false;
			l_Part_0.Size = Vector3.new(1, 1, 1, 0);
			l_Part_0.Anchored = false;
			l_Part_0.Transparency = 1;
			l_Part_0.CFrame = v19.CFrame * CFrame.new(0, 0.4, -3);
			l_Part_0.Parent = workspace;
			local l_WeldConstraint_0 = Instance.new("WeldConstraint");
			l_WeldConstraint_0.Part0 = v19;
			l_WeldConstraint_0.Part1 = l_Part_0;
			l_WeldConstraint_0.Parent = l_Part_0;
			local v23 = v20.Handle.Attachment:Clone();
			v23.Parent = l_Part_0;
			v23.ParticleEmitter:Emit(2);
			task.delay(1, function() --[[ Line: 261 ]]
				-- upvalues: l_Part_0 (copy), l_WeldConstraint_0 (copy), v23 (copy)
				if l_Part_0 then
					l_Part_0:Destroy();
				end;
				if l_WeldConstraint_0 then
					l_WeldConstraint_0:Destroy();
				end;
				if v23 then
					v23:Destroy();
				end;
			end);
		end
	}, 
	["Bloodmoon Hammer"] = {
		Name = "Bloodmoon Hammer", 
		Icon = "rbxassetid://96284196754755", 
		Cooldown = 0.7, 
		Force = 900, 
		RagdollDuration = 6, 
		HasParticles = function(v24, v25) --[[ Line: 282 ]] --[[ Name: HasParticles ]]
			local l_Part_1 = Instance.new("Part");
			l_Part_1.CanCollide = false;
			l_Part_1.Size = Vector3.new(1, 1, 1, 0);
			l_Part_1.Anchored = false;
			l_Part_1.Transparency = 1;
			l_Part_1.CFrame = v24.CFrame * CFrame.new(0, 0.4, -3);
			l_Part_1.Parent = workspace;
			local l_WeldConstraint_1 = Instance.new("WeldConstraint");
			l_WeldConstraint_1.Part0 = v24;
			l_WeldConstraint_1.Part1 = l_Part_1;
			l_WeldConstraint_1.Parent = l_Part_1;
			local v28 = v25.Handle.Attachment:Clone();
			v28.Parent = l_Part_1;
			v28.ParticleEmitter:Emit(2);
			task.delay(1, function() --[[ Line: 300 ]]
				-- upvalues: l_Part_1 (copy), l_WeldConstraint_1 (copy), v28 (copy)
				if l_Part_1 then
					l_Part_1:Destroy();
				end;
				if l_WeldConstraint_1 then
					l_WeldConstraint_1:Destroy();
				end;
				if v28 then
					v28:Destroy();
				end;
			end);
		end, 
		OnHit = function(_, v30) --[[ Line: 313 ]] --[[ Name: OnHit ]]
			local l_Highlight_0 = Instance.new("Highlight");
			l_Highlight_0.DepthMode = Enum.HighlightDepthMode.Occluded;
			l_Highlight_0.FillColor = Color3.fromRGB(255, 0, 0);
			l_Highlight_0.FillTransparency = 0.5;
			l_Highlight_0.OutlineTransparency = 1;
			l_Highlight_0.Adornee = v30;
			l_Highlight_0.Parent = v30;
			task.delay(2.5, function() --[[ Line: 322 ]]
				-- upvalues: l_Highlight_0 (copy)
				l_Highlight_0:Destroy();
			end);
		end
	}, 
	["Rainbow Hammer"] = {
		Name = "Rainbow Hammer", 
		Icon = "rbxassetid://139876541578910", 
		Cooldown = 0.7, 
		Force = 1000, 
		RagdollDuration = 6, 
		HasParticles = function(v32, v33) --[[ Line: 335 ]] --[[ Name: HasParticles ]]
			local l_Part_2 = Instance.new("Part");
			l_Part_2.CanCollide = false;
			l_Part_2.Size = Vector3.new(1, 1, 1, 0);
			l_Part_2.Anchored = false;
			l_Part_2.Transparency = 1;
			l_Part_2.CFrame = v32.CFrame * CFrame.new(0, 0.4, -3);
			l_Part_2.Parent = workspace;
			local l_WeldConstraint_2 = Instance.new("WeldConstraint");
			l_WeldConstraint_2.Part0 = v32;
			l_WeldConstraint_2.Part1 = l_Part_2;
			l_WeldConstraint_2.Parent = l_Part_2;
			local v36 = v33.Handle.Attachment:Clone();
			v36.Parent = l_Part_2;
			v36.ParticleEmitter:Emit(2);
			task.delay(1, function() --[[ Line: 353 ]]
				-- upvalues: l_Part_2 (copy), l_WeldConstraint_2 (copy), v36 (copy)
				if l_Part_2 then
					l_Part_2:Destroy();
				end;
				if l_WeldConstraint_2 then
					l_WeldConstraint_2:Destroy();
				end;
				if v36 then
					v36:Destroy();
				end;
			end);
		end, 
		OnHit = function(_, v38) --[[ Line: 366 ]] --[[ Name: OnHit ]]
			-- upvalues: v6 (copy)
			local l_Highlight_1 = Instance.new("Highlight");
			l_Highlight_1.DepthMode = Enum.HighlightDepthMode.Occluded;
			l_Highlight_1.OutlineTransparency = 0;
			l_Highlight_1.FillTransparency = 0.5;
			l_Highlight_1.Adornee = v38;
			l_Highlight_1.Parent = v38;
			table.insert(v6, l_Highlight_1);
			task.delay(2.5, function() --[[ Line: 376 ]]
				-- upvalues: v6 (ref), l_Highlight_1 (copy)
				table.remove(v6, table.find(v6, l_Highlight_1));
				l_Highlight_1:Destroy();
			end);
		end
	}, 
	["Small Tree"] = {
		Name = "Small Tree", 
		Icon = "rbxassetid://70956898840223", 
		Cooldown = 0.7, 
		Force = 1000, 
		Range = Vector3.new(12, 12, 12, 0), 
		RagdollDuration = 3
	}, 
	["Medium Tree"] = {
		Name = "Medium Tree", 
		Icon = "rbxassetid://117374249944925", 
		Cooldown = 0.7, 
		Force = 1100, 
		Range = Vector3.new(14, 14, 14, 0), 
		RagdollDuration = 3
	}, 
	["Huge Tree"] = {
		Name = "Huge Tree", 
		Icon = "rbxassetid://114915257709192", 
		Cooldown = 0.7, 
		Force = 1200, 
		Range = Vector3.new(16, 16, 16, 0), 
		RagdollDuration = 3
	}, 
	["Rainbow Small Tree"] = {
		Name = "Rainbow Small Tree", 
		Icon = "rbxassetid://136011850681459", 
		Cooldown = 0.7, 
		Force = 1200, 
		Range = Vector3.new(12, 12, 12, 0), 
		RagdollDuration = 3
	}, 
	["Rainbow Medium Tree"] = {
		Name = "Rainbow Medium Tree", 
		Icon = "rbxassetid://83546641619026", 
		Cooldown = 0.7, 
		Force = 1300, 
		Range = Vector3.new(14, 14, 14, 0), 
		RagdollDuration = 3
	}, 
	["Rainbow Huge Tree"] = {
		Name = "Rainbow Huge Tree", 
		Icon = "rbxassetid://119257172353286", 
		Cooldown = 0.7, 
		Force = 1400, 
		Range = Vector3.new(16, 16, 16, 0), 
		RagdollDuration = 3
	}, 
	["Tung Bat"] = {
		Name = "Tung Bat", 
		Icon = "rbxassetid://86735158693802", 
		Cooldown = 0.7, 
		Force = 500, 
		RagdollDuration = 3
	}, 
	Lollipop = {
		Name = "Lollipop", 
		Icon = "rbxassetid://95336128645462", 
		Cooldown = 0.7, 
		Force = 800, 
		RagdollDuration = 3, 
		OnHit = function(v40, v41) --[[ Line: 454 ]] --[[ Name: OnHit ]]
			-- upvalues: v4 (copy)
			local function v48(v42) --[[ Line: 455 ]] --[[ Name: ApplyCandyEffect ]]
				for _, v44 in v42:GetChildren() do
					if v44:IsA("BasePart") then
						for _, v46 in script.Effect:GetChildren() do
							local v47 = v46:Clone();
							v47.Parent = v44;
							task.delay(5, function() --[[ Line: 464 ]]
								-- upvalues: v47 (copy)
								v47:Destroy();
							end);
						end;
					end;
				end;
			end;
			local l_Humanoid_0 = v41:FindFirstChildOfClass("Humanoid");
			local l_HumanoidRootPart_0 = v41:FindFirstChild("HumanoidRootPart");
			if not l_Humanoid_0 or not l_HumanoidRootPart_0 then
				return;
			else
				local v51 = script.BillboardPart.BillboardGui:Clone();
				v51.Parent = l_HumanoidRootPart_0;
				v48(v41);
				v40:SetAttribute("DivideSpeed", true);
				task.delay(5, function() --[[ Line: 483 ]]
					-- upvalues: v40 (copy), v51 (copy)
					v40:SetAttribute("DivideSpeed", nil);
					v51:Destroy();
				end);
				v4:RemoteEvent("UseItem"):FireClient(v40, "CandyEffect", 5);
				return;
			end;
		end
	}, 
	["Candy Cane"] = {
		Name = "Candy Cane", 
		Icon = "rbxassetid://19250774", 
		Cooldown = 0.4, 
		Force = 500, 
		RagdollDuration = 3
	}, 
	["Gummy Stick"] = {
		Name = "Gummy Stick", 
		Icon = "rbxassetid://81350787786383", 
		Cooldown = 0.7, 
		Force = 400, 
		RagdollDuration = 3, 
		OnHit = function(v52, v53) --[[ Line: 509 ]] --[[ Name: OnHit ]]
			-- upvalues: v5 (copy), v12 (ref), v13 (ref), v14 (ref), v15 (ref)
			if v5(("TurnedToGummy/%*/Server"):format(v52.Name), 10) then
				return;
			else
				local l_GummyBear_0 = v12:FindFirstChild("GummyBear");
				if not l_GummyBear_0 then
					return;
				else
					local l_GummyController_0 = v13:FindFirstChild("GummyController");
					if not l_GummyController_0 then
						return;
					elseif v52:GetAttribute("Web") then
						return;
					else
						local l_HumanoidRootPart_1 = v53:FindFirstChild("HumanoidRootPart");
						if not l_HumanoidRootPart_1 then
							return;
						else
							local l_Humanoid_1 = v53:FindFirstChildWhichIsA("Humanoid");
							if not l_Humanoid_1 then
								return;
							else
								task.wait(0.3);
								v52:SetAttribute("RagdollEndTime", 0);
								local v58 = v14.GummyBear:Clone();
								v58.Parent = l_HumanoidRootPart_1;
								v58:Play();
								v52:SetAttribute("Web", true);
								v52:SetAttribute("BlockTools", true);
								v53:SetAttribute("SpeedAllowance", 120);
								--v15:CancelSteal(v52);
								l_Humanoid_1.PlatformStand = true;
								l_Humanoid_1:UnequipTools();
								local l_WeldConstraint_3 = Instance.new("WeldConstraint");
								l_WeldConstraint_3.Part0 = l_HumanoidRootPart_1;
								local v60 = l_GummyBear_0:Clone();
								v60:PivotTo(v53:GetPivot());
								v60.Color = BrickColor.random().Color;
								v60.Parent = workspace;
								local v61 = l_GummyController_0:Clone();
								v61.Orb.Value = v60.Part;
								v61.Enabled = true;
								v61.Parent = v53;
								for _, v63 in v60:GetDescendants() do
									if v63:IsA("BasePart") then
										v63:SetNetworkOwner(v52);
									end;
								end;
								l_WeldConstraint_3.Part1 = v60;
								l_WeldConstraint_3.Parent = v60;
								v53:SetAttribute("InGummy", true);
								v52:SetAttribute("NoMouseLockOffset", true);
								task.delay(5, function() --[[ Line: 579 ]]
									-- upvalues: v58 (copy), v60 (copy), l_Humanoid_1 (copy), v52 (copy), v53 (copy)
									v58:Destroy();
									v60:Destroy();
									l_Humanoid_1.PlatformStand = false;
									v52:SetAttribute("Web", nil);
									v52:SetAttribute("BlockTools", nil);
									v53:SetAttribute("SpeedAllowance", nil);
									v53:SetAttribute("InGummy", nil);
									v52:SetAttribute("NoMouseLockOffset", nil);
								end);
								return;
							end;
						end;
					end;
				end;
			end;
		end
	}, 
	["Dev Slap"] = {
		Name = "Dev Slap", 
		Icon = "", 
		Cooldown = 0.7, 
		Force = 5000, 
		Range = Vector3.new(25, 25, 25, 0), 
		RagdollDuration = 5, 
		HasHighlight = true
	}
};