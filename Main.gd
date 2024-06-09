extends Node

@export var Grape: PackedScene
@export var Strawberry: PackedScene
@export var Orange: PackedScene
@export var Watermelon: PackedScene
@onready var fruit_types = [Grape,Strawberry,Orange,Watermelon]
@onready var new_fruit = fruit_types[randi() % (fruit_types.size() - 2)].instantiate()
var is_following_mouse = true
@onready var is_ready = true

func _input(_event):
	if Input.is_action_pressed("click") and is_ready == true:
		is_ready = false
		
		is_following_mouse = false
		new_fruit.gravity_scale = 1.0
		var next_fruit = fruit_types[randi() % (fruit_types.size() - 2)]
		new_fruit = next_fruit.instantiate()
		new_fruit.gravity_scale = 0.0
		await get_tree().create_timer(0.7).timeout
		new_fruit.hide()
		is_following_mouse = true
		add_child(new_fruit)
		await get_tree().create_timer(0.005).timeout
		new_fruit.set_visible(true)
		
		is_ready = true
func spawn_fruit(type, pos):
	var fruit = fruit_types[type].instantiate()
	fruit.position = pos
	fruit.gravity_scale = 1.0
	add_child.call_deferred(fruit)
func _ready():
	new_fruit.gravity_scale = 0.0
	add_child(new_fruit)
	
func _process(_delta):
	if is_following_mouse:
		new_fruit.move_and_collide(Vector2(get_viewport().get_mouse_position().x - new_fruit.position.x,0.0))
			
