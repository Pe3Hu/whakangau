extends Node


func init_aktions():
	add_aktion(4, "low hp", "hp", "-15")
	add_aktion(5, "low hp", "hp", "-12")
	add_aktion(6, "low hp", "hp", "-10")
	add_aktion(10, "low hp", "hp", "-6")
	add_aktion(12, "low hp", "hp", "-5")
	add_aktion(15, "low hp", "hp", "-4")

func add_aktion(tempo_, who_, what_, how_):
	var input = {}
	input.tempo = tempo_
	input.who = who_
	input.what = what_
	input.how = how_
	var aktion = Classes.Aktion.new(input)
	Global.arr.aktion.append(aktion)

func init_besties():
	add_bestie()
	add_bestie()
	add_bestie()

func add_bestie():
	var options = []
	options.append_array(Global.arr.aktion)
	var bestie = Classes.Bestie.new()
	Global.rng.randomize()
	var index_r = Global.rng.randi_range(0, options.size()-1)
	bestie.add_aktion(options[index_r])
	options.remove(index_r)
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, options.size()-1)
	bestie.add_aktion(options[index_r])
	Global.arr.bestie.append(bestie)

func init_jagdgebiet():
	Global.obj.jagdgebiet = Classes.Jagdgebiet.new()
	
	for bestie in Global.arr.bestie:
		Global.obj.jagdgebiet.add_bestie(bestie)
	
	Global.obj.jagdgebiet.add_kampf()
	Global.obj.jagdgebiet.arr.kampf[0].init_act()

func _ready():
	init_aktions()
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
