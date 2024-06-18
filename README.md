# Frusion
## Video Demo:
## Description:
Frusion is a game where you drop fruit into a bucket and attempt to fuse fruit together by getting 2 of the same size of fruit to touch. The bigger the fusion 
the more points you get! Try to get the most amount of points before the bucket overfills with fruit. Use your mouse to move around and choose where you want
to drop your fruits.
## Scenes:
### Main:
This scene is the one you see when you press play.
I used stock wall sprite assets from Godot to make a bunch of wall sprites. Then I arranged the walls to make a cube without the top (bucket). After that I simply added collision boxes for each wall to prevent the fruit from “falling through”. After that it was just adding text labels to display the losing message and the score counter



## Scripting:

### Main:
This script controls the main scene which is the one you see when you press play. As a whole it handles the spawning of fruits, the dropping of those fruits,
the spawning of the new fused fruits, and the game over when the bucket is filled.

**Line 1:**
Extends the main node which just means that this script applies to the main scene.
```
extends Node
```

**Lines 4-7:**
Exports all of our fruits as "PackedScene" which means that we can create multiple instances of the same scene, meaning we can make multiple copies
of the same fruit.
```
@export var Grape: PackedScene
@export var Strawberry: PackedScene
@export var Orange: PackedScene
@export var Watermelon: PackedScene
```

**Lines 10-11:**
Creates fruit_types list variable which contains all of the fruit types
Creates the new_fruit variable which randomly selects a fruit from fruit_types to be the first fruit spawned 
```
@onready var fruit_types = [Grape,Strawberry,Orange,Watermelon]
@onready var new_fruit = fruit_types[randi() % (fruit_types.size() - 2)].instantiate()
```

**Lines 14-15:**
Creates is_ready variable to prevent a function from being called again while the previous call is still ongoing
Creates is_following_mouse variable to handle when fruits should follow the mouse cursor and when then should drop normally
```
@onready var is_ready = true
var is_following_mouse = true
```

**Lines 18-19:**
Creates score variable to count score 
Creates score_path variable to hold the filepath to the score label on the 2D model of the main scene
```
@onready var score = 0
@onready var score_path = get_node("/root/Main/Score")
```

**Line 22:**
Called whenever an input event occurs and passes an event variable that returns the input type and related information
```
func _input(_event):
```

**Line 25:**
Runs the function if the player clicks and i
```
	#Run function on mouse 1 press and check that 
	#previous function call has finished
	if Input.is_action_pressed("click") and is_ready == true:
```
		#Set check variable to false to prevent concurrent calls
		is_ready = false
		
		#Turn off mouse following and drop the current fruit
		is_following_mouse = false
		new_fruit.gravity_scale = 1.0
		
		#Creates new fruit 
		var next_fruit = fruit_types[randi() % (fruit_types.size() - 2)]
		new_fruit = next_fruit.instantiate()
		new_fruit.gravity_scale = 0.0
		
		#Wait for 0.7 seconds for previous fruit to finish falling
		await get_tree().create_timer(0.7).timeout
		
		#Make the new fruit invisible and set 
		#to follow mouse before spawning in new fruit
		new_fruit.hide()
		is_following_mouse = true
		add_child(new_fruit)
		
		#Wait for brief moment to allow the new fruit to 
		#lock onto mouse position before making the fruit 
		#visible to prevent "motion blur" effect
		await get_tree().create_timer(0.005).timeout
		new_fruit.set_visible(true)
		
		#Now function is ready to be called again
		is_ready = true
```

```
#Spawning the "fused fruit"
func spawn_fruit(type, pos, scoring):
	var fruit = fruit_types[type].instantiate()
	fruit.position = pos
	fruit.gravity_scale = 1.0
	add_child.call_deferred(fruit)
	
	#Adding score for sucessful fusions
	score += scoring
	score_path.set_text("Score: " + str(score))
```	

 ```
func _ready():
	#Spawning first fruit of the game
	new_fruit.gravity_scale = 0.0
	add_child(new_fruit)
```

```
func _process(_delta):
	#Implementing the lock onto the mouse
	if is_following_mouse:
		new_fruit.move_and_collide(Vector2(get_viewport().get_mouse_position().x - new_fruit.position.x,0.0))
```

```
#Ends the game
func gameover():
	get_tree().paused = true
```


**Lines 22:**
func_input(_event):
**Lines 25:**
**Lines 28:**
**Lines 31-32:**
**Lines 35-37:**
**Lines 40:**
**Lines 44-46:**
**Lines 51-52:**
**Lines 55:**
**Lines 58-62:**
**Lines 65-66:**
**Lines 69:**
**Lines 71-72:**
**Lines 75:**
**Lines 77-78:**
**Lines 81-82:**
### Grape:
### Strawberry:
### Orange:
### Watermelon:
