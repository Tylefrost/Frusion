extends Area2D
@onready var lose = false
@onready var main = get_node("/root/Main")
@onready var is_ready = true
@onready var lose_message = get_node("/root/Main/Lose_message")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	if is_ready == true:
		is_ready = false
		
		lose = true
		await get_tree().create_timer(1).timeout
		if lose == true:
			main.gameover()
			lose_message.lose()
			
		is_ready = true


func _on_body_exited(_body):
	lose = false
