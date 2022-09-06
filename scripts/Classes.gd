extends Node


class Particle:
	var num = {}
	var data = {}
	var key = {}

	func _init(input_):
		key.type = input_.type
		data.name = input_.name
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
		#data.type = input_.type
		arr.root = input_.roots
		arr.prefix = input_.prefixs
		arr.suffix = input_.suffixs
		num.stance = obj.bestie.num.stance.current

	func add_target(target_):
		data.target = target_

	func get_rate():
		var strategy = {}
		
		for key in Global.arr.strategy:
			 strategy[key] = 0
			
		var grade = 1
		var rate = float(obj.bestie.num.stance.current * grade)
		
		match obj.root.data.name:
			"Barricade":
				strategy["Prepper"] += rate
			"Taunt":
				strategy["Prepper"] += rate
			"Recover":
				strategy["Prepper"] += rate
			"Vanish":
				strategy["Prepper"] += rate
			"LifeSteal":
				strategy["Liquidator"] += rate
				strategy["Balancer"] += rate
				strategy["Prepper"] += rate / 3
			"Rampage":
				strategy["Liquidator"] += rate * 2
				strategy["Balancer"] += rate * 2
				strategy["Prepper"] -= rate
			"Critical":
				strategy["Liquidator"] += rate * 1.15
				strategy["Balancer"] += rate * 1.15
		
		return strategy

	func do_root():
		var grade = 1
		var value = obj.bestie.num.stance.current * grade
		
		match obj.root.data.name:
			"Barricade":
				obj.bestie.num.wall.current += value
				value = 0
			"Taunt":
				obj.bestie.num.threat.current += value
				value = 0
			"Recover":
				obj.bestie.num.hp.current += value
				
				if obj.bestie.num.hp.current > obj.bestie.num.hp.max:
					obj.bestie.num.hp.current = obj.bestie.num.hp.max
				value = 0
			"Vanish":
				obj.bestie.num.threat.current -= value
				value = 0
			"LifeSteal":
				obj.bestie.num.hp.current += value / 3
			"Rampage":
				obj.bestie.num.hp.current -= value / 2
				value *= 2
			"Critical":
				var crit = 15
				Global.rng.randomize()
				var rand_i = Global.rng.randi_range(0, 99)
				if rand_i < crit:
					value *= 2
		
		return value

class Alveola:
	var num = {}
	var data = {}
	
	func _init(input_):
		num.root = input_.root
		num.prefix = input_.prefix
		num.suffix = input_.suffix
		data.type = input_.type

class Nucleus:
	var num = {}
	var arr = {}
	
	func _init():
		num.stage = 0
		arr.alveola = []
		rise()

	func rise():
		match num.stage:
			0:
				var input = {}
				input.prefix = 0
				input.suffix = 0
				input.root = 0
				input.type = "Standart"
				var alveola = Classes.Alveola.new(input)
				arr.alveola.append(alveola)
				
				input.root = 1
				alveola = Classes.Alveola.new(input)
				arr.alveola.append(alveola)

class Gehirn:
	var num = {}

	func _init():
		roll()

	func roll():
		for strategy in Global.arr.strategy:
			 num[strategy] = 1
		
		var value = 9
		
		while value > 0:
			var keys = num.keys()
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, keys.size()-1)
			num[keys[index_r]] += 1
			value -= 1
		print(num)

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
		num.wall = {}
		num.wall.current = 0
		num.stance = {}
		num.stance.base = input_.stance
		num.stance.current = input_.stance
		num.stance.min = 1
		num.stance.max = 12
		num.threat = {}
		num.threat.base = 0
		num.threat.current = 0
		arr.aktion = []
		arr.scherbe = []
		obj.kampf = null
		obj.aktion = null
		obj.nucleus = Classes.Nucleus.new()
		obj.gehirn = Classes.Gehirn.new()
		
		set_basic_knowledges()
		recalc_knowledges()

	func choose_aktion():
		arr.aktion = []
		var aktions = []
		
		#for target in obj.kampf.arr.bestie:
		for alveola in obj.nucleus.arr.alveola:
			var roots = []
			var prefixs = []
			var suffixs = []
			
			for _r in alveola.num.root:
				var counter = 0
				var options = []
				var roots_ = []
				options.append_array(dict.root.keys())
				
				while counter <= _r && options.size() > 0:
					var root = options.pop_front()
					roots_.append(root)
					counter += 1
			
			for _p in alveola.num.prefix:
				var counter = 0
				var options = []
				options.append_array(dict.prefix.keys())
			
				while counter <= _p && options.size() > 0:
					var prefix = options.pop_front()
					prefixs.append(prefix)
					counter += 1
			
			for _s in alveola.num.suffix:
				var counter = 0
				var options = []
				options.append_array(dict.suffix.keys())
				
				while counter <= _s && options.size() > 0:
					var suffix = options.pop_front()
					suffixs.append(suffix)
					counter += 1
				
				
			for roots_ in roots:
				for prefixs_ in prefixs:
					for suffixs_ in suffixs:
						var input = {}
						input.bestie = self
						input.roots = roots_
						input.prefixs = prefixs_
						input.suffixs = suffixs_
						var aktion = Classes.Aktion.new(input)
						aktions.append(aktion)
	
			print(alveola.num,roots,prefixs,suffixs)
			
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, arr.aktion.size()-1)
		#obj.aktion = arr.aktion[index_r]

	func implement_aktion(target_):
		var value = obj.aktion.do_root()
		
		if value > 0:
			target_.shift_hp(value)

	func shift_hp(value_):
		var shfit = int(value_)
		num.hp.current += shfit
		print(self,num.hp.current)
		
		if num.hp.current <= 0:
			obj.kampf.arr.corpse.append(self)
			obj.kampf.arr.bestie.erase(self)
			print(self,"dead")

	func set_basic_knowledges():
		dict.prefix = {}
		dict.suffix = {}
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

	func add_scherbe(scherbe_):
		arr.scherbe.append(scherbe_)
		recalc_knowledges()

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
			#add_to_timeline(bestie)
		
		#get_timeskip()

	func add_to_timeline(bestie_):
		var aktion = bestie_.obj.aktion
		
		if dict.timeline.keys().has(aktion.num.stance):
			dict.timeline[aktion.num.stance].append(bestie_)
		else:
			dict.timeline[aktion.num.stance] = [bestie_]

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
		
		match bestie_.obj.aktion.num.stance:
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
