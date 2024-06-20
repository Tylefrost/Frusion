# Frusion
## Video Demo:
https://youtu.be/BNl0xoXFCvA
## Description:
Frusion is a 2D game made in the Godot engine where you drop fruit into a bucket and attempt to fuse fruit together into a larger fruit by getting 2 of the same size of fruit to touch. The bigger the fusion 
the more points you get! Try to get the most amount of points before the bucket overflows with fruit. Use your mouse to move around and choose where you want
to drop your fruits to fuse as many as possible.

## Scenes:
	
### Main:
This scene is the one you see when you press play.
I used stock wall sprite assets from Godot to make a bunch of wall sprites. Then I arranged the walls to make a cube without the top (bucket). After that I simply added collision boxes for each wall to prevent the fruit from “falling through”. I also added text labels to display the losing message and the score counter
### Grape:
This scene is the smallest fruit in the game (index position 0 in fruit_types) and can only be spawned in the dropper
### Strawberry:
This scene is the 2nd smallest fruit in the game (index position 1 in fruit_types) and can be spawned in the dropper or when 2 grapes fuse
### Orange:
This scene is the 2nd largest fruit in the game (index position 2 in fruit_types) and can only be spawned when 2 strawberries fuse
### Watermelon:
This scene is the largest fruit in the game (index position 3 in fruit_types) and can only be spawned when 2 oranges fuse\


## Scripting:

### Main:
This script controls the main scene which is the one you see when you press play. As a whole it handles the spawning of fruits, the dropping of those fruits,
the spawning of the new fused fruits, and the game over when the bucket is filled.

**Line 1:**\
Extends the main node which just means that this script applies to the main scene.
```
extends Node
```

**Lines 4-7:**\
Exports all of our fruits as "PackedScene" which means that we can create multiple instances of the same scene, meaning we can make multiple copies
of the same fruit.
```
@export var Grape: PackedScene
@export var Strawberry: PackedScene
@export var Orange: PackedScene
@export var Watermelon: PackedScene
```

**Lines 10-11:**\
Creates fruit_types list variable which contains all of the fruit types\
Creates the new_fruit variable which randomly selects a fruit from fruit_types to be the first fruit spawned 
```
@onready var fruit_types = [Grape,Strawberry,Orange,Watermelon]
@onready var new_fruit = fruit_types[randi() % (fruit_types.size() - 2)].instantiate()
```

**Lines 14-15:**\
Creates is_ready variable to prevent a function from being called again while the previous call is still ongoing\
Creates is_following_mouse variable to handle when fruits should follow the mouse cursor and when then should drop normally
```
@onready var is_ready = true
var is_following_mouse = true
```

**Lines 18-19:**\
Creates score variable to count score\
Creates score_path variable to hold the filepath to the score label on the 2D model of the main scene
```
@onready var score = 0
@onready var score_path = get_node("/root/Main/Score")
```

**Line 22:**\
Called whenever an input event occurs and passes an event variable that returns the input type and related information
```
func _input(_event):
```

**Line 25:**\
Runs the function if the player clicks and the previous function call has finished (is_ready = true)
```
	if Input.is_action_pressed("click") and is_ready == true:
```

**Lines 28:**\
Set is_ready to false since now function call is in progress
```
		#Set check variable to false to prevent concurrent calls
		is_ready = false
```

**Lines 31-32:**\
Turns off mouse following\
Drops the current fruit 
```
		is_following_mouse = false
		new_fruit.gravity_scale = 1.0
```

**Lines 35-37:**\
Creates new fruit in the dropper (not spawned yet)\
Turns off falling 
```
		#Creates new fruit 
		var next_fruit = fruit_types[randi() % (fruit_types.size() - 2)]
		new_fruit = next_fruit.instantiate()
		new_fruit.gravity_scale = 0.0
```

**Line 40:**\
Wait for 0.7 seconds for previous fruit to finish falling so it doesn't collide with the new fruit when we spawn the new fruit in 
```
		#Wait for 0.7 seconds for previous fruit to finish falling
		await get_tree().create_timer(0.7).timeout
```

**Lines 44-46:**\
Make the the new fruit invisible and set it to follow the mouse before finally spawning it in
```
		#Make the new fruit invisible and set 
		#to follow mouse before spawning in new fruit
		new_fruit.hide()
		is_following_mouse = true
		add_child(new_fruit)
```

**Lines 51-52:**\
Wait for brief moment to allow the new fruit to lock onto mouse position before making the fruit visible to prevent "motion blur" effect
```
		await get_tree().create_timer(0.005).timeout
		new_fruit.set_visible(true)
```

**Lines 55:**\
Set is_ready back to true since now the function call is finished
```
		#Now function is ready to be called again
		is_ready = true
```

**Lines 58-62:**\
Function for spawning the "fused fruits"
```
func spawn_fruit(type, pos, scoring):
	var fruit = fruit_types[type].instantiate()
	fruit.position = pos
	fruit.gravity_scale = 1.0
	add_child.call_deferred(fruit)
```

**Lines 65-66:**\
Adding to the score for successful fusions
```
	#Adding score for sucessful fusions
	score += scoring
	score_path.set_text("Score: " + str(score))
```

**Lines 69:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Lines 71-72:**\
Spawns the first fruit of the game
```
	#Spawning first fruit of the game
	new_fruit.gravity_scale = 0.0
	add_child(new_fruit)
```

**Lines 75:**\
Called every frame of the program 
```
func _process(_delta):
```

**Lines 77-78:**\
If is_following_mouse is true then make the fruit lock onto the mouse position
```
	if is_following_mouse:
		new_fruit.move_and_collide(Vector2(get_viewport().get_mouse_position().x - new_fruit.position.x,0.0))
```

