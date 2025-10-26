--[[
  Extracted from: Workspace.Foldernew.newdatas
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("RunService")
local v3 = v1:WaitForChild("Datas")
local v4 = require(v3.LuckyBlocks)
require(v3.Rarities)
local v5 = v1:WaitForChild("Shared")
local v_u_6 = require(v5.Updates)
local v7 = {
    ["Noobini Pizzanini"] = {
        ["DisplayName"] = "Noobini Pizzanini",
        ["Rarity"] = "Common",
        ["Price"] = 25,
        ["Generation"] = 1,
        ["RoadWeight"] = 100
    },
    ["Liril\195\172 Laril\195\160"] = {
        ["DisplayName"] = "Liril\195\172 Laril\195\160",
        ["Rarity"] = "Common",
        ["Price"] = 250,
        ["Generation"] = 3,
        ["RoadWeight"] = 55
    },
    ["Tim Cheese"] = {
        ["DisplayName"] = "Tim Cheese",
        ["Rarity"] = "Common",
        ["Price"] = 500,
        ["Generation"] = 5,
        ["RoadWeight"] = 50
    },
    ["Fluriflura"] = {
        ["DisplayName"] = "Fluriflura",
        ["Rarity"] = "Common",
        ["Price"] = 750,
        ["Generation"] = 7,
        ["RoadWeight"] = 45
    },
    ["Svinina Bombardino"] = {
        ["DisplayName"] = "Svinina Bombardino",
        ["Rarity"] = "Common",
        ["Price"] = 1250,
        ["Generation"] = 10,
        ["RoadWeight"] = 40
    },
    ["Talpa Di Fero"] = {
        ["DisplayName"] = "Talpa Di Fero",
        ["Rarity"] = "Common",
        ["Price"] = 1000,
        ["Generation"] = 9,
        ["RoadWeight"] = 43
    },
    ["Pipi Kiwi"] = {
        ["DisplayName"] = "Pipi Kiwi",
        ["Rarity"] = "Common",
        ["Price"] = 1500,
        ["Generation"] = 13,
        ["RoadWeight"] = 37
    },
    ["Pipi Corni"] = {
        ["DisplayName"] = "Pipi Corni",
        ["Rarity"] = "Common",
        ["Price"] = 1750,
        ["Generation"] = 14
    },
    ["Raccooni Jandelini"] = {
        ["DisplayName"] = "Raccooni Jandelini",
        ["Rarity"] = "Common",
        ["Price"] = 1350,
        ["Generation"] = 12,
        ["IgnoreIndexCounter"] = true
    },
    ["Trippi Troppi"] = {
        ["DisplayName"] = "Trippi Troppi",
        ["Rarity"] = "Rare",
        ["Price"] = 2000,
        ["Generation"] = 15,
        ["RoadWeight"] = 30
    },
    ["Tung Tung Tung Sahur"] = {
        ["DisplayName"] = "Tung Tung Tung Sahur",
        ["Rarity"] = "Rare",
        ["Price"] = 3000,
        ["Generation"] = 25,
        ["RoadWeight"] = 27
    },
    ["Gangster Footera"] = {
        ["DisplayName"] = "Gangster Footera",
        ["Rarity"] = "Rare",
        ["Price"] = 4000,
        ["Generation"] = 30,
        ["RoadWeight"] = 25
    },
    ["Boneca Ambalabu"] = {
        ["DisplayName"] = "Boneca Ambalabu",
        ["Rarity"] = "Rare",
        ["Price"] = 5000,
        ["Generation"] = 40,
        ["RoadWeight"] = 20
    },
    ["Ta Ta Ta Ta Sahur"] = {
        ["DisplayName"] = "Ta Ta Ta Ta Sahur",
        ["Rarity"] = "Rare",
        ["Price"] = 7500,
        ["Generation"] = 55,
        ["RoadWeight"] = 17
    },
    ["Tric Trac Baraboom"] = {
        ["DisplayName"] = "Tric Trac Baraboom",
        ["Rarity"] = "Rare",
        ["Price"] = 9000,
        ["Generation"] = 65,
        ["RoadWeight"] = 15
    },
    ["Bandito Bobritto"] = {
        ["DisplayName"] = "Bandito Bobritto",
        ["Rarity"] = "Rare",
        ["Price"] = 4500,
        ["Generation"] = 35,
        ["RoadWeight"] = 22.5
    },
    ["Cacto Hipopotamo"] = {
        ["DisplayName"] = "Cacto Hipopotamo",
        ["Rarity"] = "Rare",
        ["Price"] = 6500,
        ["Generation"] = 50,
        ["RoadWeight"] = 18.5
    },
    ["Pipi Avocado"] = {
        ["DisplayName"] = "Pipi Avocado",
        ["Rarity"] = "Rare",
        ["Price"] = 9500,
        ["Generation"] = 70
    },
    ["Cappuccino Assassino"] = {
        ["DisplayName"] = "Cappuccino Assassino",
        ["Rarity"] = "Epic",
        ["Price"] = 10000,
        ["Generation"] = 75,
        ["RoadWeight"] = 13
    },
    ["Brr Brr Patapim"] = {
        ["DisplayName"] = "Brr Brr Patapim",
        ["Rarity"] = "Epic",
        ["Price"] = 15000,
        ["Generation"] = 100,
        ["RoadWeight"] = 10
    },
    ["Trulimero Trulicina"] = {
        ["DisplayName"] = "Trulimero Trulicina",
        ["Rarity"] = "Epic",
        ["Price"] = 20000,
        ["Generation"] = 125,
        ["RoadWeight"] = 7
    },
    ["Bananita Dolphinita"] = {
        ["DisplayName"] = "Bananita Dolphinita",
        ["Rarity"] = "Epic",
        ["Price"] = 25000,
        ["Generation"] = 150,
        ["RoadWeight"] = 5
    },
    ["Brri Brri Bicus Dicus Bombicus"] = {
        ["DisplayName"] = "Brri Brri Bicus Dicus Bombicus",
        ["Rarity"] = "Epic",
        ["Price"] = 30000,
        ["Generation"] = 175,
        ["RoadWeight"] = 3.5
    },
    ["Bambini Crostini"] = {
        ["DisplayName"] = "Bambini Crostini",
        ["Rarity"] = "Epic",
        ["Price"] = 22500,
        ["Generation"] = 135,
        ["RoadWeight"] = 6
    },
    ["Perochello Lemonchello"] = {
        ["DisplayName"] = "Perochello Lemonchello",
        ["Rarity"] = "Epic",
        ["Price"] = 27500,
        ["Generation"] = 160,
        ["RoadWeight"] = 4.5
    },
    ["Avocadini Guffo"] = {
        ["DisplayName"] = "Avocadini Guffo",
        ["Rarity"] = "Epic",
        ["Price"] = 35000,
        ["Generation"] = 225,
        ["RoadWeight"] = 3
    },
    ["Salamino Penguino"] = {
        ["DisplayName"] = "Salamino Penguino",
        ["Rarity"] = "Epic",
        ["Price"] = 40000,
        ["Generation"] = 250,
        ["RoadWeight"] = 2.5
    },
    ["Ti Ti Ti Sahur"] = {
        ["DisplayName"] = "Ti Ti Ti Sahur",
        ["Rarity"] = "Epic",
        ["Price"] = 37500,
        ["Generation"] = 225
    },
    ["Penguino Cocosino"] = {
        ["DisplayName"] = "Penguino Cocosino",
        ["Rarity"] = "Epic",
        ["Price"] = 45000,
        ["Generation"] = 300
    },
    ["Avocadini Antilopini"] = {
        ["DisplayName"] = "Avocadini Antilopini",
        ["Rarity"] = "Epic",
        ["Price"] = 17500,
        ["Generation"] = 115,
        ["RoadWeight"] = 8.5
    },
    ["Bandito Axolito"] = {
        ["DisplayName"] = "Bandito Axolito",
        ["Rarity"] = "Epic",
        ["Price"] = 12500,
        ["Generation"] = 90,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Malame Amarele"] = {
        ["DisplayName"] = "Malame Amarele",
        ["Rarity"] = "Epic",
        ["Price"] = 23500,
        ["Generation"] = 140,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Mangolini Parrocini"] = {
        ["DisplayName"] = "Mangolini Parrocini",
        ["Rarity"] = "Epic",
        ["Price"] = 38500,
        ["Generation"] = 235,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Burbaloni Loliloli"] = {
        ["DisplayName"] = "Burbaloni Loliloli",
        ["Rarity"] = "Legendary",
        ["Price"] = 35000,
        ["Generation"] = 200,
        ["RoadWeight"] = 1
    },
    ["Chimpanzini Bananini"] = {
        ["DisplayName"] = "Chimpanzini Bananini",
        ["Rarity"] = "Legendary",
        ["Price"] = 50000,
        ["Generation"] = 300,
        ["RoadWeight"] = 0.75
    },
    ["Ballerina Cappuccina"] = {
        ["DisplayName"] = "Ballerina Cappuccina",
        ["Rarity"] = "Legendary",
        ["Price"] = 100000,
        ["Generation"] = 500,
        ["RoadWeight"] = 0.55
    },
    ["Chef Crabracadabra"] = {
        ["DisplayName"] = "Chef Crabracadabra",
        ["Rarity"] = "Legendary",
        ["Price"] = 150000,
        ["Generation"] = 600,
        ["RoadWeight"] = 0.5
    },
    ["Glorbo Fruttodrillo"] = {
        ["DisplayName"] = "Glorbo Fruttodrillo",
        ["Rarity"] = "Legendary",
        ["Price"] = 200000,
        ["Generation"] = 750,
        ["RoadWeight"] = 0.45
    },
    ["Blueberrinni Octopusini"] = {
        ["DisplayName"] = "Blueberrinni Octopusini",
        ["Rarity"] = "Legendary",
        ["Price"] = 250000,
        ["Generation"] = 1000,
        ["RoadWeight"] = 0.4
    },
    ["Lionel Cactuseli"] = {
        ["DisplayName"] = "Lionel Cactuseli",
        ["Rarity"] = "Legendary",
        ["Price"] = 175000,
        ["Generation"] = 650,
        ["RoadWeight"] = 0.47
    },
    ["Pandaccini Bananini"] = {
        ["DisplayName"] = "Pandaccini Bananini",
        ["Rarity"] = "Legendary",
        ["Price"] = 300000,
        ["Generation"] = 1250,
        ["RoadWeight"] = 0.35
    },
    ["Strawberrelli Flamingelli"] = {
        ["DisplayName"] = "Strawberrelli Flamingelli",
        ["Rarity"] = "Legendary",
        ["Price"] = 275000,
        ["Generation"] = 1150,
        ["RoadWeight"] = 0.37
    },
    ["Cocosini Mama"] = {
        ["DisplayName"] = "Cocosini Mama",
        ["Rarity"] = "Legendary",
        ["Price"] = 285000,
        ["Generation"] = 1200
    },
    ["Pi Pi Watermelon"] = {
        ["DisplayName"] = "Pi Pi Watermelon",
        ["Rarity"] = "Legendary",
        ["Price"] = 315000,
        ["Generation"] = 1300
    },
    ["Sigma Boy"] = {
        ["DisplayName"] = "Sigma Boy",
        ["Rarity"] = "Legendary",
        ["Price"] = 325000,
        ["Generation"] = 1350,
        ["RoadWeight"] = 0.3
    },
    ["Pipi Potato"] = {
        ["DisplayName"] = "Pipi Potato",
        ["Rarity"] = "Legendary",
        ["Price"] = 265000,
        ["Generation"] = 1100,
        ["RoadWeight"] = 0.385
    },
    ["Quivioli Ameleonni"] = {
        ["DisplayName"] = "Quivioli Ameleonni",
        ["Rarity"] = "Legendary",
        ["Price"] = 225000,
        ["Generation"] = 900,
        ["RoadWeight"] = 0.425
    },
    ["Tirilikalika Tirilikalako"] = {
        ["DisplayName"] = "Tirilikalika Tirilikalako",
        ["Rarity"] = "Legendary",
        ["Price"] = 75000,
        ["Generation"] = 450,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Caramello Filtrello"] = {
        ["DisplayName"] = "Caramello Filtrello",
        ["Rarity"] = "Legendary",
        ["Price"] = 255000,
        ["Generation"] = 1050,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Signore Carapace"] = {
        ["DisplayName"] = "Signore Carapace",
        ["Rarity"] = "Legendary",
        ["Price"] = 320000,
        ["Generation"] = 1325,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Frigo Camelo"] = {
        ["DisplayName"] = "Frigo Camelo",
        ["Rarity"] = "Mythic",
        ["Price"] = 350000,
        ["Generation"] = 1400,
        ["RoadWeight"] = 0.2
    },
    ["Orangutini Ananassini"] = {
        ["DisplayName"] = "Orangutini Ananassini",
        ["Rarity"] = "Mythic",
        ["Price"] = 400000,
        ["Generation"] = 1750,
        ["RoadWeight"] = 0.18
    },
    ["Bombardiro Crocodilo"] = {
        ["DisplayName"] = "Bombardiro Crocodilo",
        ["Rarity"] = "Mythic",
        ["Price"] = 500000,
        ["Generation"] = 2500,
        ["RoadWeight"] = 0.15
    },
    ["Bombombini Gusini"] = {
        ["DisplayName"] = "Bombombini Gusini",
        ["Rarity"] = "Mythic",
        ["Price"] = 1000000,
        ["Generation"] = 5000,
        ["RoadWeight"] = 0.14
    },
    ["Rhino Toasterino"] = {
        ["DisplayName"] = "Rhino Toasterino",
        ["Rarity"] = "Mythic",
        ["Price"] = 450000,
        ["Generation"] = 2150,
        ["RoadWeight"] = 0.16
    },
    ["Cavallo Virtuoso"] = {
        ["DisplayName"] = "Cavallo Virtuoso",
        ["Rarity"] = "Mythic",
        ["Price"] = 2500000,
        ["Generation"] = 7500,
        ["RoadWeight"] = 0.1
    },
    ["Spioniro Golubiro"] = {
        ["DisplayName"] = "Spioniro Golubiro",
        ["Rarity"] = "Mythic",
        ["Price"] = 750000,
        ["Generation"] = 3500
    },
    ["Zibra Zubra Zibralini"] = {
        ["DisplayName"] = "Zibra Zubra Zibralini",
        ["Rarity"] = "Mythic",
        ["Price"] = 1500000,
        ["Generation"] = 6000
    },
    ["Tigrilini Watermelini"] = {
        ["DisplayName"] = "Tigrilini Watermelini",
        ["Rarity"] = "Mythic",
        ["Price"] = 1750000,
        ["Generation"] = 6500
    },
    ["Gorillo Watermelondrillo"] = {
        ["DisplayName"] = "Gorillo Watermelondrillo",
        ["Rarity"] = "Mythic",
        ["Price"] = 3000000,
        ["Generation"] = 8000,
        ["RoadWeight"] = 0.08
    },
    ["Avocadorilla"] = {
        ["DisplayName"] = "Avocadorilla",
        ["Rarity"] = "Mythic",
        ["Price"] = 2000000,
        ["Generation"] = 7000
    },
    ["Ganganzelli Trulala"] = {
        ["DisplayName"] = "Ganganzelli Trulala",
        ["Rarity"] = "Mythic",
        ["Price"] = 3750000,
        ["Generation"] = 9000
    },
    ["Tob Tobi Tobi"] = {
        ["DisplayName"] = "Tob Tobi Tobi",
        ["Rarity"] = "Mythic",
        ["Price"] = 3250000,
        ["Generation"] = 8500
    },
    ["Te Te Te Sahur"] = {
        ["DisplayName"] = "Te Te Te Sahur",
        ["Rarity"] = "Mythic",
        ["Price"] = 4000000,
        ["Generation"] = 9500,
        ["RoadWeight"] = 0.07
    },
    ["Tracoducotulu Delapeladustuz"] = {
        ["DisplayName"] = "Tracoducotulu Delapeladustuz",
        ["Rarity"] = "Mythic",
        ["Price"] = 4250000,
        ["Generation"] = 12000,
        ["RoadWeight"] = 0.06
    },
    ["Lerulerulerule"] = {
        ["DisplayName"] = "Lerulerulerule",
        ["Rarity"] = "Mythic",
        ["Price"] = 3500000,
        ["Generation"] = 8750,
        ["RoadWeight"] = 0.75
    },
    ["Carloo"] = {
        ["DisplayName"] = "Carloo",
        ["Rarity"] = "Mythic",
        ["Price"] = 4500000,
        ["Generation"] = 13500,
        ["IgnoreIndexCounter"] = true
    },
    ["Carrotini Brainini"] = {
        ["DisplayName"] = "Carrotini Brainini",
        ["Rarity"] = "Mythic",
        ["Price"] = 4750000,
        ["Generation"] = 15000
    },
    ["Brutto Gialutto"] = {
        ["DisplayName"] = "Brutto Gialutto",
        ["Rarity"] = "Mythic",
        ["Price"] = 600000,
        ["Generation"] = 3000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Gorillo Subwoofero"] = {
        ["DisplayName"] = "Gorillo Subwoofero",
        ["Rarity"] = "Mythic",
        ["Price"] = 2750000,
        ["Generation"] = 7750,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Los Noobinis"] = {
        ["DisplayName"] = "Los Noobinis",
        ["Rarity"] = "Mythic",
        ["Price"] = 4350000,
        ["Generation"] = 12500,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Chihuanini Taconini"] = {
        ["DisplayName"] = "Chihuanini Taconini",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 8500000,
        ["Generation"] = 45000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Cocofanto Elefanto"] = {
        ["DisplayName"] = "Cocofanto Elefanto",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 5000000,
        ["Generation"] = 17500,
        ["RoadWeight"] = 0.05
    },
    ["Tralalero Tralala"] = {
        ["DisplayName"] = "Tralalero Tralala",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 10000000,
        ["Generation"] = 50000,
        ["RoadWeight"] = 0.01
    },
    ["Odin Din Din Dun"] = {
        ["DisplayName"] = "Odin Din Din Dun",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 15000000,
        ["Generation"] = 75000,
        ["RoadWeight"] = 0.007
    },
    ["Girafa Celestre"] = {
        ["DisplayName"] = "Girafa Celestre",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 7500000,
        ["Generation"] = 20000,
        ["RoadWeight"] = 0.03
    },
    ["Trenostruzzo Turbo 3000"] = {
        ["DisplayName"] = "Trenostruzzo Turbo 3000",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 25000000,
        ["Generation"] = 150000,
        ["RoadWeight"] = 0.005
    },
    ["Matteo"] = {
        ["DisplayName"] = "Matteo",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 10000000,
        ["Generation"] = 50000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Matteo",
        ["SpawnDelay"] = 3
    },
    ["Tigroligre Frutonni"] = {
        ["DisplayName"] = "Tigroligre Frutonni",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 14000000,
        ["Generation"] = 60000
    },
    ["Orcalero Orcala"] = {
        ["DisplayName"] = "Orcalero Orcala",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 25000000,
        ["Generation"] = 100000
    },
    ["Unclito Samito"] = {
        ["DisplayName"] = "Unclito Samito",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 20000000,
        ["Generation"] = 75000,
        ["IgnoreIndexCounter"] = true
    },
    ["Gattatino Nyanino"] = {
        ["DisplayName"] = "Gattatino Nyanino",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 7500000,
        ["Generation"] = 35000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Gattatino Nyanino",
        ["SpawnDelay"] = 9
    },
    ["Espresso Signora"] = {
        ["DisplayName"] = "Espresso Signora",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 25000000,
        ["Generation"] = 70000,
        ["IgnoreIndexCounter"] = true
    },
    ["Ballerino Lololo"] = {
        ["DisplayName"] = "Ballerino Lololo",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 35000000,
        ["Generation"] = 200000,
        ["RoadWeight"] = 0.0001
    },
    ["Piccione Macchina"] = {
        ["DisplayName"] = "Piccione Macchina",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 40000000,
        ["Generation"] = 225000,
        ["RoadWeight"] = 0.0008
    },
    ["Los Crocodillitos"] = {
        ["DisplayName"] = "Los Crocodillitos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 12500000,
        ["Generation"] = 55000
    },
    ["Los Crocodillitos"] = {
        ["DisplayName"] = "Los Crocodillitos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 12500000,
        ["Generation"] = 55000
    },
    ["Tukanno Bananno"] = {
        ["DisplayName"] = "Tukanno Bananno",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 22500000,
        ["Generation"] = 100000
    },
    ["Trippi Troppi Troppa Trippa"] = {
        ["DisplayName"] = "Trippi Troppi Troppa Trippa",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 30000000,
        ["Generation"] = 175000,
        ["RoadWeight"] = 0.0035
    },
    ["Los Tungtungtungcitos"] = {
        ["DisplayName"] = "Los Tungtungtungcitos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 37500000,
        ["Generation"] = 210000
    },
    ["Agarrini la Palini"] = {
        ["DisplayName"] = "Agarrini la Palini",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 80000000,
        ["Generation"] = 425000
    },
    ["Bulbito Bandito Traktorito"] = {
        ["DisplayName"] = "Bulbito Bandito Traktorito",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 35000000,
        ["Generation"] = 205000,
        ["IgnoreIndexCounter"] = true
    },
    ["Los Orcalitos"] = {
        ["DisplayName"] = "Los Orcalitos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 45000000,
        ["Generation"] = 235000
    },
    ["Tipi Topi Taco"] = {
        ["DisplayName"] = "Tipi Topi Taco",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 20000000,
        ["Generation"] = 75000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Bombardini Tortinii"] = {
        ["DisplayName"] = "Bombardini Tortinii",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 50000000,
        ["Generation"] = 225000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Tralalita Tralala"] = {
        ["DisplayName"] = "Tralalita Tralala",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 20000000,
        ["Generation"] = 100000,
        ["RoadWeight"] = 0.006
    },
    ["Urubini Flamenguini"] = {
        ["DisplayName"] = "Urubini Flamenguini",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 30000000,
        ["Generation"] = 150000,
        ["IgnoreIndexCounter"] = true
    },
    ["Alessio"] = {
        ["DisplayName"] = "Alessio",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 17500000,
        ["Generation"] = 85000,
        ["IgnoreIndexCounter"] = true
    },
    ["Pakrahmatmamat"] = {
        ["DisplayName"] = "Pakrahmatmamat",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 37500000,
        ["Generation"] = 215000,
        ["RoadWeight"] = 0.0009
    },
    ["Los Bombinitos"] = {
        ["DisplayName"] = "Los Bombinitos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 42500000,
        ["Generation"] = 220000,
        ["IgnoreIndexCounter"] = true
    },
    ["Brr es Teh Patipum"] = {
        ["DisplayName"] = "Brr es Teh Patipum",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 40000000,
        ["Generation"] = 225000
    },
    ["Tartaruga Cisterna"] = {
        ["DisplayName"] = "Tartaruga Cisterna",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 45000000,
        ["Generation"] = 250000
    },
    ["Cacasito Satalito"] = {
        ["DisplayName"] = "Cacasito Satalito",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 45000000,
        ["Generation"] = 240000,
        ["RoadWeight"] = 0.0006
    },
    ["Mastodontico Telepiedone"] = {
        ["DisplayName"] = "Mastodontico Telepiedone",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 47500000,
        ["Generation"] = 275000
    },
    ["Crabbo Limonetta"] = {
        ["DisplayName"] = "Crabbo Limonetta",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 46000000,
        ["Generation"] = 235000,
        ["IgnoreIndexCounter"] = true
    },
    ["Gattito Tacoto"] = {
        ["DisplayName"] = "Gattito Tacoto",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 32500000,
        ["Generation"] = 165000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Los Tipi Tacos"] = {
        ["DisplayName"] = "Los Tipi Tacos",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 46000000,
        ["Generation"] = 260000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Antonio"] = {
        ["DisplayName"] = "Antonio",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 6000000,
        ["Generation"] = 18500,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Las Capuchinas"] = {
        ["DisplayName"] = "Las Capuchinas",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 32500000,
        ["Generation"] = 185000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Orcalita Orcala"] = {
        ["DisplayName"] = "Orcalita Orcala",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 45000000,
        ["Generation"] = 240000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Piccionetta Macchina"] = {
        ["DisplayName"] = "Piccionetta Macchina",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 47000000,
        ["Generation"] = 270000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Anpali Babel"] = {
        ["DisplayName"] = "Anpali Babel",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 48000000,
        ["Generation"] = 280000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["La Vacca Saturno Saturnita"] = {
        ["DisplayName"] = "La Vacca Saturno Saturnita",
        ["Rarity"] = "Secret",
        ["Price"] = 50000000,
        ["Generation"] = 300000,
        ["RoadWeight"] = 0.0005
    },
    ["Los Tralaleritos"] = {
        ["DisplayName"] = "Los Tralaleritos",
        ["Rarity"] = "Secret",
        ["Price"] = 100000000,
        ["Generation"] = 500000,
        ["RoadWeight"] = 0.0001
    },
    ["Graipuss Medussi"] = {
        ["DisplayName"] = "Graipuss Medussi",
        ["Rarity"] = "Secret",
        ["Price"] = 250000000,
        ["Generation"] = 1000000,
        ["RoadWeight"] = 1e-6
    },
    ["La Grande Combinasion"] = {
        ["DisplayName"] = "La Grande Combinasion",
        ["Rarity"] = "Secret",
        ["OverheadYOffsetModifier"] = 0.8,
        ["Price"] = 1000000000,
        ["Generation"] = 10000000,
        ["RoadWeight"] = 1e-8
    },
    ["Sammyni Spyderini"] = {
        ["DisplayName"] = "Sammyni Spyderini",
        ["Rarity"] = "Secret",
        ["Price"] = 75000000,
        ["Generation"] = 325000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Los Spyderinis",
        ["SpawnDelay"] = 3.5
    },
    ["Garama and Madundung"] = {
        ["DisplayName"] = "Garama and Madundung",
        ["Rarity"] = "Secret",
        ["Price"] = 10000000000,
        ["Generation"] = 50000000,
        ["RoadWeight"] = 1e-10
    },
    ["Torrtuginni Dragonfrutini"] = {
        ["DisplayName"] = "Torrtuginni Dragonfrutini",
        ["Rarity"] = "Secret",
        ["Price"] = 125000000,
        ["Generation"] = 350000
    },
    ["Las Tralaleritas"] = {
        ["DisplayName"] = "Las Tralaleritas",
        ["Rarity"] = "Secret",
        ["Price"] = 150000000,
        ["Generation"] = 650000,
        ["RoadWeight"] = 0.00007
    },
    ["Pot Hotspot"] = {
        ["DisplayName"] = "Pot Hotspot",
        ["Rarity"] = "Secret",
        ["Price"] = 600000000,
        ["Generation"] = 2500000
    },
    ["Nuclearo Dinossauro"] = {
        ["DisplayName"] = "Nuclearo Dinossauro",
        ["Rarity"] = "Secret",
        ["Price"] = 2500000000,
        ["Generation"] = 15000000,
        ["RoadWeight"] = 1e-10
    },
    ["Las Vaquitas Saturnitas"] = {
        ["DisplayName"] = "Las Vaquitas Saturnitas",
        ["Rarity"] = "Secret",
        ["Price"] = 200000000,
        ["Generation"] = 750000
    },
    ["Chicleteira Bicicleteira"] = {
        ["DisplayName"] = "Chicleteira Bicicleteira",
        ["Rarity"] = "Secret",
        ["Price"] = 750000000,
        ["Generation"] = 3500000,
        ["RoadWeight"] = 1e-7
    },
    ["Agarrini la Palini"] = {
        ["DisplayName"] = "Agarrini la Palini",
        ["Rarity"] = "Secret",
        ["Price"] = 80000000,
        ["Generation"] = 425000
    },
    ["Los Combinasionas"] = {
        ["DisplayName"] = "Los Combinasionas",
        ["Rarity"] = "Secret",
        ["Price"] = 2000000000,
        ["Generation"] = 15000000
    },
    ["Karkerkar Kurkur"] = {
        ["DisplayName"] = "Karkerkar Kurkur",
        ["Rarity"] = "Secret",
        ["Price"] = 100000000,
        ["Generation"] = 300000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Karkerkar Kurkur",
        ["SpawnDelay"] = 3
    },
    ["Dragon Cannelloni"] = {
        ["DisplayName"] = "Dragon Cannelloni",
        ["Rarity"] = "Secret",
        ["Price"] = 100000000000,
        ["Generation"] = 100000000,
        ["RoadWeight"] = 1e-12
    },
    ["Los Hotspotsitos"] = {
        ["DisplayName"] = "Los Hotspotsitos",
        ["Rarity"] = "Secret",
        ["Price"] = 3000000000,
        ["Generation"] = 20000000,
        ["IgnoreIndexCounter"] = true
    },
    ["Esok Sekolah"] = {
        ["DisplayName"] = "Esok Sekolah",
        ["Rarity"] = "Secret",
        ["Price"] = 3500000000,
        ["Generation"] = 30000000,
        ["IgnoreIndexCounter"] = true
    },
    ["Nooo My Hotspot"] = {
        ["DisplayName"] = "Nooo My Hotspot",
        ["Rarity"] = "Secret",
        ["Price"] = 500000000,
        ["Generation"] = 1500000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Los Matteos"] = {
        ["DisplayName"] = "Los Matteos",
        ["Rarity"] = "Secret",
        ["Price"] = 100000000,
        ["Generation"] = 300000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Matteo",
        ["SpawnDelay"] = 3
    },
    ["Job Job Job Sahur"] = {
        ["DisplayName"] = "Job Job Job Sahur",
        ["Rarity"] = "Secret",
        ["Price"] = 175000000,
        ["Generation"] = 700000,
        ["RoadWeight"] = 5e-6
    },
    ["Dul Dul Dul"] = {
        ["DisplayName"] = "Dul Dul Dul",
        ["Rarity"] = "Secret",
        ["Price"] = 150000000,
        ["Generation"] = 375000,
        ["IgnoreIndexCounter"] = true
    },
    ["Blackhole Goat"] = {
        ["DisplayName"] = "Blackhole Goat",
        ["Rarity"] = "Secret",
        ["Price"] = 75000000,
        ["Generation"] = 400000,
        ["IgnoreIndexCounter"] = true
    },
    ["Los Spyderinis"] = {
        ["DisplayName"] = "Los Spyderinis",
        ["Rarity"] = "Secret",
        ["Price"] = 125000000,
        ["Generation"] = 425000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Los Spyderinis",
        ["SpawnDelay"] = 3.5
    },
    ["Ketupat Kepat"] = {
        ["DisplayName"] = "Ketupat Kepat",
        ["Rarity"] = "Secret",
        ["Price"] = 5000000000,
        ["Generation"] = 35000000,
        ["RoadWeight"] = 5e-11
    },
    ["La Supreme Combinasion"] = {
        ["DisplayName"] = "La Supreme Combinasion",
        ["Rarity"] = "Secret",
        ["Price"] = 7000000000,
        ["Generation"] = 40000000
    },
    ["Bisonte Giuppitere"] = {
        ["DisplayName"] = "Bisonte Giuppitere",
        ["Rarity"] = "Secret",
        ["Price"] = 75000000,
        ["Generation"] = 300000,
        ["IgnoreIndexCounter"] = true
    },
    ["Guerriro Digitale"] = {
        ["DisplayName"] = "Guerriro Digitale",
        ["Rarity"] = "Secret",
        ["Price"] = 120000000,
        ["Generation"] = 550000,
        ["IgnoreIndexCounter"] = true
    },
    ["Ketchuru and Musturu"] = {
        ["DisplayName"] = "Ketchuru and Musturu",
        ["Rarity"] = "Secret",
        ["Price"] = 7500000000,
        ["Generation"] = 42500000,
        ["RoadWeight"] = 2.5e-11
    },
    ["Spaghetti Tualetti"] = {
        ["DisplayName"] = "Spaghetti Tualetti",
        ["Rarity"] = "Secret",
        ["Price"] = 15000000000,
        ["Generation"] = 60000000
    },
    ["Los Nooo My Hotspotsitos"] = {
        ["DisplayName"] = "Los Nooo My Hotspotsitos",
        ["Rarity"] = "Secret",
        ["Price"] = 1000000000,
        ["Generation"] = 5000000,
        ["IgnoreIndexCounter"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    },
    ["Trenostruzzo Turbo 4000"] = {
        ["DisplayName"] = "Trenostruzzo Turbo 4000",
        ["Rarity"] = "Secret",
        ["Price"] = 100000000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end,
        ["Generation"] = 310000
    },
    ["Fragola La La La"] = {
        ["DisplayName"] = "Fragola La La La",
        ["Rarity"] = "Secret",
        ["Price"] = 125000000,
        ["Generation"] = 450000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["La Sahur Combinasion"] = {
        ["DisplayName"] = "La Sahur Combinasion",
        ["Rarity"] = "Secret",
        ["Price"] = 550000000,
        ["Generation"] = 2000000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["La Karkerkar Combinasion"] = {
        ["DisplayName"] = "La Karkerkar Combinasion",
        ["Rarity"] = "Secret",
        ["Price"] = 2500000000,
        ["Generation"] = 17500000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Tralaledon"] = {
        ["DisplayName"] = "Tralaledon",
        ["Rarity"] = "Secret",
        ["Price"] = 3000000000,
        ["Generation"] = 27500000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Los Bros"] = {
        ["DisplayName"] = "Los Bros",
        ["Rarity"] = "Secret",
        ["Price"] = 6000000000,
        ["Generation"] = 37500000,
        ["IgnoreIndexCounter"] = true,
        ["IsEnabled"] = function()
            -- upvalues: (copy) v_u_6
            return v_u_6.Methods.IsEnabled("Update-09/06/2025")
        end
    },
    ["Strawberry Elephant"] = {
        ["DisplayName"] = "Strawberry Elephant",
        ["Rarity"] = "OG",
        ["Price"] = 500000000000,
        ["Generation"] = 250000000,
        ["TriggerEvent"] = "Strawberry",
        ["SpawnVFX"] = "Strawberry",
        ["SpawnDelay"] = 3.5,
        ["IgnoreIndexCounter"] = true
    },
    ["Mythic Lucky Block"] = {
        ["DisplayName"] = "Lucky Block",
        ["Rarity"] = "Mythic",
        ["Price"] = 2500000,
        ["Generation"] = 0,
        ["RoadWeight"] = 0.05,
        ["LuckyBlock"] = v4["Mythic Lucky Block"],
        ["HideFromIndex"] = true
    },
    ["Brainrot God Lucky Block"] = {
        ["DisplayName"] = "Lucky Block",
        ["Rarity"] = "Brainrot God",
        ["Price"] = 25000000,
        ["Generation"] = 0,
        ["RoadWeight"] = 0.001,
        ["LuckyBlock"] = v4["Brainrot God Lucky Block"],
        ["HideFromIndex"] = true
    },
    ["Secret Lucky Block"] = {
        ["DisplayName"] = "Lucky Block",
        ["Rarity"] = "Secret",
        ["Price"] = 750000000,
        ["Generation"] = 0,
        ["RoadWeight"] = 7e-7,
        ["LuckyBlock"] = v4["Secret Lucky Block"],
        ["HideFromIndex"] = true
    },
    ["Admin Lucky Block"] = {
        ["DisplayName"] = "Lucky Block",
        ["Rarity"] = "Admin",
        ["Price"] = 100000000,
        ["Generation"] = 0,
        ["LuckyBlock"] = v4["Admin Lucky Block"],
        ["HideFromIndex"] = true
    },
    ["Taco Lucky Block"] = {
        ["DisplayName"] = "Lucky Block",
        ["Rarity"] = "Taco",
        ["Price"] = 50000000,
        ["Generation"] = 0,
        ["LuckyBlock"] = v4["Taco Lucky Block"],
        ["HideFromIndex"] = true,
        ["SpawnVFX"] = "Taco",
        ["SpawnDelay"] = 3
    }
}
if v2:IsServer() then
    local v8 = game:GetService("ServerStorage")
    for v9, v10 in require(v8.Modules.ServerRoadWeights) do
        if v7[v9] then
            v7[v9].RoadWeight = v10
        end
    end
end
return v7