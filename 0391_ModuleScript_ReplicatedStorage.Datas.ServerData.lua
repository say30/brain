--[[
  Extracted from: ReplicatedStorage.Datas.ServerData
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: ServerData, time of decompilation: Sat Jul 12 14:22:08 2025 ]]
return {
    IsContentCreatorGame = function() --[[ Line: 6 ]] --[[ Name: IsContentCreatorGame ]]
		return game.GameId == 88009913207118;
    end, 
    IsDevGame = function() --[[ Line: 10 ]] --[[ Name: IsDevGame ]]
        return game.GameId == 7766605450;
    end, 
    IsProdGame = function() --[[ Line: 14 ]] --[[ Name: IsProdGame ]]
        return game.GameId == 7709344486;
    end
};