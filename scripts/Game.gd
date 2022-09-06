extends Node

var a = []

func init_besties():
	engender_bestie()
	engender_bestie()
	engender_bestie()

func engender_bestie():
	var input = {}
	var kins = []
	
	for kin in Global.dict.kin.fertility.keys():
		for _i in Global.dict.kin.fertility[kin]:
			kins.append(kin)
	
	Global.rng.randomize()
	var index_r = Global.rng.randi_range(0, kins.size()-1)
	var kin = kins[index_r]
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, Global.dict.kin.animal[kin].size()-1)
	input.animal = Global.dict.kin.animal[kin][index_r]
	
	var stances = [6,7]
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, stances.size()-1)
	input.stance = stances[index_r]
	
	var bestie = Classes.Bestie.new(input)
	
	input = {}
	Global.rng.randomize()
	var roots = Global.dict.credo.root["All"]
	index_r = Global.rng.randi_range(0, roots.size()-1)
	input.name = roots[index_r]
	input.type = Global.dict.particle.keys()[0]
	input.index = -1
	var particle = Classes.Particle.new(input)
	input = {}
	input.animal = "All"
	input.sin = "None"
	input.credo = "None"
	input.particles = [particle]
	var scherbe = Classes.Scherbe.new(input)
	bestie.add_scherbe(scherbe)
	
	
	Global.arr.bestie.append(bestie)

func init_jagdgebiet():
	Global.obj.jagdgebiet = Classes.Jagdgebiet.new()
	
	for bestie in Global.arr.bestie:
		Global.obj.jagdgebiet.add_bestie(bestie)
	
	Global.obj.jagdgebiet.add_kampf()
	#Global.obj.jagdgebiet.arr.kampf[0].init_act()

func _ready():
	init_besties()
	init_jagdgebiet()
	f2()

func f2():
	var array = ['a', 'b', 'c', 'd', 'e']
	var k = 2

	var combinations = combine2(array, k)
	#print(combinations)

#множество элементов
#размер сочетаний
func combine2(array, k):
	var n = array.size() - 1 #максимальный индекс массива элементов
	var m = k - 1 #максимальный индекс массива-маски сочетания
	var finds = [] #массив всех возможных осчетаний
	var mask = [] #маска сочетания
	var finish = false
	var counter = 0
	
	for _i in k:
		mask.append(array[_i])
		
	while !finish && counter < 10:
		print(counter,mask)
		counter+=1
		finish = true
		var arr_ = []
		arr_.append_array(mask)
		
		if !finds.has(arr_):
			finds.append(arr_) #записываем сочетание в массив
			
		for _i in k:
			#print(mask[m - _i], array[n - _i])
			if mask[m - _i] != array[n - _i]:
				#проверяем, остались ли еще сочетания
				finish = false
				var p = array.find(mask[m - _i])
				p += 1
				mask[m - _i] = array[p] #изменяем маску, начиная с последнего элемента
				for _j in range(m - _i + 1, k):
					p += 1
					mask[_j] = array[p]
				break
	return finds

func _input(event):
	if event is InputEventMouseButton:
		if Global.flag.click:
			pass
		else:
			Global.flag.click = !Global.flag.click

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
	
	for kampf in Global.obj.jagdgebiet.arr.kampf:
		kampf.num.time += 1
		#print(kampf.num.time)
		kampf.act()
