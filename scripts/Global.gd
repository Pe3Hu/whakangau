extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}

func init_num():
	init_primary_key()
	
	num.size = {}

func init_primary_key():
	num.primary_key = {}
	num.primary_key.scherbe = 0
	num.primary_key.bestie = 0
	num.primary_key.kampf = 0

func init_dict():
	init_window_size()
	dict.aktion = {}
	dict.aktion.tag = {
		"Tide": "Easy",
		"Pressure": "Heavy",
		"Echo": "Heavy",
		"Frost": "All",
		"Heat": "All",
		"Caprice": "Easy",
		"Fetter": "Heavy",
		"Hunger": "All",
		"Satiety": "All",
		"Mark": "Easy"
	}
	dict.aktion.group = {
		"All": ["Auqa","Wind","Fire","Earth","Ice","Storm","Lava","Plant"],
		"Easy": ["Wind","Fire","Storm","Plant"],
		"Heavy": ["Auqa","Earth","Ice","Lava"],
		"Inert": ["Earth","Ice"],
		"Agile": ["Wind","Storm"],
		"Sanative": ["Auqa","Plant"],
		"Pushy": ["Fire","Lava"]
	}
	dict.sin = {}
	dict.sin.animal = {
		"Pride": ["Lion","Eagle"],
		"Envy": ["Snake","Monkey"],
		"Avarice": ["Raven","Squirrel"],
		"Wrath": ["Rhino","Aper"],
		"Gluttony": ["Bear","Wolf"],
		"Lust": ["Rabbit","Rat"],
		"Indolence": ["Elephant","Panda"]
	}
	dict.sin.tendency = {
		"Pride": ["Pressure","Pushy"],
		"Envy": ["Mark","Agile"],
		"Avarice": ["Echo","Agile"],
		"Wrath": ["Tide","Heat","Pushy"],
		"Gluttony": ["Hunger","Satiety","Sanative"],
		"Lust": ["Caprice","Sanative"],
		"Indolence": ["Frost","Fetter","Inert"]
	}
	dict.credo = {}
	dict.credo.type = {
		"Defense": ["Bastion","Fountain"],
		"Balance": ["Shadow","Duelist","Reaper"],
		"Attack": ["Demolisher","Executioner","Berserk","Mauler"],
	}
	dict.credo.tendency = {
		"Bastion": ["Heavy","Inert"],
		"Fountain": ["All","Sanative"],
		"Shadow": ["Easy","Agile"],
		"Duelist": ["Easy","Pushy"],
		"Reaper": ["All","Sanative"],
		"Demolisher": ["Heavy","Pushy"],
		"Executioner": ["Easy","Pushy"],
		"Berserk": ["Heavy","Agile"],
		"Mauler": ["All","Pushy"],
	}
	dict.credo.tendency = {
		"Bastion": ["Heavy","Inert"],
		"Fountain": ["All","Sanative"],
		"Shadow": ["Easy","Agile"],
		"Duelist": ["Easy","Pushy"],
		"Reaper": ["All","Sanative"],
		"Demolisher": ["Heavy","Pushy"],
		"Executioner": ["Easy","Pushy"],
		"Berserk": ["Heavy","Agile"],
		"Mauler": ["All","Pushy"],
	}
	dict.prefix = {}
	dict.prefix = {
		"All": ["Сhange to easy stand","Сhange to heavy stand","Adrenaline","Respite","Accelerate","Decelerate"]
	}
	dict.affix = {}
	dict.affix = {
		"All": ["Barricade","Taunt","Recover","Vanish","Combo"],
		"Bastion": ["Barricade 2","Taunt 2"],
		"Fountain": ["Recover 2","Abundance"],
		"Shadow": ["Vanish 2","Backstab"],#Ambush
		"Duelist": ["Taunt 3","Parry"],
		"Reaper": ["Seed","Harvest"],
		"Demolisher": ["Compression","Ram"],
		"Executioner": ["Scaffold","Execution"],
		"Berserk": ["Rampage","Combo"],
		"Mauler": ["Detour","Bluntly"]
	}
	dict.passive = {
		"All": ["Emulous","Nimble",
			"Brave",
			"Cautious","Stalker",
			"Venturesome",
			"Resentful","Frenzy",
			"Callous",
			"Glamorous","Attractive",
			"Clumsy"],
		"Bastion": ["Steadiness"],
		"Fountain": ["Galore"],
		"Shadow": ["Off-stage"],
		"Duelist": ["Impudence"],
		"Reaper": [],
		"Demolisher": ["Destructive"],
		"Executioner": ["Fatal"],
		"Berserk": [],
		"Mauler": ["Weakness knowledge"],
	}
	dict.counter = {
		"All": ["Retribution","Scalp counter","Scalp counter"],
		"Bastion": ["Steadiness","Block counter"],
		"Fountain": ["Recovery counter"],
		"Shadow": ["Off-stage"],
		"Duelist": ["Parry counter"],
		"Reaper": ["Scalp counter 2"],
		"Demolisher": [""],
		"Executioner": ["Scalp counter 3"],
		"Berserk": ["Injury counter"],
		"Mauler": ["Weakness knowledge"],
	}
	

func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)

func init_arr():
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	
	arr.element = ["Auqa","Wind","Fire","Earth","Ice","Strom","Lava","Plant"]
	arr.sin = ["Pride","Envy","Avarice","Wrath","Gluttony","Lust","Indolence"]
	arr.bestie = []
	arr.aktion = []

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 

func init_flag():
	flag.click = false

func _ready():
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_flag()
