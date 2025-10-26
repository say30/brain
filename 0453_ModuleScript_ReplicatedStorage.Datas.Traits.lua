--[[
  Extracted from: ReplicatedStorage.Datas.Traits
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:27:34
-- Luau version 6, Types version 3
-- Time taken: 0.003466 seconds

local module = {
	Taco = {
		Display = "Taco";
		DisplayWithRichText = "<font color=\"#FFDE59\">Taco</font>";
		Icon = "rbxassetid://89041930759464";
		Color = Color3.fromRGB(255, 222, 89);
		MultiplierModifier = 2;
	};
	Nyan = {
		Display = "Nyan";
		DisplayWithRichText = "<font color=\"#EE59FF\">Nyan</font>";
		Icon = "rbxassetid://104229924295526";
		Color = Color3.fromRGB(238, 89, 255);
		MultiplierModifier = 5;
	};
	Galactic = {
		Display = "Galactic";
		DisplayWithRichText = "<font color=\"#7D59FF\">Galactic</font>";
		Icon = "rbxassetid://99181785766598";
		Color = Color3.fromRGB(125, 89, 255);
		MultiplierModifier = 3;
	};
	Fireworks = {
		Display = "Fireworks";
		DisplayWithRichText = "<font color=\"#FF2828\">Fireworks</font>";
		Icon = "rbxassetid://121100427764858";
		Color = Color3.fromRGB(255, 40, 40);
		MultiplierModifier = 5;
	};
	Zombie = {
		Display = "Zombie";
		DisplayWithRichText = "<font color=\"#4aff47\">Zombie</font>";
		Icon = "rbxassetid://110723387483939";
		Color = Color3.fromRGB(74, 255, 71);
		MultiplierModifier = 4;
	};
	Claws = {
		Display = "Claws";
		DisplayWithRichText = "<font color=\"#eb391a\">Crab Claws</font>";
		Icon = "rbxassetid://104964195846833";
		Color = Color3.fromRGB(235, 57, 26);
		MultiplierModifier = 4;
		Modify = function(arg1, arg2, arg3) -- Line 66, Named "Modify"
			local Size = arg3:GetAttribute("Size")
			if not Size then
				Size = arg1.Size
			end
			arg1.Size = Size
		end;
	};
	Glitched = {
		Display = "Glitched";
		DisplayWithRichText = "<font color=\"#a75edf\">Glitch</font>";
		Icon = "rbxassetid://121332433272976";
		Color = Color3.fromRGB(167, 94, 223);
		MultiplierModifier = 4;
	};
	Bubblegum = {
		Display = "Bubblegum";
		DisplayWithRichText = "<font color=\"#f058fe\">Bubblegum</font>";
		Icon = "rbxassetid://100601425541874";
		Color = Color3.fromRGB(240, 88, 254);
		MultiplierModifier = 3;
	};
	Fire = {
		Display = "Fire";
		DisplayWithRichText = "<font color=\"#ffaa00\">Fire</font>";
		Icon = "rbxassetid://118283346037788";
		Color = Color3.fromRGB(255, 170, 0);
		MultiplierModifier = 5;
	};
	Wet = {
		Display = "Wet";
		DisplayWithRichText = "<font color=\"#1F85DE\">Wet</font>";
		Icon = "rbxassetid://78474194088770";
		Color = Color3.fromRGB(30, 130, 220);
		MultiplierModifier = 1.5;
	};
	Snowy = {
		Display = "Snowy";
		DisplayWithRichText = "<font color=\"#FFFFFF\">Snowy</font>";
		Icon = "rbxassetid://83627475909869";
		Color = Color3.fromRGB(255, 255, 255);
		MultiplierModifier = 2;
	};
	Cometstruck = {
		Display = "Comet-struck";
		DisplayWithRichText = "<font color=\"#ae1fde\">Comet-struck</font>";
		Icon = "rbxassetid://127455440418221";
		Color = Color3.fromRGB(175, 30, 220);
		MultiplierModifier = 2.5;
	};
}
local tbl = {
	Display = "Explosive";
	DisplayWithRichText = "<font color=\"#ff9d26\">Explosive</font>";
	Icon = "rbxassetid://97725744252608";
	Color = Color3.fromRGB(255, 170, 0);
	MultiplierModifier = 3;
}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local function ModifyVFX(arg1) -- Line 125
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	require(ReplicatedStorage_upvr.Shared.VFX).emitLoop(arg1, 4)
end
tbl.ModifyVFX = ModifyVFX
module.Explosive = tbl
module.Disco = {
	Display = "Disco";
	DisplayWithRichText = "<font color=\"#e863ff\">Disco</font>";
	Icon = "rbxassetid://82620342632406";
	Color = Color3.fromRGB(232, 99, 255);
	MultiplierModifier = 4;
}
module["10B"] = {
	Display = "10B";
	DisplayWithRichText = "<font color=\"#FF2828\">10B</font>";
	Icon = "rbxassetid://134655415681926";
	Color = Color3.fromRGB(255, 40, 40);
	MultiplierModifier = 3;
}
module["Shark Fin"] = {
	Display = "Shark Fin";
	DisplayWithRichText = "<font color=\"#1F85DE\">Shark Fin</font>";
	Icon = "rbxassetid://104985313532149";
	Color = Color3.fromRGB(30, 130, 220);
	MultiplierModifier = 3;
}
module["Matteo Hat"] = {
	Display = "Matteo Hat";
	DisplayWithRichText = "<font color=\"#ff961d\">Matteo Hat</font>";
	Icon = "rbxassetid://115664804212096";
	Color = Color3.fromRGB(255, 150, 29);
	MultiplierModifier = 3.5;
}
module.Brazil = {
	Display = "Brazil";
	DisplayWithRichText = "<font color=\"#00ff00\">Brazil</font>";
	Icon = "rbxassetid://75650816341229";
	Color = Color3.fromRGB(0, 255, 0);
	MultiplierModifier = 5;
}
module.Sleepy = {
	Display = "Sleepy";
	DisplayWithRichText = "<font color=\"#2747ff\">Sleepy</font>";
	Icon = "rbxassetid://115001117876534";
	Color = Color3.fromRGB(39, 71, 255);
	MultiplierModifier = 0;
}
module.Lightning = {
	Display = "Lightning";
	DisplayWithRichText = "<font color=\"#2747ff\">Lightning</font>";
	Icon = "rbxassetid://139729696247144";
	Color = Color3.fromRGB(0, 229, 255);
	MultiplierModifier = 5;
}
module.UFO = {
	Display = "UFO";
	DisplayWithRichText = "<font color=\"#00ff00\">UFO</font>";
	Icon = "rbxassetid://110910518481052";
	Color = Color3.fromRGB(0, 255, 0);
	MultiplierModifier = 2;
}
module.Spider = {
	Display = "Spider";
	DisplayWithRichText = "<font color=\"#fff\">Spider</font>";
	Icon = "rbxassetid://117478971325696";
	Color = Color3.fromRGB(255, 255, 255);
	MultiplierModifier = 3.5;
}
module.Strawberry = {
	Display = "Strawberry";
	DisplayWithRichText = "<font color=\"#ff5e5e\">Strawberry</font>";
	Icon = "rbxassetid://84731118566493";
	Color = Color3.fromRGB(255, 94, 94);
	MultiplierModifier = 7;
}
module.Paint = {
	Display = "Paint";
	DisplayWithRichText = "<font color=\"#ffc800\">Paint</font>";
	Icon = "rbxassetid://119591742504251";
	Color = Color3.fromRGB(255, 200, 0);
	MultiplierModifier = 5;
	ModifyVFX = function(arg1, arg2) -- Line 217, Named "ModifyVFX"
		arg1.Attachment.WorldPosition = arg2.Parent:GetPivot().Position
	end;
}
module.Skeleton = {
	Display = "Skeleton";
	DisplayWithRichText = "<font color=\"#fff\">Skeleton</font>";
	Icon = "rbxassetid://89591838221335";
	Color = Color3.fromRGB(255, 255, 255);
	MultiplierModifier = 3;
}
module.Sombrero = {
	Display = "Sombrero";
	DisplayWithRichText = "<font color=\"#fac711\">Sombrero</font>";
	Icon = "rbxassetid://95128039793845";
	Color = Color3.fromRGB(250, 199, 17);
	MultiplierModifier = 4;
}
module.Tie = {
	Display = "Tie";
	DisplayWithRichText = "<font color=\"#f00\">Tie</font>";
	Icon = "rbxassetid://103610037004911";
	Color = Color3.fromRGB(255, 0, 0);
	MultiplierModifier = 3.75;
}
module["Witch Hat"] = {
	Display = "Witch Hat";
	DisplayWithRichText = "<font color=\"#7f51cf\">Witch Hat</font>";
	Icon = "rbxassetid://123964048606874";
	Color = Color3.fromRGB(127, 81, 207);
	MultiplierModifier = 3;
}
module.Indonesia = {
	Display = "Indonesia";
	DisplayWithRichText = "<font color=\"#fb3d29\">Indonesia</font>";
	Icon = "rbxassetid://93350414974589";
	Color = Color3.fromRGB(251, 61, 41);
	MultiplierModifier = 4;
}
module.Meowl = {
	Display = "Meowl";
	DisplayWithRichText = "<font color=\"#ffffff\">Meowl</font>";
	Icon = "rbxassetid://114748221761549";
	Color = Color3.fromRGB(255, 255, 255);
	MultiplierModifier = 6;
}
return module