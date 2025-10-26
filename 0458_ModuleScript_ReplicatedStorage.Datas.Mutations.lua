--[[
  Extracted from: ReplicatedStorage.Datas.Mutations
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = {}
local v2 = {
	["DisplayText"] = "Gold",
	["DisplayWithRichText"] = "<font color=\"#FFDE59\">Gold</font>",
	["Order"] = 2,
	["ColorOrder"] = 2,
	["Weight"] = 7,
	["Modifier"] = 0.25,
	["MainColor"] = Color3.fromRGB(255, 222, 89)
}
local v3 = {
	{
		Color3.fromRGB(237, 178, 0),
		Color3.fromRGB(237, 194, 86),
		Color3.fromRGB(215, 111, 1),
		Color3.fromRGB(139, 74, 0),
		Color3.fromRGB(255, 164, 164)
	},
	{
		Color3.fromRGB(237, 178, 0),
		Color3.fromRGB(237, 194, 86),
		Color3.fromRGB(215, 111, 1),
		Color3.fromRGB(139, 74, 0),
		Color3.fromRGB(237, 194, 86),
		Color3.fromRGB(255, 251, 131),
		Color3.fromRGB(255, 178, 0),
		Color3.fromRGB(215, 111, 1)
	}
}
v2.Palettes = v3
v2.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(179, 107, 13),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(163, 98, 12),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(200, 150, 0),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(179, 107, 13)
}
v1.Gold = v2
local v4 = {
	["DisplayText"] = "Diamond",
	["DisplayWithRichText"] = "<font color=\"#25C4FE\">Diamond</font>",
	["Order"] = 3,
	["ColorOrder"] = 3,
	["Weight"] = 3,
	["Modifier"] = 0.5,
	["MainColor"] = Color3.fromRGB(37, 196, 254)
}
local v5 = {
	{
		Color3.fromRGB(37, 196, 254),
		Color3.fromRGB(116, 212, 254),
		Color3.fromRGB(28, 137, 254),
		Color3.fromRGB(21, 64, 254),
		Color3.fromRGB(160, 162, 254)
	},
	{
		Color3.fromRGB(37, 196, 254),
		Color3.fromRGB(116, 212, 254),
		Color3.fromRGB(28, 137, 254),
		Color3.fromRGB(21, 64, 254),
		Color3.fromRGB(116, 212, 254),
		Color3.fromRGB(116, 212, 254),
		Color3.fromRGB(37, 196, 254),
		Color3.fromRGB(28, 137, 254)
	}
}
v4.Palettes = v5
v4.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(25, 138, 175),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(13, 105, 172),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(28, 150, 194),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(25, 138, 175)
}
v1.Diamond = v4
local v6 = {
	["DisplayText"] = "Bloodrot",
	["DisplayWithRichText"] = "<font color=\"#8A3B3C\">Bloodrot</font>",
	["Modifier"] = 1,
	["MainColor"] = Color3.fromRGB(145, 0, 27)
}
local v7 = {
	{
		Color3.fromRGB(145, 0, 27),
		Color3.fromRGB(154, 94, 100),
		Color3.fromRGB(75, 0, 7),
		Color3.fromRGB(72, 0, 2),
		Color3.fromRGB(121, 112, 112)
	},
	{
		Color3.fromRGB(145, 0, 27),
		Color3.fromRGB(154, 94, 100),
		Color3.fromRGB(75, 0, 7),
		Color3.fromRGB(72, 0, 2),
		Color3.fromRGB(195, 98, 100),
		Color3.fromRGB(195, 98, 100),
		Color3.fromRGB(145, 0, 27),
		Color3.fromRGB(75, 0, 7)
	}
}
v6.Palettes = v7
v6.LimitedMutation = 0
v6.ShowInSettings = false
v1.Bloodrot = v6
local v8 = {
	["DisplayText"] = "Rainbow",
	["DisplayWithRichText"] = "<font color=\"#ff00fb\">Rainbow</font>",
	["Order"] = 4,
	["ColorOrder"] = 5,
	["GradientPreset"] = "Rainbow",
	["Weight"] = 0.2,
	["Modifier"] = 9,
	["MainColor"] = Color3.fromRGB(255, 0, 251)
}
local v9 = {
	{
		Color3.fromRGB(255, 0, 4),
		Color3.fromRGB(255, 0, 242),
		Color3.fromRGB(0, 132, 255),
		Color3.fromRGB(17, 255, 0),
		Color3.fromRGB(251, 255, 0)
	},
	{
		Color3.fromRGB(255, 0, 4),
		Color3.fromRGB(255, 0, 242),
		Color3.fromRGB(0, 132, 255),
		Color3.fromRGB(17, 255, 0),
		Color3.fromRGB(227, 225, 230),
		Color3.fromRGB(227, 225, 230),
		Color3.fromRGB(231, 64, 64),
		Color3.fromRGB(24, 49, 159)
	}
}
v8.Palettes = v9
v8.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(99, 95, 98),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(69, 71, 80),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(27, 42, 53),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(91, 93, 105)
}
v1.Rainbow = v8
local v10 = {
	["DisplayText"] = "Candy",
	["DisplayWithRichText"] = "<font color=\"#ff46f6\">Candy</font>",
	["Order"] = 5,
	["ColorOrder"] = 4,
	["Modifier"] = 3,
	["MainColor"] = Color3.fromRGB(255, 70, 246)
}
local v11 = {
	{
		Color3.fromRGB(255, 182, 255),
		Color3.fromRGB(255, 105, 180),
		Color3.fromRGB(255, 0, 251),
		Color3.fromRGB(200, 0, 180),
		Color3.fromRGB(255, 146, 246)
	},
	{
		Color3.fromRGB(255, 182, 255),
		Color3.fromRGB(255, 105, 180),
		Color3.fromRGB(255, 0, 251),
		Color3.fromRGB(200, 0, 180),
		Color3.fromRGB(255, 153, 253),
		Color3.fromRGB(255, 153, 253),
		Color3.fromRGB(239, 88, 239),
		Color3.fromRGB(158, 69, 158)
	}
}
v10.Palettes = v11
v10.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(255, 105, 180),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(177, 73, 125),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(99, 41, 70),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(255, 105, 180)
}
v10.LimitedMutation = 1753477200
v10.ShowInSettings = false
v1.Candy = v10
local v12 = {
	["DisplayText"] = "Lava",
	["DisplayWithRichText"] = "<font color=\"#ff7700\">Lava</font>",
	["Order"] = 5,
	["ColorOrder"] = 4,
	["Modifier"] = 5,
	["MainColor"] = Color3.fromRGB(255, 149, 0)
}
local v13 = {
	{
		Color3.fromRGB(255, 94, 0),
		Color3.fromRGB(232, 61, 18),
		Color3.fromRGB(230, 33, 15),
		Color3.fromRGB(255, 160, 0),
		Color3.fromRGB(255, 112, 112)
	},
	{
		Color3.fromRGB(255, 94, 0),
		Color3.fromRGB(232, 61, 18),
		Color3.fromRGB(230, 33, 15),
		Color3.fromRGB(255, 160, 0),
		Color3.fromRGB(255, 178, 0),
		Color3.fromRGB(237, 194, 86),
		Color3.fromRGB(145, 0, 27),
		Color3.fromRGB(75, 0, 7)
	}
}
v12.Palettes = v13
v12.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(62, 31, 15),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(230, 106, 17),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(120, 17, 8),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(255, 160, 0)
}
v12.LimitedMutation = 1755957600
v12.ShowInSettings = false
v1.Lava = v12
local v14 = {
	["DisplayText"] = "Galaxy",
	["DisplayWithRichText"] = "<font color=\"#aa3cff\">Galaxy</font>",
	["Order"] = 6,
	["ColorOrder"] = 4,
	["Modifier"] = 6,
	["MainColor"] = Color3.fromRGB(170, 60, 255)
}
local v15 = {
	{
		Color3.fromRGB(170, 65, 210),
		Color3.fromRGB(113, 0, 243),
		Color3.fromRGB(87, 0, 186),
		Color3.fromRGB(50, 20, 80),
		Color3.fromRGB(80, 80, 80)
	},
	{
		Color3.fromRGB(170, 65, 210),
		Color3.fromRGB(113, 0, 243),
		Color3.fromRGB(87, 0, 186),
		Color3.fromRGB(50, 20, 80),
		Color3.fromRGB(113, 0, 243),
		Color3.fromRGB(170, 65, 210),
		Color3.fromRGB(87, 0, 186),
		Color3.fromRGB(50, 20, 80)
	}
}
v14.Palettes = v15
v14.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(167, 79, 255),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(87, 0, 186),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(32, 12, 48),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(113, 0, 243)
}
v14.LimitedMutation = 1758394800
v1.Galaxy = v14

