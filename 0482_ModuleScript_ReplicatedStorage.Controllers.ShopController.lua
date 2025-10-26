--[[
  Extracted from: ReplicatedStorage.Controllers.ShopController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
game:GetService("MarketplaceService")
local v3 = v_u_1:WaitForChild("Controllers")
local v_u_4 = require(v3.InterfaceController)
local v5 = v_u_1:WaitForChild("Packages")
local v_u_6 = require(v_u_1.Packages.Gradients)
local v_u_7 = require(v5.Synchronizer)
local v_u_8 = require(v5.Observers)
local v_u_9 = require(v5.FFlags)
local v10 = require(v5.Signal)
local v_u_11 = require(v5.Timer)
local v_u_12 = require(v5.Trove)
local v13 = require(v5.Net)
local v14 = v_u_1:WaitForChild("Classes")
local v_u_15 = require(v14.AnimatedButton)
local v16 = v_u_1:WaitForChild("Utils")
local v_u_17 = require(v16.NumberUtils)
local v_u_18 = require(v16.TimeUtils)
local v19 = v_u_1:WaitForChild("Shared")
local v_u_20 = require(v19.Animals)
local v_u_21 = require(v19.Marketplace)
require(v19.Updates)
local v_u_22 = require(v19.Policy)
local v23 = v_u_1:WaitForChild("Datas")
local v_u_24 = require(v23.ServerLuck)
local v_u_25 = require(v23.LuckyBlocks)
local v_u_26 = require(v23.Mutations)
local v_u_27 = require(v23.Shop)
local v_u_28 = v_u_2.LocalPlayer
local v29 = v_u_28.PlayerGui
local v_u_30 = v29:WaitForChild("Shop").Shop
local v_u_31 = v29:WaitForChild("GiftPlayer").GiftPlayer
local v_u_32 = v_u_31:WaitForChild("Header"):WaitForChild("Close")
local v_u_33 = v_u_31:WaitForChild("Main"):WaitForChild("List")
local v_u_34 = v_u_33:WaitForChild("Template")
local v35 = v_u_30.GiftPlayerSelect
local v_u_36 = v35:WaitForChild("GiftButton")
local v_u_37 = v_u_36:WaitForChild("Txt")
local v_u_38 = v35:WaitForChild("PlayerSelected")
local v_u_39 = v_u_38:WaitForChild("PlayerImage"):WaitForChild("Headshot")
local v_u_40 = v_u_38:WaitForChild("PlayerName")
local v_u_41 = v13:RemoteEvent("ShopService/Purchase")
local v_u_42 = v_u_11.new(300)
local v_u_43 = nil
local v_u_44 = v10.new()
local v_u_45 = nil
local v46 = {}
local function v_u_78()
	-- upvalues: (copy) v_u_30, (copy) v_u_22, (copy) v_u_2, (copy) v_u_9, (copy) v_u_18, (copy) v_u_25, (copy) v_u_12, (copy) v_u_1, (copy) v_u_20, (ref) v_u_45, (copy) v_u_26, (copy) v_u_15, (copy) v_u_41, (ref) v_u_43, (copy) v_u_21, (copy) v_u_17
	local v47 = v_u_30.Content.List.LuckyBlocksList
	local v_u_48 = v_u_30.Content.List.LuckyBlocks
	v47.Visible = false
	v_u_48.Visible = false
	local v49 = v_u_22.getPolicy(v_u_2.LocalPlayer)
	if v49 and not v49.ArePaidRandomItemsRestricted then
		v47.Visible = true
		v_u_48.Visible = true
		task.spawn(function()
			-- upvalues: (ref) v_u_9, (copy) v_u_48, (ref) v_u_18
			while true do
				local v50 = workspace:GetServerTimeNow()
				local v51 = v_u_9:GetInstant("LuckyBlockEndTimer", 1753545600) - v50
				v_u_48.Text = v51 <= 0 and "LUCKY BLOCKS" or ("LUCKY BLOCKS (<font color=\"#ffff00\">%*</font>)"):format((v_u_18:E(v51)))
				task.wait(1)
			end
		end)
		for _, v_u_52 in v47:GetChildren() do
			local v_u_53 = v_u_25[v_u_52.Name]
			if v_u_53 then
				local v_u_54 = v_u_53.ProductId
				if v_u_54 then
					local v_u_55 = v_u_12.new()
					local v_u_56 = nil
					local function v_u_68(p57)
						-- upvalues: (copy) v_u_52, (ref) v_u_56, (ref) v_u_1, (copy) v_u_53, (ref) v_u_20, (copy) v_u_55
						v_u_52.Odds.Visible = p57
						if p57 == v_u_56 then
							return
						else
							v_u_56 = p57
							if p57 then
								local v58 = v_u_1:GetAttribute("GalaxyEvent") and "Galaxy" or nil
								local v59 = {}
								for v60, v61 in v_u_53.Animals do
									table.insert(v59, {
										["animal"] = v60,
										["chance"] = v61
									})
								end
								table.sort(v59, function(p62, p63)
									return p63.chance < p62.chance
								end)
								for v64 = 1, 4 do
									local v65 = v_u_52.Odds:FindFirstChild((tostring(v64)))
									if v65 then
										local v66 = v59[v64]
										if v66 then
											local v67 = v_u_20:AttachOnViewport(v66.animal, v65, true, v58)
											if v67 then
												v_u_55:Add(v67)
											end
											v65.Chance.Text = ("%*%%"):format(v66.chance)
											v65.Visible = true
										else
											v65.Visible = false
										end
									end
								end
							else
								v_u_55:Clean()
							end
						end
					end
					local v_u_69 = v_u_12.new()
					local function v_u_73()
						-- upvalues: (copy) v_u_69, (ref) v_u_45, (ref) v_u_1, (ref) v_u_26, (copy) v_u_52, (ref) v_u_20
						v_u_69:Destroy()
						if v_u_45:IsOpened() then
							local v70 = v_u_1:GetAttribute("GalaxyEvent") and "Galaxy" or nil
							local v71
							if v70 then
								v71 = v_u_26[v70]
							else
								v71 = v70
							end
							if v71 then
								v_u_52.Mutation.Text = v71.DisplayWithRichText
								v_u_52.Mutation.Visible = true
							else
								v_u_52.Mutation.Visible = nil
							end
							local v72 = v_u_20:AttachOnViewport(v_u_52.Name, v_u_52.IconViewport, true, v70)
							if v72 then
								v_u_69:Add(v72)
							end
						end
					end
					task.spawn(v_u_73)
					v_u_45.OnClose:Connect(function()
						-- upvalues: (copy) v_u_68, (copy) v_u_73
						v_u_68(false)
						v_u_73()
					end)
					v_u_45.OnOpen:Connect(function()
						-- upvalues: (copy) v_u_68, (copy) v_u_73
						v_u_68(true)
						v_u_73()
					end)
					v_u_1:GetAttributeChangedSignal("GalaxyEvent"):Connect(function()
						-- upvalues: (copy) v_u_73, (copy) v_u_52, (copy) v_u_68
						task.spawn(v_u_73)
						if v_u_52.Odds.Visible then
							v_u_68(false)
							v_u_68(true)
						end
					end)
					local v74 = v_u_15.new(v_u_52.Buy)
					v74:Animate()
					v74.OnActivated:Connect(function()
						-- upvalues: (ref) v_u_41, (copy) v_u_54, (ref) v_u_43
						v_u_41:FireServer(v_u_54, v_u_43)
					end)
					task.spawn(function()
						-- upvalues: (ref) v_u_21, (copy) v_u_54, (copy) v_u_52, (ref) v_u_17
						local v75 = v_u_21:GetProductInfo(v_u_54, "Product")
						local v76 = v_u_52.Buy.Price
						local v77 = v75.PriceInRobux
						v76.Text = ("<font weight=\"100\">%*</font>%*"):format("\238\128\130", v77 == 999999999 and "???" or v_u_17:Comma(v77))
					end)
				end
			end
		end
	end
end
local function v_u_85(p_u_79)
	-- upvalues: (copy) v_u_28, (copy) v_u_34, (copy) v_u_2, (copy) v_u_15, (ref) v_u_43, (copy) v_u_31, (copy) v_u_37, (copy) v_u_38, (copy) v_u_40, (copy) v_u_39, (copy) v_u_44, (copy) v_u_33
	if p_u_79 ~= v_u_28 then
		local v80 = v_u_34:Clone()
		v80.Name = p_u_79.Name
		v80.PlayerName.Text = p_u_79.Name
		local v81 = v80.PlayerImage.Headshot
		local v_u_82 = ""
		if pcall(function()
				-- upvalues: (ref) v_u_82, (ref) v_u_2, (copy) p_u_79
				v_u_82 = v_u_2:GetUserThumbnailAsync(p_u_79.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end) then
			v81.Image = v_u_82
		end
		local v83 = v80.Gift
		local v84 = v_u_15.new(v83)
		v84:Animate()
		v84.OnActivated:Connect(function()
			-- upvalues: (ref) v_u_43, (copy) p_u_79, (ref) v_u_31, (ref) v_u_37, (ref) v_u_38, (ref) v_u_40, (ref) v_u_39, (ref) v_u_82, (ref) v_u_44
			v_u_43 = p_u_79.UserId
			v_u_31.Visible = false
			v_u_37.Text = "Back"
			v_u_38.Visible = true
			v_u_40.Text = "@" .. p_u_79.Name
			v_u_39.Image = v_u_82
			v_u_44:Fire(true)
		end)
		v80.Visible = true
		v80.Parent = v_u_33
	end
end
function v46.Start(_)
	-- upvalues: (ref) v_u_45, (copy) v_u_4, (copy) v_u_30, (copy) v_u_7, (copy) v_u_28, (copy) v_u_8, (copy) v_u_27, (copy) v_u_17, (copy) v_u_21, (copy) v_u_15, (copy) v_u_41, (ref) v_u_43, (copy) v_u_42, (copy) v_u_44, (copy) v_u_6, (copy) v_u_24, (copy) v_u_36, (copy) v_u_38, (copy) v_u_37, (copy) v_u_31, (copy) v_u_32, (copy) v_u_18, (copy) v_u_11, (copy) v_u_78, (copy) v_u_2, (copy) v_u_85, (copy) v_u_33
	v_u_45 = v_u_4:Register("Shop", v_u_30, "TopQuint")
	v_u_45:AttachCloseButton(v_u_30.Header.Close)
	v_u_45:Close()
	v_u_7:WaitAndCall(v_u_28, function(p_u_86)
		-- upvalues: (ref) v_u_8, (ref) v_u_27, (ref) v_u_17, (ref) v_u_21, (ref) v_u_15, (ref) v_u_41, (ref) v_u_43, (ref) v_u_42, (ref) v_u_44, (ref) v_u_6, (ref) v_u_24
		v_u_8.observeTag("CashProduct", function(p87)
			-- upvalues: (ref) v_u_27, (copy) p_u_86, (ref) v_u_17, (ref) v_u_21, (ref) v_u_15, (ref) v_u_41, (ref) v_u_43, (ref) v_u_42
			local v88 = p87.Name
			local v_u_89 = tonumber(v88)
			local v_u_90 = v_u_27[v_u_89]
			if v_u_90 then
				local v_u_91 = p87:WaitForChild("Buy", 5)
				local v_u_92 = p87:WaitForChild("Icon", 5)
				local v_u_93 = p87:WaitForChild("Amount", 5)
				local function v96()
					-- upvalues: (copy) v_u_93, (copy) v_u_90, (ref) p_u_86, (ref) v_u_17
					if v_u_93 then
						local v94 = v_u_90.Value or 0
						local v95 = p_u_86:Get("Rebirth") or 0
						if v95 > 0 then
							v94 = v94 * (v95 <= 1 and 1.5 or v95)
						end
						v_u_93.Text = ("$%*"):format((v_u_17:Comma(v94)))
					end
				end
				local function v_u_101()
					-- upvalues: (ref) v_u_21, (copy) v_u_89, (copy) v_u_91, (ref) v_u_17, (copy) v_u_92
					local v97 = v_u_21:GetProductInfo(v_u_89, "Product")
					if v_u_91 then
						local v98 = v_u_91.Txt
						local v99
						if v97.PriceInRobux == nil then
							v99 = "Failed to load!"
						else
							local v100 = v97.PriceInRobux
							v99 = ("%*%*"):format("\238\128\130", v100 == 999999999 and "???" or v_u_17:Comma(v100)) or "Failed to load!"
						end
						v98.Text = v99
					end
					if v_u_92 and v97.Icon then
						v_u_92.ScaleType = Enum.ScaleType.Fit
						v_u_92.Image = v97.Icon
					end
				end
				v_u_101()
				p_u_86:OnChanged("Rebirth", v96, true)
				local v102 = v_u_15.new(v_u_91)
				v102:Animate()
				v102.OnActivated:Connect(function()
					-- upvalues: (ref) v_u_41, (copy) v_u_89, (ref) v_u_43
					v_u_41:FireServer(v_u_89, v_u_43)
				end)
				v_u_42.Tick:Connect(function()
					-- upvalues: (copy) v_u_101
					v_u_101()
				end)
			end
		end)
		v_u_8.observeTag("ItemProduct", function(p103)
			-- upvalues: (ref) v_u_27, (ref) v_u_21, (ref) v_u_17, (ref) v_u_44, (ref) v_u_42, (copy) p_u_86, (ref) v_u_15, (ref) v_u_41, (ref) v_u_43
			local v104 = p103.Name
			local v_u_105 = tonumber(v104)
			local v_u_106 = v_u_27[v_u_105]
			if v_u_106 then
				local v107 = p103:WaitForChild("Buy", 5)
				local v_u_108
				if v107 then
					v_u_108 = v107:WaitForChild("Price", 5)
				else
					v_u_108 = v107
				end
				local v_u_109 = p103:WaitForChild("Icon", 5)
				local v_u_110 = false
				local v_u_111 = false
				local function v_u_116()
					-- upvalues: (ref) v_u_21, (copy) v_u_105, (copy) v_u_108, (ref) v_u_110, (ref) v_u_111, (ref) v_u_17, (copy) v_u_109
					local v112 = v_u_21:GetProductInfo(v_u_105, "Product")
					if v_u_108 and (v_u_110 == false or v_u_111 == true) then
						local v113 = v_u_108
						local v114
						if v112.PriceInRobux == nil then
							v114 = "Failed to load!"
						else
							local v115 = v112.PriceInRobux
							v114 = ("%*%*"):format("\238\128\130", v115 == 999999999 and "???" or v_u_17:Comma(v115)) or "Failed to load!"
						end
						v113.Text = v114
					end
					if v112.Icon and v_u_109 then
						v_u_109.ScaleType = Enum.ScaleType.Fit
						v_u_109.Image = v112.Icon
					end
				end
				v_u_44:Connect(function(p117)
					-- upvalues: (ref) v_u_111, (ref) v_u_110, (copy) v_u_108, (copy) v_u_116
					v_u_111 = p117
					if p117 or not v_u_110 then
						v_u_116()
					else
						v_u_110 = true
						v_u_108.Text = "Owned"
					end
				end)
				v_u_42.Tick:Connect(function()
					-- upvalues: (ref) v_u_110, (copy) v_u_116
					if v_u_110 == false then
						v_u_116()
					end
				end)
				p_u_86:OnDictionaryInserted("Items", function(_, p118)
					-- upvalues: (copy) v_u_106, (ref) v_u_110, (copy) v_u_108
					if p118 == v_u_106.Display then
						v_u_110 = true
						v_u_108.Text = "Owned"
					end
				end)
				if p_u_86:Get((("Items.%*"):format(v_u_106.Display))) == true then
					v_u_110 = true
					v_u_108.Text = "Owned"
				end
				v_u_116()
				local v119 = v_u_15.new(v107)
				v119:Animate()
				v119.OnActivated:Connect(function()
					-- upvalues: (ref) v_u_41, (copy) v_u_105, (ref) v_u_43
					v_u_41:FireServer(v_u_105, v_u_43)
				end)
			end
		end)
		v_u_8.observeTag("GamepassProduct", function(p_u_120)
			-- upvalues: (ref) v_u_27, (ref) v_u_21, (ref) v_u_17, (ref) v_u_44, (ref) v_u_42, (copy) p_u_86, (ref) v_u_15, (ref) v_u_43, (ref) v_u_41
			local v121 = p_u_120.Name
			local v_u_122 = tonumber(v121)
			local v_u_123 = v_u_27[v_u_122]
			if v_u_123 then
				local v124 = p_u_120:WaitForChild("Buy", 5)
				local v_u_125
				if v124 then
					v_u_125 = v124:WaitForChild("Price", 5)
				else
					v_u_125 = v124
				end
				p_u_120:WaitForChild("Icon", 5)
				local v_u_126 = false
				local v_u_127 = false
				local function v_u_132()
					-- upvalues: (ref) v_u_127, (ref) v_u_21, (copy) p_u_120, (copy) v_u_122, (copy) v_u_125, (ref) v_u_126, (ref) v_u_17
					local v128 = v_u_127 == true and v_u_21:GetProductInfo(p_u_120:GetAttribute("ProductId"), "Product") or v_u_21:GetProductInfo(v_u_122, "Gamepass")
					if v_u_125 and (v_u_126 == false or v_u_127) then
						local v129 = v_u_125
						local v130
						if v128.PriceInRobux == nil then
							v130 = "Failed to load!"
						else
							local v131 = v128.PriceInRobux
							v130 = ("%*%*"):format("\238\128\130", v131 == 999999999 and "???" or v_u_17:Comma(v131)) or "Failed to load!"
						end
						v129.Text = v130
					end
				end
				v_u_44:Connect(function(p133)
					-- upvalues: (ref) v_u_127, (ref) v_u_126, (copy) v_u_125, (copy) v_u_132
					v_u_127 = p133
					if p133 or not v_u_126 then
						v_u_132()
					else
						v_u_126 = true
						v_u_125.Text = "Owned"
					end
				end)
				v_u_42.Tick:Connect(function()
					-- upvalues: (ref) v_u_126, (copy) v_u_132
					if v_u_126 == false then
						v_u_132()
					end
				end)
				p_u_86:OnDictionaryInserted("Gamepass", function(_, p134)
					-- upvalues: (copy) v_u_123, (ref) v_u_126, (copy) v_u_125
					if p134 == v_u_123.Display then
						v_u_126 = true
						v_u_125.Text = "Owned"
					end
				end)
				if p_u_86:Get((("Gamepass.%*"):format(v_u_123.Display))) == true then
					v_u_126 = true
					v_u_125.Text = "Owned"
				end
				v_u_132()
				local v135 = v_u_15.new(v124)
				v135:Animate()
				v135.OnActivated:Connect(function()
					-- upvalues: (ref) v_u_43, (copy) p_u_120, (ref) v_u_41, (copy) v_u_122
					if v_u_43 then
						v_u_41:FireServer(p_u_120:GetAttribute("ProductId"), v_u_43)
					else
						v_u_41:FireServer(v_u_122, v_u_43)
					end
				end)
			end
		end)
		v_u_8.observeTag("StarterPack", function(p_u_136)
			-- upvalues: (ref) v_u_27, (copy) p_u_86, (ref) v_u_21, (ref) v_u_17, (ref) v_u_44, (ref) v_u_42, (ref) v_u_15, (ref) v_u_41, (ref) v_u_43
			local v_u_137 = v_u_27[3290334159]
			if v_u_137 then
				local v138 = p_u_136:WaitForChild("Buy", 5)
				local v_u_139
				if v138 then
					v_u_139 = v138:WaitForChild("Price", 5)
				else
					v_u_139 = v138
				end
				local v_u_140 = false
				local v_u_141 = false
				local function v_u_143()
					-- upvalues: (copy) v_u_137, (ref) p_u_86, (ref) v_u_141, (copy) p_u_136
					for _, v142 in v_u_137.Rewards.Items do
						if p_u_86:Get("Items." .. v142) == true and v_u_141 == false then
							p_u_136.Visible = false
							return
						end
					end
					p_u_136.Visible = true
				end
				v_u_44:Connect(function(p144)
					-- upvalues: (ref) v_u_141, (ref) v_u_140, (copy) v_u_139, (ref) v_u_21, (ref) v_u_17, (copy) v_u_143
					v_u_141 = p144
					if p144 or not v_u_140 then
						local v145 = v_u_21:GetProductInfo(3290334159, "Product")
						if v_u_139 and (v_u_140 == false or v_u_141 == true) then
							local v146 = v_u_139
							local v147
							if v145.PriceInRobux == nil then
								v147 = "Failed to load!"
							else
								local v148 = v145.PriceInRobux
								v147 = ("%*%*"):format("\238\128\130", v148 == 999999999 and "???" or v_u_17:Comma(v148)) or "Failed to load!"
							end
							v146.Text = v147
						end
					else
						v_u_140 = true
						v_u_139.Text = "Owned"
					end
					v_u_143()
				end)
				v_u_42.Tick:Connect(function()
					-- upvalues: (ref) v_u_140, (ref) v_u_21, (copy) v_u_139, (ref) v_u_141, (ref) v_u_17
					if v_u_140 == false then
						local v149 = v_u_21:GetProductInfo(3290334159, "Product")
						if v_u_139 and (v_u_140 == false or v_u_141 == true) then
							local v150 = v_u_139
							local v151
							if v149.PriceInRobux == nil then
								v151 = "Failed to load!"
							else
								local v152 = v149.PriceInRobux
								v151 = ("%*%*"):format("\238\128\130", v152 == 999999999 and "???" or v_u_17:Comma(v152)) or "Failed to load!"
							end
							v150.Text = v151
						end
					end
				end)
				v_u_143()
				p_u_86:OnDictionaryInserted("Items", v_u_143)
				local v153 = v_u_21:GetProductInfo(3290334159, "Product")
				if v_u_139 and (v_u_140 == false or v_u_141 == true) then
					local v154
					if v153.PriceInRobux == nil then
						v154 = "Failed to load!"
					else
						local v155 = v153.PriceInRobux
						v154 = ("%*%*"):format("\238\128\130", v155 == 999999999 and "???" or v_u_17:Comma(v155)) or "Failed to load!"
					end
					v_u_139.Text = v154
				end
				local v156 = v_u_15.new(v138)
				v156:Animate()
				v156.OnActivated:Connect(function()
					-- upvalues: (ref) v_u_41, (ref) v_u_43
					v_u_41:FireServer(3290334159, v_u_43)
				end)
			end
		end)
		v_u_8.observeTag("RainbowText", function(p157)
			-- upvalues: (ref) v_u_6
			return v_u_6.apply(p157, "Rainbow")
		end)
		v_u_8.observeTag("ZebraText", function(p158)
			-- upvalues: (ref) v_u_6
			return v_u_6.apply(p158, "Zebra")
		end)
		v_u_42:Start();
		(function(p159)
			-- upvalues: (ref) v_u_21
			for _, v160 in p159 do
				task.defer(v_u_21.GetProductInfo, v_u_21, v160, "Product")
			end
		end)({ v_u_24[2].ProductId })
	end)
	local v161 = v_u_15.new(v_u_36)
	v161:Animate()
	v161.OnActivated:Connect(function()
		-- upvalues: (ref) v_u_43, (ref) v_u_38, (ref) v_u_37, (ref) v_u_44, (ref) v_u_31
		if v_u_43 then
			v_u_43 = nil
			v_u_38.Visible = false
			v_u_37.Text = "Gift Player"
			v_u_44:Fire(false)
		else
			v_u_31.Visible = not v_u_31.Visible
		end
	end)
	local v162 = v_u_15.new(v_u_32)
	v162:Animate()
	v162.OnActivated:Connect(function()
		-- upvalues: (ref) v_u_31, (ref) v_u_44
		v_u_31.Visible = false
		v_u_44:Fire(false)
	end)
	local v_u_163 = v_u_30.Content.List.ServerLuck
	v_u_7:WaitAndCall("ServerLuck", function(p_u_164)
		-- upvalues: (copy) v_u_163, (ref) v_u_18, (ref) v_u_24, (ref) v_u_21, (ref) v_u_17, (ref) v_u_11, (ref) v_u_15, (ref) v_u_41
		local v_u_165 = nil
		local v_u_166 = os.clock()
		local function v179()
			-- upvalues: (ref) v_u_166, (ref) v_u_165, (copy) p_u_164, (ref) v_u_163, (ref) v_u_18, (ref) v_u_24, (ref) v_u_21, (ref) v_u_17
			if os.clock() - v_u_166 >= 300 then
				v_u_166 = os.clock()
				v_u_165 = nil
			end
			local v167 = p_u_164:Get("EndTime")
			if v167 then
				local v168 = v167 - workspace:GetServerTimeNow()
				local v169 = math.floor(v168)
				local v170 = math.clamp(v169, 0, (1 / 0))
				if v170 <= 0 then
					v167 = nil
					v_u_165 = nil
				else
					v_u_163.Frame.Timer.Text = v_u_18:A(v170)
				end
			end
			v_u_163.Frame.Timer.Visible = v167 ~= nil
			local v171 = p_u_164:Get("Index") or 0
			local v172 = #v_u_24
			local v173 = v171 + 1
			local v174 = math.min(v173, v172)
			if v171 ~= v_u_165 then
				v_u_165 = v171
				local v175 = v172 <= v171 and "<font color=\"#FFFF00\">MAX</font>" or ("<font color=\"#FFFFFF\">%dx</font> &gt; <font color=\"#FFFF00\">%dx</font>"):format(v171 == 0 and 1 or v_u_24[v171].Multiplier, v_u_24[v174].Multiplier)
				local v176 = v_u_21:GetProductInfo(v_u_24[v174].ProductId, "Product")
				local v177 = v_u_163.Frame.Buy.Price
				local v178 = v176.PriceInRobux
				v177.Text = ("%*%*"):format("\238\128\130", v178 == 999999999 and "???" or v_u_17:Comma(v178))
				v_u_163.Frame.LuckVector.Image = v176.Icon
				v_u_163.Frame.Pattern.Image = v176.Icon
				v_u_163.Frame.Amount.Text = v175
			end
		end
		p_u_164:OnChanged("Index", v179)
		p_u_164:OnChanged("EndTime", v179)
		v_u_11.Simple(1, v179)
		local v180 = v_u_15.new(v_u_163.Frame.Buy)
		v180:Animate()
		v180.OnActivated:Connect(function()
			-- upvalues: (copy) p_u_164, (ref) v_u_24, (ref) v_u_41
			local v181 = p_u_164:Get("Index") or 0
			local v182 = #v_u_24
			local v183 = v181 + 1
			v_u_41:FireServer(v_u_24[math.min(v183, v182)].ProductId)
		end)
	end)
	v_u_78()
	for _, v184 in v_u_2:GetPlayers() do
		v_u_85(v184)
	end
	v_u_2.PlayerAdded:Connect(function(p185)
		-- upvalues: (ref) v_u_85
		v_u_85(p185)
	end)
	v_u_2.PlayerRemoving:Connect(function(p186)
		-- upvalues: (ref) v_u_33
		local v187 = v_u_33:FindFirstChild(p186.Name)
		if v187 then
			v187:Destroy()
		end
	end)
	for _, v188 in v_u_30.Header.Main:GetChildren() do
		if v188:IsA("ImageButton") then
			local v_u_189 = v_u_30.Content.List:FindFirstChild(v188.Name)
			if v_u_189 then
				local v190 = v_u_15.new(v188)
				v190:Animate()
				v190.OnActivated:Connect(function()
					-- upvalues: (ref) v_u_30, (copy) v_u_189
					local v191 = v_u_30.Content.List
					local v192 = v_u_189.AbsolutePosition.Y - v191.AbsolutePosition.Y + v191.CanvasPosition.Y
					v191.CanvasPosition = Vector2.new(v191.CanvasPosition.X, v192)
				end)
			end
		end
	end
end
return v46