import "mathUtil"
import "listUtil"

MAP_ZERO_ZERO = {"x":gfx.width/4,"y":gfx.height/4}
GRID_SIZE = 32
WORLD_WIDTH = 19
WORLD_HEIGHT = 11

walls = [[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[4,1],[10,1],[11,1],[12,1],[13,1],[14,1],[15,1],[16,1],[17,1],[18,1],[0,2],[1,2],[2,2],[3,2],[4,2],[6,2],[7,2],[8,2],[10,2],[12,2],[13,2],[18,2],[0,3],[18,3],[0,4],[4,4],[6,4],[7,4],[9,4],[10,4],[11,4],[12,4],[13,4],[18,4],[0,5],[1,5],[2,5],[4,5],[6,5],[7,5],[9,5],[13,5],[14,5],[15,5],[16,5],[17,5],[18,5],[2,6],[9,6],[2,7],[3,7],[4,7],[8,7],[9,7],[4,8],[8,8],[4,9],[8,9],[4,10],[5,10],[6,10],[7,10],[8,10]]
goals = [[16,2],[17,2],[16,3],[17,3],[16,4],[17,4]]
boxes = [[2,3],[5,3],[5,6],[7,6],[7,7],[5,8]]

Cell = {}
Cell.type = 0
Cell.box = null

GameSprite = new Sprite
GameSprite.col = 0
GameSprite.row = 0
GameSprite.autoSpritePosition = function()
    self.x = MAP_ZERO_ZERO.x+((1+self.col)*GRID_SIZE)
    self.y = MAP_ZERO_ZERO.y+((1+self.row)*GRID_SIZE)
end function
GameSprite.init = function()
    self.autoSpritePosition
    display(4).sprites.push self
end function

Box = new GameSprite
Box.image = file.loadImage("box.png")

Wall = new GameSprite
Wall.image = file.loadImage("wall.png")


Goal = new GameSprite
Goal.image = file.loadImage("goalCell.png")

setupWorld = function()
    world = list.init2d(WORLD_WIDTH, WORLD_HEIGHT)
    for col in range(0,world.len-1)
        for row in range(0,world[col].len-1)
            world[col][row] = new Cell
        end for
    end for
    for wall in walls
        world[wall[0]][wall[1]].type = 2
    end for
    for goal in goals
        world[goal[0]][goal[1]].type = 1
    end for
    for box in boxes
        tmpBox = new Box
        tmpBox.col = box[0]
        tmpBox.row = box[1]
        world[box[0]][box[1]].box = tmpBox
        tmpBox.init
    end for
    return world
end function

renderWorld = function(world)
    gfx.color = color.silver
    gfx.fillRect floor(MAP_ZERO_ZERO.x)+GRID_SIZE/2, floor(MAP_ZERO_ZERO.y)+GRID_SIZE/2, WORLD_WIDTH*GRID_SIZE, WORLD_HEIGHT*GRID_SIZE
    for col in range(0, world.len-1)
        for row in range(0,world[col].len-1)
            if world[col][row].type == 2 then
                tmpWall = new Wall
                tmpWall.col = col
                tmpWall.row = row
                tmpWall.init
            else if world[col][row].type == 1 then
                tmpGoal = new Goal
                tmpGoal.col = col
                tmpGoal.row = row
                tmpGoal.init
            end if
        end for
    end for
end function

checkWin = function(world)
    for col in range(0, world.len-1)
        for row in range(0,world[col].len-1)
            if world[col][row].type == 1 and world[col][row].box == null then return false
        end for
    end for
    return true
end function

clear

buttonJustPressed = false

player = new GameSprite
player.col = 11
player.row = 2

tempBox = new Box
tempBox.col = 9
tempBox.row = 4
tempBox.init

world = setupWorld
renderWorld world

world[9][4].box = tempBox

player.image = file.loadImage("player_sprite.png")

player.move = function(inputArray)
    newRow = mathUtil.clamp(player.row+inputArray[0]-inputArray[2],0,WORLD_HEIGHT-1)
    newCol = mathUtil.clamp(player.col+inputArray[1]-inputArray[3],0,WORLD_WIDTH-1)
    if world[newCol][newRow].type >= 2 then return
    if world[newCol][newRow].box != null then
        overRow = newRow+inputArray[0]-inputArray[2]
        overCol = newCol+inputArray[1]-inputArray[3]
        if overCol < world.len and overRow < world[overCol].len and world[overCol][overRow].type < 2 and world[overCol][overRow].box == null then
            tmpBox = world[newCol][newRow].box
            tmpBox.col = overCol
            tmpBox.row = overRow
            tmpBox.autoSpritePosition
            world[newCol][newRow].box = null
            world[overCol][overRow].box = tmpBox
        else
            return
        end if
    end if
    player.row = newRow
    player.col = newCol
    player.autoSpritePosition
end function

player.autoSpritePosition
display(4).sprites.push player

while not key.pressed("q")
    pressedKeys = [key.pressed("up"),key.pressed("right"),key.pressed("down"),key.pressed("left")]
    if pressedKeys.sum == 1 and not buttonJustPressed then
        player.move(pressedKeys)
        buttonJustPressed = true
    end if
    if pressedKeys.sum == 0 then buttonJustPressed = false
    if checkWin(world) then break
end while
clear
if checkWin(world) then print "YOU WON - CONGRATULATIONS"