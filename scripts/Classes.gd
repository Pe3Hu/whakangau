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
		
		match obj.root.data.name:
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
				
				obj.bestie.num.hp.current -= value

	func set_myself():
		flag.myself = false
		var flags = []
		
		for root in arr.root:
			for flag in Global.dict.target.myself.keys():
				if Global.dict.target.myself[flag].has(root):
					flags.append(flag)
		
		for flag_ in flags:
			flag.myself = flag.myself && flag_

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
				
				input.root = 1
				alveola = Classes.Alveola.new(input)
				arr.alveola.append(alveola)

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
		arr.aktion = []
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
		arr.aktion = []
		
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
						arr.aktion.append(aktion)
			
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, arr.aktion.size()-1)

	func rate_aktions():
		for aktion in arr.aktion:
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
		#rate_aktions()

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

	func get_afterhit_hp(time_):
		var afterhit = num.hp.current
		
		for visitor in arr.visitor:
			if visitor.time < time_:
				afterhit -= visitor.hp
		
		return afterhit

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
		arr.tareget = []
		flag.full = false
		flag.act = false
		dict.timeline = {}
		dict.afterhit = {}
		num.timeskip = 0
		num.time = 0
		num.avg = -1
		num.dispersion = -1

	func get_nums():
		var array = []
		
		for bestie in arr.bestie:
			var obj_ = {}
			obj_.value = bestie.num.hp.current
			obj_.bestie = bestie
			array.append(obj_)
			
		num.avg = Global.get_avg(array)
		num.dispersion = Global.get_dispersion(array, num.avg)

	func init_act():
		dict.timeline = {}
		get_nums()
		sort_targets()
		
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
	
	func calc_afterhits():
		dict.afterhit = {}
		
		for time in dict.timeline.keys():
			dict.afterhit[time] = {}
			dict.afterhit[time].hps = []
			
			for bestie in arr.bestie:
				var hp = {}
				hp.value = bestie.get_afterhit_hp(time)
				hp.bestie = bestie
				dict.afterhit[time].hps.append(hp)
				
			dict.afterhit[time].hps.sort_custom(Sorter, "sort_ascending")
			dict.afterhit[time].avg = Global.get_avg(dict.afterhit[time].hps)
			dict.afterhit[time].dispersion = Global.get_dispersion(dict.afterhit[time].hps, dict.afterhit[time].avg)

	func act():
		if arr.bestie.size() > 1:
			if num.timeskip == num.time:
				move_timeline()
				
				for bestie in dict.timeline[0]:
					var target = {}
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
		
		for bestie in arr.bestie:
			var target = {}
			target.value = bestie.num.hp.current
			target.bestie = bestie
			arr.tareget.append(target)
		
		arr.tareget.sort_custom(Sorter, "sort_ascending")

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
