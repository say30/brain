--[[
  Extracted from: ReplicatedStorage.Controllers.CoinsShopController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
game:GetService("TweenService")
local v3 = v1:WaitForChild("Packages")
local v4 = v1:WaitForChild("Controllers")
local v5 = v1:WaitForChild("Classes")
local v6 = v1:WaitForChild("Utils")
local v7 = v1:WaitForChild("Datas")
local v8 = v1:WaitForChild("Shared")
local v9 = require(v3.Net)
local v10 = require(v3.Trove)
local u11 = require(v4.InterfaceController)
require(v4.CameraController)
local u12 = require(v5.AnimatedButton)
local u13 = require(v3.Synchronizer)
local u14 = require(v6.NumberUtils)
local u15 = require(v7.ShopItems)
local u16 = require(v4.NotificationController)
local u17 = require(v4.SoundController)
local u18 = require(v8.Updates)
local u19 = v9:RemoteFunction("CoinsShopService/RequestBuy")
local u20 = v9:RemoteFunction("CoinsShopService/ToggleAutoBuy")
local u21 = v2.LocalPlayer
local v22 = u21.PlayerGui
local u23 = {}
local u24 = nil
local u25 = v22:WaitForChild("CoinsShop"):WaitForChild("CoinsShop")
local u26 = u25.Content.Items
local u27 = u26.Template
local u28 = u25.Header.Close
local u29 = nil
local u30 = v10.new()
local v31 = {}
local function u55(p32, p33) --[[Anonymous function at line 55]]
    --[[
    Upvalues:
        [1] = u30
        [2] = u26
        [3] = u15
        [4] = u27
        [5] = u23
        [6] = u14
        [7] = u21
        [8] = u12
        [9] = u20
        [10] = u16
        [11] = u17
        [12] = u24
        [13] = u19
    --]]
	u30:Destroy()
	if #u26:GetChildren() >= 1 then
		for _, v34 in ipairs(u26:GetChildren()) do
			if v34.Name ~= "Template" and v34:IsA("ImageLabel") then
				v34:Destroy()
			end
		end
	end
	for u35, v36 in pairs(u15) do
		if v36.Currency == "Coins" then
			local v37 = u27:Clone()
			local v38 = v37.ItemInformation
			local v39 = v38.ItemName
			local v40 = v38.ItemDescription
			local v41 = v37.ItemImage
			local v42 = v37.Buy
			local u43 = v37.Auto
			local _ = v37.AutoLabel
			local v44 = v42.Price
			local v45 = v37.Locked
			local v46 = v45.Txt
			v37.Name = u35
			v39.Text = u35
			v40.Text = v36.Description
			v41.Image = v36.Icon
			v44.Text = u23[u35] and "OWNED" or "$ " .. u14:ToString(v36.Price, 2)
			v37.LayoutOrder = v36.LayoutOrder or 0
			local v47
			if u35 == "Trap" then
				v47 = (u21:GetAttribute("TrapCount") or 0) < 5
				v44.Text = v47 and ("$ " .. u14:ToString(v36.Price, 2) or "OWNED") or "OWNED"
			elseif v36.Price <= p33 then
				v47 = not u23[u35]
			else
				v47 = false
			end
			if v36.RebirthRequired then
				if v36.RebirthRequired <= p32 then
					v45.Visible = false
				else
					v46.Text = "YOU NEED " .. v36.RebirthRequired .. " REBIRTHS"
					v42.Visible = false
				end
			else
				v45.Visible = false
				v46.Visible = false
			end
			u43.Visible = v47
			local v48 = u12.new(u43)
			v48:Animate()
			v48.OnActivated:Connect(function() --[[Anonymous function at line 115]]
                --[[
                Upvalues:
                    [1] = u20
                    [2] = u35
                    [3] = u16
                    [4] = u17
                --]]
				local v49, v50 = u20:InvokeServer(u35)
				if not v49 then
					if v50 then
						u16:Error(v50)
					end
					u17:PlaySound("Sounds.Sfx.Error")
				end
			end)
			u43.Yes.Visible = u24:Get((("AutoBuy.%*"):format(u35))) == true
			u30:Add(u24:OnChanged(("AutoBuy.%*"):format(u35), function(p51) --[[Anonymous function at line 127]]
                --[[
                Upvalues:
                    [1] = u43
                --]]
				u43.Yes.Visible = p51 == true
			end))
			if v47 then
				local v52 = u12.new(v42)
				v52:Animate()
				v52.OnActivated:Connect(function() --[[Anonymous function at line 135]]
                    --[[
                    Upvalues:
                        [1] = u19
                        [2] = u35
                        [3] = u16
                        [4] = u17
                        [5] = u23
                    --]]
					local v53, v54 = u19:InvokeServer(u35)
					if v53 then
						u16:Success(v54)
						u17:PlaySound("Sounds.Sfx.Success")
						u23[u35] = (u23[u35] or 0) + 1
					else
						u16:Error(v54)
						u17:PlaySound("Sounds.Sfx.Error")
					end
				end)
			else
				v42.ImageColor3 = Color3.fromRGB(138, 138, 138)
			end
			v37.Visible = not v36.IsEnabled and true or v36.IsEnabled()
			v37.Parent = u26
		end
	end
end
function v31.Start(_) --[[Anonymous function at line 164]]
    --[[
    Upvalues:
        [1] = u29
        [2] = u11
        [3] = u25
        [4] = u28
        [5] = u13
        [6] = u21
        [7] = u24
        [8] = u55
        [9] = u18
    --]]
	local u56 = 0
	local u57 = 0
	u29 = u11:Register("CoinsShop", u25, "TopQuint")
	u29:AttachCloseButton(u28)
	u29:Close()
	u13:WaitAndCall(u21, function(p58) --[[Anonymous function at line 174]]
        --[[
        Upvalues:
            [1] = u24
            [2] = u56
            [3] = u55
            [4] = u57
            [5] = u18
        --]]
		u24 = p58
		p58:OnChanged("Rebirth", function(p59) --[[Anonymous function at line 177]]
            --[[
            Upvalues:
                [1] = u56
                [2] = u55
                [3] = u57
            --]]
			u56 = p59
			u55(u56, u57)
		end, true)
		p58:OnChanged("Coins", function(p60) --[[Anonymous function at line 182]]
            --[[
            Upvalues:
                [1] = u57
                [2] = u55
                [3] = u56
            --]]
			u57 = p60
			u55(u56, u57)
		end, true)
		u18.OnUpdateEnabled:Connect(function() --[[Anonymous function at line 187]]
            --[[
            Upvalues:
                [1] = u55
                [2] = u56
                [3] = u57
            --]]
			u55(u56, u57)
		end)
		u18.OnUpdateDisabled:Connect(function() --[[Anonymous function at line 191]]
            --[[
            Upvalues:
                [1] = u55
                [2] = u56
                [3] = u57
            --]]
			u55(u56, u57)
		end)
	end)
	u21:GetAttributeChangedSignal("TrapCount"):Connect(function() --[[Anonymous function at line 197]]
        --[[
        Upvalues:
            [1] = u24
            [2] = u55
            [3] = u56
            [4] = u57
        --]]
		if u24 then
			u55(u56, u57)
		end
	end)
end
return v31