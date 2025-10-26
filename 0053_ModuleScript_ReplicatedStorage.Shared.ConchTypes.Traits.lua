--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Traits
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:28:19
-- Luau version 6, Types version 3
-- Time taken: 0.001101 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Traits_upvr = require(ReplicatedStorage.Datas.Traits)
local tbl = {}
for i in Traits_upvr do
	table.insert(tbl, i)
end
return require(ReplicatedStorage.Packages.Conch).register_type("Traits", {
	convert = function(arg1) -- Line 14, Named "convert"
		--[[ Upvalues[1]:
			[1]: Traits_upvr (readonly)
		]]
		if typeof(arg1) == "table" then
			local clone = table.clone(arg1)
			for i_2, v in clone do
				local tostring_result1_2 = tostring(v)
				if not Traits_upvr[tostring_result1_2] then
					error(`Trait {tostring_result1_2} not found`)
				end
				clone[i_2] = tostring_result1_2
			end
			return clone
		end
		local tostring_result1 = tostring(arg1)
		if not Traits_upvr[tostring_result1] then
			error(`Trait {tostring_result1} not found`)
		end
		return {tostring_result1}
	end;
	analysis = {
		kind = "argument";
		optional = false;
		name = "traits";
		type = "{ Trait }";
	};
})