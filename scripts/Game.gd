extends Node


func init_besties():
	engender_bestie()
	engender_bestie()
	engender_bestie()

func engender_bestie():
	var kins = []
	
	for kin in Global.dict.kin.fertility.keys():
		for _i in Global.dict.kin.fertility[kin]:
			kins.append(kin)
	
	Global.rng.randomize()
	var index_r = Global.rng.randi_range(0, kins.size()-1)
	var kin = kins[index_r]
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, Global.dict.kin.animal[kin].size()-1)
	var animal = Global.dict.kin.animal[kin][index_r]
	var input = {}
	input.animal = animal
	var stances = [6,7]
	index_r = Global.rng.randi_range(0, stances.size()-1)
	input.stance = stances[index_r]
	var bestie = Classes.Bestie.new(input)
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
