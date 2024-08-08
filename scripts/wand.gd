class_name Wand extends Marker2D

@export var spell_velocity = 850.0
const SPELL_SCENE = preload("res://scenes/spell.tscn")

func cast(direction: float) -> bool:
	var spell := SPELL_SCENE.instantiate() as Spell 
	print("pioo")
	return true
