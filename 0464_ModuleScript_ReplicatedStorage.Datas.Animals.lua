--[[
  Extracted from: ReplicatedStorage.Datas.Animals
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local v1 = game:GetService("ReplicatedStorage")
local v2 = v1:WaitForChild("Datas")
local v3 = require(v2.LuckyBlocks)
require(v2.Rarities)
local v4 = v1:WaitForChild("Shared")
local v_u_5 = require(v4.Updates)
local v6 = {
	["Noobini Pizzanini"] = {
		["DisplayName"] = "Noobini Pizzanini",
		["Rarity"] = "Common",
		["Price"] = 25,
		["Generation"] = 1,
		["RoadWeight"] = 20000
	},
	["Liril\195\172 Laril\195\160"] = {
		["DisplayName"] = "Liril\195\172 Laril\195\160",
		["Rarity"] = "Common",
		["Price"] = 250,
		["Generation"] = 3,
		["RoadWeight"] = 10000
	},
	["Tim Cheese"] = {
		["DisplayName"] = "Tim Cheese",
		["Rarity"] = "Common",
		["Price"] = 500,
		["Generation"] = 5,
		["RoadWeight"] = 10000
	},
	["Garama and Madundung"] = {
		["DisplayName"] = "Garama and Madundung",
		["Rarity"] = "Secret",
		["Price"] = 10000000000,
		["Generation"] = 50000000,
		["RoadWeight"] = 1
	},
	["Fluriflura"] = {
		["DisplayName"] = "Fluriflura",
		["Rarity"] = "Common",
		["Price"] = 750,
		["Generation"] = 7,
		["RoadWeight"] = 10000
	},
	["Svinina Bombardino"] = {
		["DisplayName"] = "Svinina Bombardino",
		["Rarity"] = "Common",
		["Price"] = 1250,
		["Generation"] = 10,
		["RoadWeight"] = 10000
	},
	["Talpa Di Fero"] = {
		["DisplayName"] = "Talpa Di Fero",
		["Rarity"] = "Common",
		["Price"] = 1000,
		["Generation"] = 9,
		["RoadWeight"] = 10000
	},
	["Pipi Kiwi"] = {
		["DisplayName"] = "Pipi Kiwi",
		["Rarity"] = "Common",
		["Price"] = 1500,
		["Generation"] = 13,
		["RoadWeight"] = 10000
	},
	["Sigma Girl"] = {
		["DisplayName"] = "Sigma Girl",
		["Rarity"] = "Legendary",
		["Price"] = 3400000,
		["Generation"] = 1800,
		["RoadWeight"] = 0.3
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
		["RoadWeight"] = 7000
	},
	["Tung Tung TungSahur"] = {
		["DisplayName"] = "Tung Tung TungSahur",
		["Rarity"] = "Rare",
		["Price"] = 3000,
		["Generation"] = 25,
		["RoadWeight"] = 1000
	},
	["Gangster Footera"] = {
		["DisplayName"] = "Gangster Footera",
		["Rarity"] = "Rare",
		["Price"] = 4000,
		["Generation"] = 30,
		["RoadWeight"] = 1000
	},
	["Boneca Ambalabu"] = {
		["DisplayName"] = "Boneca Ambalabu",
		["Rarity"] = "Rare",
		["Price"] = 5000,
		["Generation"] = 40,
		["RoadWeight"] = 1000
	},
	["Ta Ta Ta Ta Sahur"] = {
		["DisplayName"] = "Ta Ta Ta Ta Sahur",
		["Rarity"] = "Rare",
		["Price"] = 7500,
		["Generation"] = 55,
		["RoadWeight"] = 1000
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
	["Bandito Axolito"] = {
		["DisplayName"] = "Bandito Axolito",
		["Rarity"] = "Epic",
		["Price"] = 12500,
		["Generation"] = 90,
		["RoadWeight"] = 457
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
		["RoadWeight"] = 8.5,
		["IsEnabled"] = function()
			return v_u_5.Methods.IsEnabled("Update-08/30/2025")
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
	["Caramello Filtrello"] = {
		["DisplayName"] = "Caramello Filtrello",
		["Rarity"] = "Legendary",
		["Price"] = 255000,
		["Generation"] = 1050,
		["IgnoreIndexCounter"] = true,
		["RoadWeight"] = 135
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
	["Strawberry Elephant"] = {
		["DisplayName"] = "Strawberry Elephant",
		["Rarity"] = "OG",
		["Price"] = 500000000000,
		["Generation"] = 350000000,
		["RoadWeight"] = 0.3
	},
	["Noo my examine"] = {
		["DisplayName"] = "Noo my examine",
		["Rarity"] = "Secret",
		["Price"] = 525000000,
		["Generation"] = 1700000,
		["RoadWeight"] = 0.3
	},
	["Yess my examine"] = {
		["DisplayName"] = "Yess my examine",
		["Rarity"] = "Secret",
		["Price"] = 130000000,
		["Generation"] = 575000,
		["RoadWeight"] = 0.3
	},
	["Spaghetti Tualetti"] = {
		["DisplayName"] = "Spaghetti Tualetti",
		["Rarity"] = "Secret",
		["Price"] = 15000000000,
		["Generation"] = 60000000,
		["RoadWeight"] = 0.3
	},
	["Pipi Potato"] = {
		["DisplayName"] = "Pipi Potato",
		["Rarity"] = "Legendary",
		["Price"] = 265000,
		["Generation"] = 1100,
		["RoadWeight"] = 0.385
	},
	["Steve"] = {
		["DisplayName"] = "Steve",
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
		["RoadWeight"] = 0.425,
		["IsEnabled"] = function()
			return v_u_5.Methods.IsEnabled("Update-08/30/2025")
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
	["Gorillo Subwoofero"] = {
		["DisplayName"] = "Gorillo Subwoofero",
		["Rarity"] = "Mythic",
		["Price"] = 2750000,
		["Generation"] = 7750,
		["RoadWeight"] = 464
	},
	["Los Noobinis"] = {
		["DisplayName"] = "Los Noobinis",
		["Rarity"] = "Mythic",
		["Price"] = 4350000,
		["Generation"] = 12500,
		["RoadWeight"] = 0.754
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
		["Generation"] = 15000,
		["IsEnabled"] = function()
			return v_u_5.Methods.IsEnabled("Update-08/30/2025")
		end
	},
	["Cocofanto Elefanto"] = {
		["DisplayName"] = "Cocofanto Elefanto",
		["Rarity"] = "Brainrot God",
		["Price"] = 5000000,
		["Generation"] = 17500,
		["RoadWeight"] = 0.05
	},
	["Cocofanto Dollari"] = {
		["DisplayName"] = "Cocofanto Dollari",
		["Rarity"] = "Dolla",
		["Price"] = 10000000,
		["Generation"] = 97500
	},
	["Job Job Job Dollar"] = {
		["DisplayName"] = "Job Job Job Dollar",
		["Rarity"] = "Dolla",
		["Price"] = 185000000,
		["Generation"] = 993500
	},
	["Brr es Teh DollarPum"] = {
		["DisplayName"] = "Brr es Teh DollarPum",
		["Rarity"] = "Dolla",
		["Price"] = 95000000,
		["Generation"] = 53500
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
		["RoadWeight"] = 140
	},
	["Belula Beluga"] = {
		["DisplayName"] = "Belula Beluga",
		["Rarity"] = "Brainrot God",
		["Price"] = 60000000,
		["Generation"] = 290000
	},
	["Girafa Celestre"] = {
		["DisplayName"] = "Girafa Celestre",
		["Rarity"] = "Brainrot God",
		["Price"] = 7500000,
		["Generation"] = 20000,
		["RoadWeight"] = 0.03
	},
	["Las Capuchinas"] = {
		["DisplayName"] = "Las Capuchinas",
		["Rarity"] = "Brainrot God",
		["Price"] = 32500000,
		["Generation"] = 185000,
		["RoadWeight"] = 66
	},
	["Trenostruzzo Turbo 3000"] = {
		["DisplayName"] = "Trenostruzzo Turbo 3000",
		["Rarity"] = "Brainrot God",
		["Price"] = 25000000,
		["Generation"] = 150000,
		["RoadWeight"] = 134
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
	["Fragola La La La"] = {
		["DisplayName"] = "Fragola La La La",
		["Rarity"] = "Secret",
		["Price"] = 125000000,
		["Generation"] = 450000
	},
	["67"] = {
		["DisplayName"] = "67",
		["Rarity"] = "Secret",
		["Price"] = 1250000000,
		["Generation"] = 7500000
	},
	["La Karkerkar Combinasion"] = {
		["DisplayName"] = "La Karkerkar Combinasion",
		["Rarity"] = "Secret",
		["Price"] = 2500000000,
		["Generation"] = 17500000
	},
	["Los Chicleteiras"] = {
		["DisplayName"] = "Los Chicleteiras",
		["Rarity"] = "Secret",
		["Price"] = 1200000000,
		["Generation"] = 7000000
	},
	["Chachechi"] = {
		["DisplayName"] = "Chachechi",
		["Rarity"] = "Secret",
		["Price"] = 85000000,
		["Generation"] = 400000
	},
	["Extinct Tralalero"] = {
		["DisplayName"] = "Extinct Tralalero",
		["Rarity"] = "Secret",
		["Price"] = 125000000,
		["Generation"] = 450000,
		["RoadWeight"] = 13
	},
	["Extinct Ballerina"] = {
		["DisplayName"] = "Extinct Ballerina",
		["Rarity"] = "Brainrot God",
		["Price"] = 23500000,
		["Generation"] = 125000,
		["RoadWeight"] = 23
	},
	["Extinct Matteo"] = {
		["DisplayName"] = "Extinct Matteo",
		["Rarity"] = "Secret",
		["Price"] = 140000000,
		["Generation"] = 625000,
		["RoadWeight"] = 16
	},
	["Las Sis"] = {
		["DisplayName"] = "Las Sis",
		["Rarity"] = "Secret",
		["Price"] = 2500000000,
		["Generation"] = 17500000
	},
	["La Extinct Grande"] = {
		["DisplayName"] = "La Extinct Grande",
		["Rarity"] = "Secret",
		["Price"] = 3250000000,
		["Generation"] = 23500000
	},
	["La Sahur Combinasion"] = {
		["DisplayName"] = "La Sahur Combinasion",
		["Rarity"] = "Secret",
		["Price"] = 550000000,
		["Generation"] = 2000000,
		["RoadWeight"] = 23
	},
	["Malame Amarele"] = {
		["DisplayName"] = "Malame Amarele",
		["Rarity"] = "Epic",
		["Price"] = 23500,
		["Generation"] = 140,
		["RoadWeight"] = 23
	},
	["Piccionetta Macchina"] = {
		["DisplayName"] = "Piccionetta Macchina",
		["Rarity"] = "Brainrot God",
		["Price"] = 47000000,
		["Generation"] = 270000,
		["RoadWeight"] = 10
	},
	["Tralaledon"] = {
		["DisplayName"] = "Tralaledon",
		["Rarity"] = "Secret",
		["Price"] = 3000000000,
		["Generation"] = 27500000,
		["RoadWeight"] = 23
	},
	["Los Bros"] = {
		["DisplayName"] = "Los Bros",
		["Rarity"] = "Secret",
		["Price"] = 6000000000,
		["Generation"] = 37500000,
		["RoadWeight"] = 10
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
		["RoadWeight"] = 10
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
		["RoadWeight"] = 10
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
		["RoadWeight"] = 10
	},
	["Los Crocodillitos"] = {
		["DisplayName"] = "Los Crocodillitos",
		["Rarity"] = "Brainrot God",
		["Price"] = 12500000,
		["Generation"] = 55000
	},
	["Chihuanini Taconini"] = {
		["DisplayName"] = "Chihuanini Taconini",
		["Rarity"] = "Brainrot God",
		["Price"] = 8500000,
		["Generation"] = 45000,
		["RoadWeight"] = 12
	},
	["Gattito Tacoto"] = {
		["DisplayName"] = "Gattito Tacoto",
		["Rarity"] = "Brainrot God",
		["Price"] = 32500000,
		["Generation"] = 165000,
		["RoadWeight"] = 18
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
	["Los Tipi Tacos"] = {
		["DisplayName"] = "Los Tipi Tacos",
		["Rarity"] = "Brainrot God",
		["Price"] = 46000000,
		["Generation"] = 260000,
		["RoadWeight"] = 0.709
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
		["RoadWeight"] = 10
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
	["DollarMini"] = {
		["DisplayName"] = "DollarMini",
		["Rarity"] = "Dolla",
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
		["RoadWeight"] = 13
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
		["RoadWeight"] = 10
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
		["Generation"] = 1472
	},
	["Tartaruga Cisterna"] = {
		["DisplayName"] = "Tartaruga Cisterna",
		["Rarity"] = "Brainrot God",
		["Price"] = 45000000,
		["Generation"] = 2500
	},
	["Cacasito Satalito"] = {
		["DisplayName"] = "Cacasito Satalito",
		["Rarity"] = "Brainrot God",
		["Price"] = 45000000,
		["Generation"] = 240000,
		["RoadWeight"] = 32
	},
	["Mastodontico Telepiedone"] = {
		["DisplayName"] = "Mastodontico Telepiedone",
		["Rarity"] = "Brainrot God",
		["Price"] = 47500000,
		["Generation"] = 275000,
		["RoadWeight"] = 10
	},
	["Crabbo Limonetta"] = {
		["DisplayName"] = "Crabbo Limonetta",
		["Rarity"] = "Brainrot God",
		["Price"] = 46000000,
		["Generation"] = 235000,
		["RoadWeight"] = 19
	},
	["La Vacca Saturno Saturnita"] = {
		["DisplayName"] = "La Vacca Saturno Saturnita",
		["Rarity"] = "Secret",
		["Price"] = 50000000,
		["Generation"] = 300000,
		["RoadWeight"] = 23
	},
	["Trenostruzzo Turbo 4000"] = {
		["DisplayName"] = "Trenostruzzo Turbo 4000",
		["Rarity"] = "Secret",
		["Price"] = 100000000,
		["Generation"] = 310000
	},
	["La Spooky Grande"] = {
		["DisplayName"] = "La Spooky Grande",
		["Rarity"] = "Secret",
		["Price"] = 2900000000,
		["Generation"] = 24500000,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Zombie Tralala"] = {
		["DisplayName"] = "Zombie Tralala",
		["Rarity"] = "Secret",
		["Price"] = 100000000,
		["Generation"] = 500000,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Frankentteo"] = {
		["DisplayName"] = "Frankentteo",
		["Rarity"] = "Secret",
		["Price"] = 175000000,
		["Generation"] = 700000,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Eviledon"] = {
		["DisplayName"] = "Eviledon",
		["Rarity"] = "Secret",
		["Price"] = 8000000000,
		["Generation"] = 31500000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Jacko Jack Jack"] = {
		["DisplayName"] = "Jacko Jack Jack",
		["Rarity"] = "Brainrot God",
		["Price"] = 30000000,
		["Generation"] = 100000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Los Mobilis"] = {
		["DisplayName"] = "Los Mobilis",
		["Rarity"] = "Secret",
		["Price"] = 2700000000,
		["Generation"] = 15000000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Vulturino Skeletono"] = {
		["DisplayName"] = "Vulturino Skeletono",
		["Rarity"] = "Secret",
		["Price"] = 110000000,
		["Generation"] = 500000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Snailenzo"] = {
		["DisplayName"] = "Snailenzo",
		["Rarity"] = "Brainrot God",
		["Price"] = 45000000,
		["Generation"] = 250000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Tentacolo Tecnico"] = {
		["DisplayName"] = "Tentacolo Tecnico",
		["Rarity"] = "Brainrot God",
		["Price"] = 50000000,
		["Generation"] = 275000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Spooky and Pumpky"] = {
		["DisplayName"] = "Spooky and Pumpky",
		["Rarity"] = "Brainrot God",
		["Price"] = 45000000,
		["Generation"] = 225000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Mummio Rappitto"] = {
		["DisplayName"] = "Mummio Rappitto",
		["Rarity"] = "Epic",
		["Price"] = 30000,
		["Generation"] = 175,
		["RoadWeight"] = 3.5,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Mamma Rappin"] = {
		["DisplayName"] = "Mamma Rappin",
		["Rarity"] = "Brainrot God",
		["Price"] = 32500000,
		["Generation"] = 185000,
		["RoadWeight"] = 66,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Magi Ribbitini"] = {
		["DisplayName"] = "Magi Ribbitini",
		["Rarity"] = "Mythic",
		["Price"] = 4000000,
		["Generation"] = 9500,
		["RoadWeight"] = 0.07,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Jacko Spaventosa"] = {
		["DisplayName"] = "Jacko Spaventosa",
		["Rarity"] = "Mythic",
		["Price"] = 4500000,
		["Generation"] = 13500,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Buho de Fuego"] = {
		["DisplayName"] = "Buho de Fuego",
		["Rarity"] = "Legendary",
		["Price"] = 345000,
		["Generation"] = 1400,
		["RoadWeight"] = 0.2,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Tartaragno"] = {
		["DisplayName"] = "Tartaragno",
		["Rarity"] = "Brainrot God",
		["Price"] = 45000000,
		["Generation"] = 240000,
		["RoadWeight"] = 32,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Pinealotto Fruttarino"] = {
		["DisplayName"] = "Pinealotto Fruttarino",
		["Rarity"] = "Brainrot God",
		["Price"] = 47500000,
		["Generation"] = 275000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["La Vacca Jacko Lanterino"] = {
		["DisplayName"] = "La Vacca Jacko Lanterino",
		["Rarity"] = "Secret",
		["Price"] = 50000000,
		["Generation"] = 300000,
		["RoadWeight"] = 23,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Vampira Cappucina"] = {
		["DisplayName"] = "Vampira Cappucina",
		["Rarity"] = "Brainrot God",
		["Price"] = 24500000,
		["Generation"] = 125000,
		["IgnoreIndexCounter"] = true,
		["SpawnVFX"] = "Witching Hour",
		["SpawnDelay"] = 3
	},
	["Mythic Lucky Block"] = {
		["DisplayName"] = "Lucky Block",
		["Rarity"] = "Mythic",
		["Price"] = 2500000,
		["Generation"] = 0,
		["RoadWeight"] = 0.678,
		["LuckyBlock"] = v3["Mythic Lucky Block"],
		["HideFromIndex"] = true
	},
	["Brainrot God Lucky Block"] = {
		["DisplayName"] = "Lucky Block",
		["Rarity"] = "Brainrot God",
		["Price"] = 25000000,
		["Generation"] = 0,
		["RoadWeight"] = 0.245,
		["LuckyBlock"] = v3["Brainrot God Lucky Block"],
		["HideFromIndex"] = true
	},
	["Secret Lucky Block"] = {
		["DisplayName"] = "Lucky Block",
		["Rarity"] = "Secret",
		["Price"] = 750000000,
		["Generation"] = 0,
		["RoadWeight"] = 7,
		["LuckyBlock"] = v3["Secret Lucky Block"],
		["HideFromIndex"] = true
	},
	["Taco Lucky Block"] = {
		["DisplayName"] = "Lucky Block",
		["Rarity"] = "Taco",
		["Price"] = 75000000,
		["Generation"] = 0,
		["LuckyBlock"] = v3["Taco Lucky Block"],
		["HideFromIndex"] = true
	},
	["Admin Lucky Block"] = {
		["DisplayName"] = "Lucky Block",
		["Rarity"] = "Admin",
		["Price"] = 100000000,
		["Generation"] = 0,
		["LuckyBlock"] = v3["Admin Lucky Block"],
		["HideFromIndex"] = true
	},
	["Los Lucky Blocks"] = {
		["DisplayName"] = "Los Lucky Blocks",
		["Rarity"] = "Admin",
		["Price"] = 

			250000000,
		["Generation"] = 0,
		["LuckyBlock"] = v3["Los Lucky Blocks"],
		["HideFromIndex"] = true
	},
	["Frogato Pirato"] = {
		["DisplayName"] = "Frogato Pirato",
		["Rarity"] = "Epic",
		["Price"] = 39000,
		["Generation"] = 240,
		["RoadWeight"] = 3.5,
		["IgnoreIndexCounter"] = true
	},
	["Pakrahmatmatina"] = {
		["DisplayName"] = "Pakrahmatmatina",
		["Rarity"] = "Brainrot God",
		["Price"] = 40500000,
		["Generation"] = 225000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true
	},
	["Bambu Bambu Sahur"] = {
		["DisplayName"] = "Bambu Bambu Sahur",
		["Rarity"] = "Brainrot God",
		["Price"] = 47500000,
		["Generation"] = 275000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true
	},
	["Krupuk Pagi Pagi"] = {
		["DisplayName"] = "Krupuk Pagi Pagi",
		["Rarity"] = "Brainrot God",
		["Price"] = 60000000,
		["Generation"] = 290000,
		["RoadWeight"] = 10,
		["IgnoreIndexCounter"] = true
	},
	["Boatito Auratito"] = {
		["DisplayName"] = "Boatito Auratito",
		["Rarity"] = "Secret",
		["Price"] = 115000000,
		["Generation"] = 525000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true
	},
	["Horegini Boom"] = {
		["DisplayName"] = "Horegini Boom",
		["Rarity"] = "Secret",
		["Price"] = 650000000,
		["Generation"] = 2700000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true
	},
	["Rang Ring Bus"] = {
		["DisplayName"] = "Rang Ring Bus",
		["Rarity"] = "Secret",
		["Price"] = 1100000000,
		["Generation"] = 6000000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true
	},
	["Meowl"] = {
		["DisplayName"] = "Meowl",
		["Rarity"] = "OG",
		["Price"] = 350000000000,
		["Generation"] = 275000000,
		["RoadWeight"] = 0.3,
		["IgnoreIndexCounter"] = true
	},
	["Mieteteira Bicicleteira"] = {
		["DisplayName"] = "Mieteteira Bicicleteira",
		["Rarity"] = "Secret",
		["Price"] = 2700000000,
		["Generation"] = 26000000,
		["RoadWeight"] = 1,
		["IgnoreIndexCounter"] = true
	}
}

local targetRarities = {"Common"}
for itemName, itemData in pairs(v6) do
	for _, rarity in pairs(targetRarities) do
		if itemData.Rarity == rarity then
			if itemData.RoadWeight then
				itemData.RoadWeight = itemData.RoadWeight * 500
				print(itemData.DisplayName, itemData.RoadWeight)
			end
			break
		end
	end
end

return v6