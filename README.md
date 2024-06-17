# Frusion
## Video Demo:
## Description:
Frusion is a game where you drop fruit into a bucket and attempt to fuse fruit together by getting 2 of the same size of fruit to touch. The bigger the fusion 
the more points you get! Try to get the most amount of points before the bucket overfills with fruit. Use your mouse to move around and choose where you want
to drop your fruits.
## Scenes:
I used stock sprite assets from Godot to make the sprite images for the bucket and fruits. Then I simply added collision boxes for each object
I only changed the sizes of the balls to indicate the different types of fruit. After that it was just adding text labels to display the losing message
and the score counter

## Scripting:
### Main:
This script controls the main scene which is the one you see when you press play. As a whole it handles the spawning of fruits, the dropping of those fruits,
the spawning of the new fused fruits, and the game over when the bucket is filled.

**Lines 1:**
Extends the main node which just means that this script applies to the main scene.

**Lines 4-7:**
Exports all of our fruits as "PackedScene" which means that we can create multiple instances of the same scene, meaning we can make multiple copies
of the same fruit.

**Lines 10-11:**
Creates list variable of all the fruit types and another variable to randomly select the first fruit spawned in the scene

**Lines 14-15:**
Creates 2 check variables to handle when and which fruits should follow the mouse cursor 

**Lines 18-19:**
Creates 1 variable to count score and 1 variable to hold the filepath to the score label on the 2D model of the main scene
amous

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
