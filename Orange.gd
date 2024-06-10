extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true) 
	set_max_contacts_reported(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("oranges") and body.has_signal("body_entered"):
		var new_pos = (body.position + position) / 2.0
		var main = get_node("/root/Main")
		body.contact_monitor = false
		body.queue_free()
		queue_free()
		main.spawn_fruit(3,new_pos,30)