-- 🆕 YinYang added here
local v16 = {
	["DisplayText"] = "Yin Yang",
	["UseRichText"] = true,
	["DisplayWithRichText"] = "<stroke color=\"#fff\" thickness=\"2\"><font color=\"#000\">Yin</font></stroke> <stroke color=\"#000\" thickness=\"2\"><font color=\"#fff\">Yang</font></stroke>",
	["Order"] = 7,
	["ColorOrder"] = 5,
	["Modifier"] = 6.5,
	["MainColor"] = Color3.fromRGB(255, 255, 255)
}
local v17 = {
	{
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172),
		Color3.fromRGB(0, 0, 0)
	},
	{
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172),
		Color3.fromRGB(0, 0, 0)
	},
	{
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172)
	},
	{
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(172, 172, 172)
	},
	{
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172)
	},
	{
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0),
		Color3.fromRGB(172, 172, 172)
	}
}
v16.Palettes = v17
v16.BaseColors = {
	[Vector3.new(99, 95, 98)] = Color3.fromRGB(204, 204, 204),
	[Vector3.new(69, 71, 80)] = Color3.fromRGB(204, 204, 204),
	[Vector3.new(27, 42, 53)] = Color3.fromRGB(0, 0, 0),
	[Vector3.new(91, 93, 105)] = Color3.fromRGB(0, 0, 0),
	[Vector3.new(196, 40, 28)] = Color3.fromRGB(159, 161, 172),
	Ground = Color3.fromRGB(159, 161, 172)
}
v16.LimitedMutation = 1761418800
v1.YinYang = v16

return v1
