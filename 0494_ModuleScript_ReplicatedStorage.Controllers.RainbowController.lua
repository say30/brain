--[[
  Extracted from: ReplicatedStorage.Controllers.RainbowController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("UserInputService")
local u3 = game:GetService("RunService")
local v4 = v1:WaitForChild("Controllers")
require(v4.PlayerController)
local v5 = v1:WaitForChild("Datas")
local v6 = require(v5.Mutations)
local v7 = v1:WaitForChild("Packages")
local u8 = require(v7.Observers)
local u9 = require(v7.Signal)
local u10 = require(v7.Trove)
local u11 = v6.Rainbow
local u12 = v1:WaitForChild("MutationSurfaces")
local u13 = UserSettings().GameSettings
local u14 = workspace.CurrentCamera
local u15 = Enum.SavedQualitySetting.QualityLevel6.Value
return {
	["Start"] = function(_) --[[Function name: Start, line 33]]
        --[[
        Upvalues:
            [1] = u11
            [2] = u9
            [3] = u2
            [4] = u13
            [5] = u15
            [6] = u14
            [7] = u3
            [8] = u8
            [9] = u10
            [10] = u12
        --]]
		local u16 = u11.Palettes[1]
		local v17 = #u16
		local u18 = math.min(v17, 4)
		u9.new()
		local u19 = nil
		local u20 = {}
		local u21 = 0.05
		local function v23() --[[Anonymous function at line 61]]
            --[[
            Upvalues:
                [1] = u2
                [2] = u13
                [3] = u15
                [4] = u21
            --]]
			local v22 = u2.TouchEnabled and not u2.KeyboardEnabled
			if v22 then
				v22 = not u2.MouseEnabled
			end
			if v22 and u13.SavedQualityLevel.Value <= u15 then
				u21 = 0.1
			else
				u21 = 0.05
			end
		end
		u2:GetPropertyChangedSignal("TouchEnabled"):Connect(v23)
		u2:GetPropertyChangedSignal("KeyboardEnabled"):Connect(v23)
		u2:GetPropertyChangedSignal("MouseEnabled"):Connect(v23)
		task.spawn(v23)
		local u24 = nil
		local u25 = 0
		local function u29(p26) --[[Anonymous function at line 79]]
            --[[
            Upvalues:
                [1] = u25
                [2] = u24
                [3] = u14
                [4] = u20
            --]]
			u25 = u25 + p26
			if u25 >= 0.5 then
				u25 = 0
				u24 = u14.CFrame.Position // 25
				for v27, v28 in u20 do
					if v28.isPVInstance then
						v28.voxel = v27:GetPivot().Position // 25
					end
				end
			end
		end
		local function u49(_) --[[Anonymous function at line 96]]
            --[[
            Upvalues:
                [1] = u18
                [2] = u19
                [3] = u16
                [4] = u20
                [5] = u21
                [6] = u24
            --]]
			local v30 = os.clock()
			local v31 = (v30 % u18 + 1) // 1
			u19 = u16[v31]:Lerp(u16[v31 % u18 + 1], v30 % 1)
			local v32, v33 = u19:ToHSV()
			for _, v34 in u20 do
				local v35 = u21
				local v36 = v34.voxel
				if v36 then
					local v37 = v36.X - u24.X
					local v38 = math.abs(v37)
					local v39 = v36.Z - u24.Z
					local v40 = (v38 + math.abs(v39)) / 10 + 1
					v35 = v35 * math.clamp(v40, 1, 2.5)
				end
				if v30 - v34.lastUpdate >= v35 then
					v34.lastUpdate = v30
					local v41 = v34.defaultColor
					local v42
					if v41 then
						local _, _, v43 = v41:ToHSV()
						local v44 = Color3.fromHSV
						local v45 = v33 - 0.4
						local v46 = math.max(v45, 0)
						local v47 = v43 + 0.2
						v42 = v44(v32, v46, (math.min(v47, 1)))
					else
						v42 = nil
					end
					for _, v48 in v34.list do
						v48.Color = v42 or u19
					end
				end
			end
		end
		u3.PreRender:Connect(function(p50) --[[Anonymous function at line 134]]
            --[[
            Upvalues:
                [1] = u29
                [2] = u49
            --]]
			debug.profilebegin("rainbow:update")
			debug.profilebegin("rainbow:updateVoxels")
			u29(p50)
			debug.profileend()
			debug.profilebegin("rainbow:updateColors")
			u49(p50)
			debug.profileend()
			debug.profileend()
		end)
		u8.observeTag("RainbowModel", function(u51) --[[Anonymous function at line 148]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u8
                [3] = u12
                [4] = u20
            --]]
			local v52 = u51:IsA("PVInstance")
			if not v52 then
				warn((("%* has RainbowModel but is not a PVInstance, can\'t measure distance"):format((u51:GetFullName()))))
			end
			local v53 = u10.new()
			local u54 = {}
			if u51:IsA("BasePart") and (u51.Transparency < 1 or u51:GetAttribute("RainbowIgnoreTransparency")) and not u51:GetAttribute("IgnoreRainbowColor") then
				table.insert(u54, u51)
			end
			v53:Add(u8.observeDescendants(u51, function(u55) --[[Anonymous function at line 162]]
                --[[
                Upvalues:
                    [1] = u51
                    [2] = u12
                    [3] = u54
                --]]
				if u55:IsA("BasePart") and (u55.Transparency < 1 or u51:GetAttribute("RainbowIgnoreTransparency")) and not u55:GetAttribute("IgnoreRainbowColor") then
					local v56 = u55:FindFirstChildOfClass("SurfaceAppearance")
					if not v56 then
						local v57 = u54
						table.insert(v57, u55)
						return function() --[[Anonymous function at line 185]]
                            --[[
                            Upvalues:
                                [1] = u54
                                [2] = u55
                            --]]
							local v58 = table.find(u54, u55)
							if v58 then
								table.remove(u54, v58)
							end
						end
					end
					local v59 = u12[u51.Name]
					v56:Destroy()
					local u60 = v59:Clone()
					u60.Parent = u55
					local v61 = u54
					table.insert(v61, u60)
					return function() --[[Anonymous function at line 176]]
                        --[[
                        Upvalues:
                            [1] = u54
                            [2] = u60
                        --]]
						local v62 = table.find(u54, u60)
						if v62 then
							table.remove(u54, v62)
						end
					end
				end
			end))
			local v63 = u20
			local v64 = {
				["list"] = u54,
				["lastUpdate"] = 0,
				["isPVInstance"] = v52
			}
			local v65
			if u51:HasTag("RainbowDarken") then
				v65 = u51.Color
			else
				v65 = nil
			end
			v64.defaultColor = v65
			v63[u51] = v64
			v53:Add(function() --[[Anonymous function at line 200]]
                --[[
                Upvalues:
                    [1] = u20
                    [2] = u51
                --]]
				u20[u51] = nil
			end)
			return v53:WrapClean()
		end)
	end
}