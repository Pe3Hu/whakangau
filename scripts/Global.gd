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
		"Mark": "Easy",
		"Unrestraint": "Easy",
		"Onus": "Heavy"
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
		"Pride": ["Lion","Eagle","Deer"],
		"Envy": ["Snake","Lemur","Jackal","Parrot"],
		"Avarice": ["Raven","Squirrel","Fox","Lynx"],
		"Wrath": ["Hippo","Aper","Gorilla","Grizzly","Croc"],
		"Gluttony": ["Bear","Wolf","Rhino","Horse"],
		"Lust": ["Rabbit","Rat","Cheetah","Macaque"],
		"Indolence": ["Elephant","Panda","Donkey"]
	}
	dict.sin.tendency = {
		"Pride": ["Pressure","Pushy"],
		"Envy": ["Mark","Agile"],
		"Avarice": ["Echo","Agile","Onus"],
		"Wrath": ["Tide","Heat","Pushy"],
		"Gluttony": ["Hunger","Satiety","Sanative"],
		"Lust": ["Caprice","Sanative","Unrestraint"],
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
	dict.credo.root = {}
	dict.credo.root = {
		"All": ["Barricade","Taunt","Recover","Vanish","LifeSteal","Rampage","Critical"], #,"Phase"
		"Bastion": ["Barricade 2","Taunt 2"],
		"Fountain": ["Recover 2","Abundance"],
		"Shadow": ["Vanish 2","Backstab"],#Ambush
		"Duelist": ["Taunt 3","Parry"],
		"Reaper": ["Seed","Harvest", "LifeSteal 2"],
		"Demolisher": ["Compression","Ram"],
		"Executioner": ["Scaffold","Execution"],
		"Berserk": ["Rampage 2"],
		"Mauler": ["Detour","Bluntly","Critical 2"]
	}
	dict.credo.passive = {
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
	dict.credo.counter = {
		"All": ["Retribution","Scalp counter","Scalp counter"],
		"Bastion": ["Steadiness","Block counter"],
		"Fountain": ["Recovery counter"],
		"Shadow": ["Off-stage"],
		"Duelist": ["Parry counter"],
		"Reaper": ["Scalp counter 2"],
		"Demolisher": [""],
		"Executioner": ["Scalp counter 3"],
		"Berserk": ["Injury counter"],
		"Mauler": ["Weakness counter"],
	}
	dict.kin = {}
	dict.kin.animal = {
		"Ursidae": ["Bear","Panda","Grizzly"],
		"Caniformia": ["Wolf","Jackal","Fox"],
		"Aves": ["Raven","Eagle","Parrot"],
		"Glires": ["Squirrel","Rabbit","Rat"],
		"Reptilia": ["Snake","Lizard","Croc"],
		"Euarchonta": ["Lemur","Gorilla","Macaque"],
		"Felidae": ["Lion","Lynx","Cheetah"],
		"Artiodactyla": ["Rhino","Donkey","Horse"],
		"Perissodactyla": ["Hippo","Aper","Deer"]
	}
	dict.kin.fertility = {
		"Ursidae": 1,
		"Caniformia": 2,
		"Aves": 3,
		"Glires": 5,
		"Reptilia": 3,
		"Euarchonta": 1,
		"Felidae": 2,
		"Artiodactyla": 1,
		"Perissodactyla": 1
	}
	dict.particle = {}
	dict.particle.root = {
		"Barricade": [1],
		"Barricade 2": [1],
		"Taunt": [1],
		"Taunt 2": [1],
		"Taunt 3": [1],
		"Recover": [1],
		"Recover 2": [1],
		"Vanish": [1],
		"Vanish 2": [1],
		"Combo": [1],
		"Abundance": [1],
		"Backstab": [1],
		"Parry": [1],
		"Seed": [1],
		"Harvest": [1],
		"Compression": [1],
		"Ram": [1],
		"Scaffold": [1],
		"Rampage": [1],
		"Combo 2": [1],
		"Detour": [1],
		"Bluntly": [1]
	}
	dict.particle.prefix = {
		"change tempo": [-6,-5,-4,-3,-2,2,3,4,5,6],
		"rest": [2],
		"overheat": [2],
		"change stance": [-4,-2,-1,1,2,4]
	}
	dict.particle.suffix = {
		"Tide": [1],
		"Pressure": [1],
		"Echo": [1],
		"Frost": [-1],
		"Heat": [1],
		"Caprice": [1],
		"Fetter": [1],
		"Hunger": [1],
		"Satiety": [1],
		"Mark": [1],
		"Unrestraint": [1],
		"Onus": [-1]
	}
	dict.target = {}
	dict.target.myself = {
		true: ["Barricade","Taunt","Recover","Vanish"],
		false: ["LifeSteal","Rampage","Critical"]
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
	arr.strategy = ["Liquidator","Balancer","Prepper"]
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

#множество элементов
#размер сочетаний
func combine(array_, k_):
	var n = array_.size() - 1 #максимальный индекс массива элементов
	var m = k_ - 1 #максимальный индекс массива-маски сочетания
	var finds = [] #массив всех возможных осчетаний
	var mask = [] #маска сочетания
	var finish = false
	var counter = 0
	
	for _i in k_:
		mask.append(array_[_i])
		
	while !finish && counter < 10:
		counter+=1
		finish = true
		var arr_ = []
		arr_.append_array(mask)
		
		if !finds.has(arr_):
			finds.append(arr_) #записываем сочетание в массив
			
		for _i in k_:
			#print(mask[m - _i], array_[n - _i])
			if mask[m - _i] != array_[n - _i]:
				#проверяем, остались ли еще сочетания
				finish = false
				var p = array_.find(mask[m - _i])
				p += 1
				mask[m - _i] = array_[p] #изменяем маску, начиная с последнего элемента
				for _j in range(m - _i + 1, k_):
					p += 1
					mask[_j] = array_[p]
				break
	return finds
