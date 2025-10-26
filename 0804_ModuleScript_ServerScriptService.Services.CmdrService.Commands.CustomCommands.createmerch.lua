--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.createmerch
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "createmerch", 
	Aliases = {
		"cm"
	}, 
	Description = "Make a merch code!", 
	Group = "GameCommands", 
	Args = {
		{
			Type = "animalName", 
			Name = "petname", 
			Description = "The name of the pet to give."
		}, 
		{
			Type = "mutationName",
			Name = "petmutation", 
			Description = "Mutation of the pet.", 
			Optional = true
		}, 
	}
}