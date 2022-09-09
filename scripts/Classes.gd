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
	var flag = {}

	func _init(input_):
		obj.bestie = input_.bestie
		#data.type = input_.type
		arr.root = input_.roots
		arr.prefix = input_.prefixs
		arr.suffix = input_.suffixs
		num.stance = obj.bestie.num.stance
		num.time = {}
		num.time.cast = obj.bestie.num.stance.current
		num.time.completion = obj.bestie.obj.kampf.num.time.current + num.time.cast
		obj.target = null

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

	func get_charge():
		var grade = 1
		var charge = obj.bestie.num.stance.current * grade
		
		match obj.root.data.name:
			"Barricade":
				pass
			"Taunt":
				pass
			"Recover":
				num.threat.current = charge
			"Vanish":
				obj.bestie.num.threat.current -= charge
				charge = 0
			"LifeSteal":
				obj.bestie.num.hp.current += charge / 3
			"Rampage":
				obj.bestie.num.hp.current -= charge / 2
				charge *= 2
			"Critical":
				var crit = 15
		
		return charge

	func do_root():
		var grade = 1
		var value = obj.bestie.num.stance.current * grade
		
		for root in arr.root:
			value = obj.bestie.num.stance.current * grade
			
			match root.data.name:
				"Barricade":
					obj.bestie.num.wall.current += value
				"Taunt":
					obj.bestie.num.threat.current += value
				"Recover":
					obj.bestie.num.hp.current += value
					
					if obj.bestie.num.hp.current > obj.bestie.num.hp.max:
						obj.bestie.num.hp.current = obj.bestie.num.hp.max
				"Vanish":
					obj.bestie.num.threat.current -= value
				"LifeSteal":
					obj.bestie.num.hp.current += value / 3
				"Rampage":
					obj.bestie.num.hp.current -= value / 2
				"Critical":
					var crit = 15
					Global.rng.randomize()
					var rand_i = Global.rng.randi_range(0, 99)
					
					if rand_i < crit:
						value *= 2
		
		obj.target.shift_hp(-value)

	func set_myself():
		flag.myself = false
		var flags = []
		
		for root in arr.root:
			for flag in Global.dict.target.myself.keys():
				if Global.dict.target.myself[flag].has(root):
					flags.append(flag)
		
		for flag_ in flags:
			flag.myself = flag.myself && flag_

	func calc_effect():
		var effect = {}
		effect.hp = obj.bestie.num.stance.current
		effect.threat = 0
		return effect

	func set_target(target_):
		obj.target = target_

class Rate:
	var num = {}
	var dict = {}
	var obj = {}
	
	func _init(input_):
		obj.aktion = input_.aktion
		obj.target = input_.target
		
		for key in Global.dict.strategy.keys():
			dict[key] = {}
			
			for strategy in Global.dict.strategy[key]:
				 dict[key][strategy] = 0
		
		get_value()
	
	func get_value():
		var kampf = obj.aktion.obj.bestie.obj.kampf
		var time = obj.aktion.obj.bestie.num.stance.current
		var nearest_time = 0
		
		for time_ in dict.afterhit.keys():
			if time_ > nearest_time && time_ <= time:
				nearest_time = time_
		
		var hps = []
		hps.append_array(dict.afterhit[nearest_time].hps)
		
		for hp in hps:
			if hp.bestie == obj.target:
				hp.value +=  obj.aktion

class Buff:
	var num = {}
	var obj = {}
	var data = {}
	
	func _init(input_):
		obj.bestie = input_.bestie
		data.name = input_.name
		num.value = input_.value
		num.time = input_.time
		give()

	func give():
		match data.name:
			"Vanish":
				obj.bestie.num.threat.current += num.value

	func withdraw():
		if num.time <= 0:
			match data.name:
				"Vanish":
					obj.bestie.num.threat.current += num.value

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
				
#				input.root = 1
#				alveola = Classes.Alveola.new(input)
#				arr.alveola.append(alveola)
				pass

