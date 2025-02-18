# Explosive Learning - Capstone 1 Project

# Summary:
### This game allows the user to control a tank. It has the ability to traverse the map and can collide with other tanks and objects. Tanks have the ability to shoot eachother and drop bombs to deal damage. Each tank has varying logic and abilities. This allows the user to fight enemies to attempt to clear different levels. After each level, the user must answer a question correctly to advance. If they answer incorrectly, they must repeat the wave. 

# Game Installation: 
### You can install this game here:
[Download Explosive Learning](https://github.com/Thaysen01/Explosive-Learning-Capstone-1/blob/main/Explosive%20Learning.exe)
### By downloading this and running it, the game should start immediately. 
### Additionally, this repo can be cloned and if the below versions are in use, the user should be able to launch this way. Note: This program is expected to function in future versions, however Godot updates often and thus creates outdated code. 

# Game Features: 
# Questions:
### The user must select which question set they would like to use. By default, they will play with an assorted list of questions, however, they may select from a list of preset question sets or upload their own JSON file to use; this must be in proper JSON format or the game will not begin (view 'assets/DefaultQuestions500.json' to see what this might look like). 
### Once the user has selected a set and the game begins, their question set will be used in the game. This question set may be as long as the user wants, however, only a maximum of 14 of these will be used in the game. After each level, the user must answer a randomly selected question correctly to advance. If they answer incorrectly, they must repeat the wave. Only once a question is answered correctly will a question be removed from the possible questions asked. After the user has answered all (or 14) of these, they have won the game. 

# Tank Abilities:
### Each tank has a unique set of instructions. Some tanks move faster, some shoot more powerful bullets, and some are very tanky. Tanks abilities can be viewed in the pause menu. Each tank has a limited amount of bullets and mines that can be on the screen at a time, creating an interesting fighting mechanic, at range. 
### Shooting: Enemy tanks will rotate their barrel differently and fire different kind of bullets. The damage this deals to the player will vary depending on the selected difficulty; this can be seen as a tooltip hovering over the difficulty on the title screen. All tanks are able to damage any other tank if one gets in the way. 
### Mines: Some tanks have the ability to drop mines around the map. Mines will explode after either a 10s delay or something collides with it (this can be bullets or other tanks). This will deal a set amount of damage to anything in a close proximity. 
### Pathfinding: If a tank has the ability to move, it will pathfind to another spot on the map. 

### Player Tank: The player may move freely around the map using WASD. They are able to shoot bullets using left-click and drop mines with right-click. 

# Tank Spawning:
### An algorithm was created to spawn 4-6 tanks per level. If there are 7 fewer questions in the question set, each level will only have 4 tanks and the user will not even get a final boss. For every extra question the user has after that, creates a round that does not add a new tank, but has 6 of the tanks that the user has already seen. With the first and last level not ever having 6 tanks, this gives the strange 14 level total. Each level will always contain 1-2 of the newest introduced tank; on the final level exactly one BOSS tank will spawn with 3 other tanks. 

# Audio / Menu Selection
### To appeal to users more, menus were added for ease of use, allowing for quick audio adjustments and file selection. 

# Versions:
### These are the versions of the tools and libraries used to run these applications:
- Gdot       : 3.12.8  [game engine]
- (GDScript) : 2.0     [programming language]
- rcedit     : 2.0.0   [tool]
  
# Coding Feats:
### To create this application, our team concurred several coding challenges. Including: 
- JSON file parsing
- Ray casting
- Path finding
- Animation
- File structuring
- Scene connection
- Spawning algorithms
- Movment physics
- Collision
- Taking user input
- Mouse detection
- Menu systems
- Audio cordination

# Assets Used
- Kenny top down tanks

### The scope of this project was developed to create an interactive education game. This game is expected to be usable for students in a classroom setting, allowing for friendly competition. Our team feels that this has been achieved. 