**Lines 81-82:**\
Ends the game
```
func gameover():
	get_tree().paused = true
```

### Grape:
**Line 1:**\
Extends the RigidBody2D node meaning that this script applies to the Grape scene
```
extends RigidBody2D
```

**Line 4:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Line 6-7:**\
Make grapes report collisions with other fruits
```
	set_contact_monitor(true) 
	set_max_contacts_reported(1)	
```

**Lines 11-12:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```

**Line 15:**\
Function called by the grape when another rigidbody2D passes into or collides with the grape's collision shape
```
func _on_body_entered(body):
```

**Line 18-24:**\
If the grape collides with another grape then\
Delete both grapes\
Spawn in a strawberry at the average of the 2 grapes' positions\
And add 10 points to the score
```
if body.is_in_group("grapes") and body.has_signal("body_entered"):
		var new_pos = (body.position + position) / 2.0
		var main = get_node("/root/Main")
		body.contact_monitor = false
		body.queue_free()
		queue_free()
		main.spawn_fruit(1,new_pos,10)
```

### Strawberry:
**Line 1:**\
Extends the RigidBody2D node meaning that this script applies to the Strawberry scene
```
extends RigidBody2D
```

**Line 4:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Line 6-7:**\
Make strawberries report collisions with other fruits
```
	set_contact_monitor(true) 
	set_max_contacts_reported(1)	
```

**Lines 11-12:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```

**Line 15:**\
Function called by the strawberry when another rigidbody2D passes into or collides with the strawberry's collision shape
```
func _on_body_entered(body):
```

**Line 18-24:**\
If the strawberry collides with another strawberry then\
Delete both strawberries\
Spawn in an orange at the average of the 2 strawberries' positions\
And add 20 points to the score
```
if body.is_in_group("strawberries") and body.has_signal("body_entered"):
		var new_pos = (body.position + position) / 2.0
		var main = get_node("/root/Main")
		body.contact_monitor = false
		body.queue_free()
		queue_free()
		main.spawn_fruit(2,new_pos,20)
```

### Orange:
**Line 1:**\
Extends the RigidBody2D node meaning that this script applies to the Orange scene
```
extends RigidBody2D
```

**Line 4:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Line 6-7:**\
Make oranges report collisions with other fruits
```
	set_contact_monitor(true) 
	set_max_contacts_reported(1)	
```

**Lines 11-12:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```

**Line 15:**\
Function called by the orange when another rigidbody2D passes into or collides with the orange's collision shape
```
func _on_body_entered(body):
```

**Line 18-24:**\
If the orange collides with another orange then\
Delete both oranges\
Spawn in a watermelon at the average of the 2 oranges' positions\
And add 30 points to the score
```
if body.is_in_group("oranges") and body.has_signal("body_entered"):
		var new_pos = (body.position + position) / 2.0
		var main = get_node("/root/Main")
		body.contact_monitor = false
		body.queue_free()
		queue_free()
		main.spawn_fruit(3,new_pos,30)
```

### Watermelon:
**Line 1:**\
Extends the RigidBody2D node meaning that this script applies to the Watermelon scene
```
extends RigidBody2D
```

**Line 4:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Line 6-7:**\
Make watermelons report collisions with other fruits
```
	set_contact_monitor(true) 
	set_max_contacts_reported(1)	
```

**Lines 11-12:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```

**Lines 15-16:**\
Function called by the watermelon when another rigidbody2D passes into or collides with the watermelon's collision shape but isn't necessary so we pass
```
func _on_body_entered(body):
	pass
```

### Deadzone:
**Line 1:**\
Entends the Area2D node meaning that this script applies to the Deadzone area in the main scene
```
extends Area2D
```

**Lines 4-5:**\
Creates lose to handle when the player has lost\
Creates is_ready to prevent a function from being called again while the previous call is still ongoing
```
# check variables
@onready var lose = false
@onready var is_ready = true
```

**Lines 8-9:**\
Creates main to hold the file path to the main scene\
Creates lose_message to hold the file path to the Lose_message text label in the main scene
```
# accessing losing message and main
@onready var main = get_node("/root/Main")
@onready var lose_message = get_node("/root/Main/Lose_message")
```

**Lines 12-13:**\
Called only once at the very beginning of the program but isn't neccessary so we pass
```
func _ready():
	pass 
```
**Lines 17-18:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```
**Line 21:**\
Called when a fruit enters the deadzone
```
func _on_body_entered(_body):
```

**Lines 24-25:**\
Prevents the function from being called before previous call is finished
```
	if is_ready == true:
		is_ready = false
```

**Line 28:**\
First assume the bucket is overflowing
```	
		lose = true
```

**Line 33:**\
Wait 1 second to check that it's overflowing and not just a fruit falling through the deadzone
```
		await get_tree().create_timer(1).timeout
```

**Lines 38-40:**\
If the fruit is still in the deadzone after 1 second then the game ends and we make the lose message visible
```
		if lose == true:
			main.gameover()
			lose_message.lose()
```

**Line 44:**\
The function is finished and can be called again
```
		is_ready = true
```

**Lines 50-51:**\
Function called everytime an object leaves the area to set the lose condition back to false
since the fruit was just falling through and was not overflowing 
```
func _on_body_exited(_body):
	lose = false
```

### Lose_message
**Line 1:**\
Entends the text label meaning that this script applies to the Lose_message in the main scene
```
extends Label
```

**Line 4:**\
Called only once at the very beginning of the program
```
func _ready():
```

**Line 7:**\
Hide the message at the beginning of the game
```
	hide() 
```

**Line 11-12:**\
Called every frame of the program but isn't necessary so we pass
```
func _process(_delta):
	pass
```

**Line 15-16:**\
When we lose make the message visible	
```	
func lose():
	set_visible(true)
```