class Gehirn:
	var dict = {}

	func _init():
		roll()

	func roll():
		for key in Global.dict.strategy.keys():
			dict[key] = {}
			var value = 12

			for strategy in Global.dict.strategy[key]:
				dict[key][strategy] = 1
				value -= 1
		
			while value > 0:
				var strategys = Global.dict.strategy[key]
				Global.rng.randomize()
				var index_r = Global.rng.randi_range(0, strategys.size()-1)
				dict[key][strategys[index_r]] += 1
				value -= 1

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
		num.hp.current = num.hp.max - Global.num.primary_key.bestie * 5
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
		arr.aktion = {}
		arr.aktion.past = []
		arr.aktion.future = []
		arr.aktion.option = []
		arr.scherbe = []
		arr.rate = []
		arr.visitor = []
		obj.kampf = null
		obj.aktion = null
		obj.nucleus = Classes.Nucleus.new()
		obj.gehirn = Classes.Gehirn.new()
		
		set_basic_knowledges()
		recalc_knowledges()

	func prepare_aktions():
		arr.aktion = {}
		arr.aktion.past = []
		arr.aktion.future = []
		arr.aktion.option = []
		
		for alveola in obj.nucleus.arr.alveola:
			var roots = Global.combine(dict.root.keys(),alveola.num.root)
			var prefixs = Global.combine(dict.prefix.keys(),alveola.num.prefix)
			var suffixs = Global.combine(dict.suffix.keys(),alveola.num.suffix)
				
			for roots_ in roots:
				for prefixs_ in prefixs:
					for suffixs_ in suffixs:
						var input = {}
						input.bestie = self
						input.roots = roots_
						input.prefixs = prefixs_
						input.suffixs = suffixs_
						var aktion = Classes.Aktion.new(input)
						arr.aktion.option.append(aktion)
		
		pass

	func rate_aktions():
		for aktion in arr.aktion.option:
			for target in obj.kampf.arr.bestie:
				var flag = target == self
			
				if aktion.flag.myself == flag:
					var input = {}
					input.target = target
					input.aktion = aktion
					var rate = Classes.Rate.new(input)
					arr.rate.append(rate)
		
		for rate in arr.rate:
			print(rate.obj.target,rate.obj.aktion)

	func choose_aktion():
		prepare_aktions()
		
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, arr.aktion.size()-1)
		#print(arr.aktion)
		
		obj.aktion = arr.aktion.option[0]
		obj.aktion.set_target(obj.kampf.arr.bestie[0])
		#rate_aktions()

	func implement_aktion():
		obj.aktion.do_root()

	func shift_hp(value_):
		var shfit = int(value_)
		num.hp.current += shfit
		print(self,num.hp.current)
		
		if num.hp.current <= 0:
			#obj.kampf.arr.corpse.append(self)
			#obj.kampf.arr.bestie.erase(self)
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

	func get_afterhit_hp(time_):
		var afterhit = num.hp.current
		
		for visitor in arr.visitor:
			if visitor.time < time_:
				afterhit -= visitor.hp
		
		return afterhit

	func add_to_future(aktion_):
		arr.aktion.future.append(aktion_)

	func remove_to_past(aktion_):
		arr.aktion.past.append(aktion_)
		arr.aktion.future.erase(aktion_)

class Nachbild:
	var obj = {}
	var num = {}

	func _init(input_):
		obj.bestie = input_.bestie
		num.time = input_.time
		get_nums()

	func get_nums():
		num.hp = obj.bestie.num.hp.current
		num.threat = obj.bestie.num.threat.current
		var timeshift = num.time - obj.bestie.obj.kampf.num.time.current
		
		for aktion in obj.bestie.arr.aktion.future:
			if aktion.num.time.cast < timeshift:
				var result = aktion.calc_effect()
				num.hp += result.hp
				num.threat += result.threat

class Scheibe:
	var num = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		obj.kampf = input_.kampf
		num.time = input_.time
		recalc()

	func recalc():
		arr.alive = []
		arr.corpse = []
		init_besties()
		sort_targets()
		get_nums()

	func init_besties():
		for bestie in obj.kampf.arr.bestie: 
			var input = {}
			input.bestie = bestie
			input.time = num.time
			var nachbild = Classes.Nachbild.new(input)
			
			if nachbild.num.hp > 0:
				arr.alive.append(nachbild)
			else:
				arr.corpse.append(nachbild)

	func get_nums():
		num.avg = Global.get_avg(arr.tareget)
		num.dispersion = Global.get_dispersion(arr.tareget, num.avg)

	func sort_targets():
		arr.tareget = []
		
#		for strategy in Global.arr.strategy:
#			if strategy != "Prepper":
#				dict.tareget[strategy] = []
#				match strategy:
#					"Liquidator":
#						options.sort_custom(self, "sort_ascending")
#					"Balancer":
#						options.sort_custom(self, "sort_descending")
		
		for alive in arr.alive:
			var obj_ = {}
			obj_.value = alive.num.hp
			obj_.bestie = alive.obj.bestie
			arr.tareget.append(obj_)
		
		arr.tareget.sort_custom(Sorter, "sort_ascending")

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
		num.time = {}
		num.time.skip = 0
		num.time.current = 0
		arr.bestie = []
		arr.tareget = []
		flag.full = false
		flag.act = false
		dict.timeline = {}

	func init_act():
		dict.timeline = {}
		
		for bestie in arr.bestie:
			bestie.choose_aktion()
			add_to_timeline(bestie)
		
		get_timeskip()

	func add_to_timeline(bestie_):
		var aktion = bestie_.obj.aktion
		#var target = aktion.obj.target
		var target = arr.bestie[0]
		target.add_to_future(aktion)
		var time = num.time.current + aktion.num.time.cast
		
		if dict.timeline.keys().has(time):
			dict.timeline[time].recalc()
		else:
			var input = {}
			input.kampf = self
			input.time = time
			dict.timeline[time] = Classes.Scheibe.new(input)

	func act():
		if arr.bestie[0].num.hp.current > 0:#arr.bestie.size() > 1:
			print(num.time.current, dict.timeline)
			if num.time.skip == num.time.current:
				
				for nachbild in dict.timeline[num.time.current].arr.alive:
					var bestie = nachbild.obj.bestie
					if bestie.obj.aktion.num.time.completion == num.time.current:
						
						var target = bestie.obj.aktion.obj.target
						bestie.implement_aktion()
						bestie.choose_aktion()
						add_to_timeline(bestie)
					dict.timeline.erase(num.time.skip)
				get_timeskip()

	func get_timeskip():
		num.time.skip = dict.timeline.keys().min()

	func move_timeline():
		var new_timeline = {}
		
		for key in dict.timeline.keys():
			var shifted_time = key - num.time.skip 
			new_timeline[shifted_time] = dict.timeline[key]
		
		dict.timeline = new_timeline
		num.timeskip = 0
		num.time = 0

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
