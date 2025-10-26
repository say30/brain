--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.help
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "help";
	Aliases = {"commands", "cmds"};
	Description = "Shows all available admin commands";
	Group = "CustomAdmin";
	Args = {};

	Run = function(context)
		local commands = {
			{name = "help", aliases = "commands, cmds", description = "Shows this help menu"},
			{name = "AddCoins", aliases = "givecoins, addmoney", description = "Adds coins to a player"},
			{name = "RemoveCoins", aliases = "takecoins, removemoney", description = "Removes coins from a player"},
			{name = "SpawnRoadBrainrot", aliases = "spawnroad, roadspawn", description = "Spawns a specific animal on the road with optional mutation"},
			{name = "AddBrainrot", aliases = "givebrainrot, addanimal", description = "Adds any animal to a player's plot"},
			{name = "ServerLuck", aliases = "Serverluck, Serverluck", description = "Adds luck to ur server"},
			{name = "CreateMerch", aliases = "CreateMerch, MerchCreate", description = "Create a merch!"},--wana go talk on intsta i got phone now
			{name = "RemoveBrainrot", aliases = "deletebrainrot, takebrainrot", description = "Removes brainrot from a player"},
			--{name = "GiveTool", aliases = "tool", description = "Gives a tool to a player"}
		}

		local helpText = "🎯 Available Admin Commands:\n\n"

		for _, cmd in ipairs(commands) do
			helpText = helpText .. string.format(
				"• %s (%s)\n  %s\n\n",
				cmd.name,
				cmd.aliases,
				cmd.description
			)
		end

		helpText = helpText .. "💡 Tip: Use F2 to open the command console\n"
		helpText = helpText .. "📝 Note: Some commands may require additional arguments"

		return helpText
	end;
} 