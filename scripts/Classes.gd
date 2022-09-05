extends Node


class Particle:
	var num = {}
	var data = {}
	var key = {}

	func _init(input_):
		key.type = input_.type
		data.name = data.name
		num.index = input_.index

class Scherbe:
	var num = {}
	var obj = {}
	var data = {}
	var arr = {}

	func _init(input_):
		num.index = Global.num.primary_key.scherbe
		Global.num.primary_key.scherbe += 1
		obj.bestie = null
		data.animal = input_.animal
		data.sin = input_.sin
		data.credo = input_.credo
		arr.particle = input_.particles#prefix suffix root

class Aktion:
	var num = {}
	var data = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		obj.bestie = input_.bestie
		data.type = input_.type
		obj.root = input_.root
		arr.prefix = input_.prefix
		arr.affix = input_.affix
		data.target = input_.target

class Bestie:
	var num = {}
	var arr = {}
	var data = {}
	var obj = {}
	var dict = {}
	
	func _init(input_):
		num.index = Global.num.primary_key.bestie
		Global.num.primary_key.bestie += 1
		data.animal = input_.animal
		num.hp = {}
		num.hp.max = 100
		num.hp.current = num.hp.max
		num.stance = {}
		num.stance.base = input_.stance
		num.stance.current = input_.stance
		num.stance.min = 1
		num.stance.max = 12
		arr.aktion = []
		arr.scherbe = []
		obj.kampf = null
		obj.aktion = null
		set_basic_knowledges()
		recalc_knowledges()

	func add_aktion(aktion_):
		arr.aktion.append(aktion_)

	func choose_aktion():
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, arr.aktion.size()-1)
		obj.aktion = arr.aktion[index_r]

	func implement_aktion(target_):
		match obj.aktion.data.what:
			"hp":
				target_.shift_hp(obj.aktion.data.how)

	func shift_hp(how_):
		var shfit = int(how_)
		num.hp.current += shfit
		print(self,num.hp.current)
		
		if num.hp.current <= 0:
			obj.kampf.arr.corpse.append(self)
			obj.kampf.arr.bestie.erase(self)
			print(self,"dead")

	func set_basic_knowledges():
		dict.prefix = {}
		dict.affix = {}
		dict.root = {}
		
		for key in Global.dict.particle.prefix.keys():
			var indexs = []
			
			match key:
				"change tempo":
					indexs = [0,9]
				"rest":
					indexs = [0]
				"overheat":
					indexs = [0]
				"change stance":
					indexs = [2,3]
			
			dict.prefix[key] = indexs

	func recalc_knowledges():
		set_basic_knowledges()
		
		for scherbe in arr.scherbe:
			for particle in scherbe.arr.particle:
				if dict[particle.key.type].keys().has(particle.data.name):
					if !dict[particle.key.type][particle.data.name].keys().has(particle.num.index):
						dict[particle.key.type][particle.data.name].append(particle.num.index)
				else:
					dict[particle.key.type][particle.data.name] = [particle.num.index]

class Kampf:
	var num = {}
	var arr = {}
	var flag = {}
	var dict = {}
	var obj = {}
	
	func _init(input_):
		obj.jagdgebiet = input_.jagdgebiet
		num.index = Global.num.primary_key.kampf
		Global.num.primary_key.kampf += 1
		num.size = {}
		num.size.bestie = 6
		arr.bestie = []
		arr.corpse = []
		flag.full = false
		flag.act = false
		dict.timeline = {}
		num.timeskip = 0
		num.time = 0

	func init_act():
		dict.timeline = {}
		
		for bestie in arr.bestie:
			bestie.choose_aktion()
			add_to_timeline(bestie)
		
		get_timeskip()

	func add_to_timeline(bestie_):
		var aktion = bestie_.obj.aktion
		
		if dict.timeline.keys().has(aktion.num.tempo):
			dict.timeline[aktion.num.tempo].append(bestie_)
		else:
			dict.timeline[aktion.num.tempo] = [bestie_]

	func act():
		if arr.bestie.size() > 1:
			if num.timeskip == num.time:
				move_timeline()
				
				for bestie in dict.timeline[0]:
					var target = find_target(bestie) 
					bestie.implement_aktion(target)
					bestie.choose_aktion()
					add_to_timeline(bestie)
				dict.timeline.erase(0)
				get_timeskip()

	func get_timeskip():
		num.timeskip = dict.timeline.keys().min()

	func move_timeline():
		var new_timeline = {}
		
		for key in dict.timeline.keys():
			var shifted_time = key - num.timeskip 
			new_timeline[shifted_time] = dict.timeline[key]
		
		dict.timeline = new_timeline
		num.timeskip = 0
		num.time = 0

	func find_target(bestie_):
		var options = []
		
		for bestie in arr.bestie:
			if bestie != bestie_:
				var option = {}
				option.value = bestie.num.hp.current
				option.bestie = bestie
				options.append(option)
		
		match bestie_.obj.aktion.num.tempo:
			"low hp":
				options.sort_custom(self, "sort_ascending")
		
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, options.size()-1)
		return options[index_r].bestie

	func add_bestie(bestie_):
		arr.bestie.append(bestie_)
		bestie_.obj.kampf = self

	func check_act():
		flag.started = arr.bestie.size() > 1

	func check_full():
		flag.full = arr.bestie.size() == num.size.bestie

class Jagdgebiet:
	var arr = {}
	
	func _init():
		arr.bestie = []
		arr.kampf = []

	func add_bestie(bestie_):
		arr.bestie.append(bestie_)

	func add_kampf():
		var input = {}
		input.jagdgebiet = self
		var kampf = Classes.Kampf.new(input)
		
		for bestie in arr.bestie:
			kampf.add_bestie(bestie)
		
		arr.kampf.append(kampf)

class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
