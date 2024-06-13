# Frusion
### Video Demo:
### Description:
Frusion is a game where you drop fruit into a bucket and attempt to fuse fruit together by getting 2 of the same size of fruit to touch. The bigger the fusion 
the more points you get! Try to get the most amount of points before the bucket overfills with fruit. Use your mouse to move around and choose where you want
to drop your fruits.
### Scenes:
I used stock sprite assets from Godot to make the sprite images for the bucket and fruits. Then I simply added collision boxes for each object
I only changed the sizes of the balls to indicate the different types of fruit. After that it was just adding text labels to display the losing message
and the score counter

### Scripting:
#### Grape:
#### Strawberry:
#### Main:
This script controls the main scene which is the one you see when you press play. 

**Lines 1:**
Extends the main node which just means that this script applies to the main scene.

**Lines 4-7:**
Then we export all of our fruits as a "PackedScene" which means that we can create multiple instances of the same scene, meaning we can make multiple copies
of the same fruit.

**Lines 4-7:**


