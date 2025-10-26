--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addlimitedstock
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "addlimitedstock";
	Aliases = {"addstock", "limitedstock"};
	Description = "Adds stock to limited pets (1, 2, or 3)";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "number";
			Name = "petNumber";
			Description = "Which limited pet (1, 2, or 3)";
		},
		{
			Type = "number";
			Name = "amount";
			Description = "Amount of stock to add";
		},
	};
}