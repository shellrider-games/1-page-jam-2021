import "mathUtil"
import "listUtil"

MAP_ZERO_ZERO = {"x":gfx.width/4,"y":gfx.height/4}
GRID_SIZE = 32
WORLD_WIDTH = 20
WORLD_HEIGHT = 10

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

Box = new GameSprite
Box.image = file.loadImage("box.png")
Box.init = function()
    self.autoSpritePosition
    display(4).sprites.push self
end function

setupWorld = function()
    world = list.init2d(WORLD_WIDTH, WORLD_HEIGHT)
    for col in range(0,world.len-1)
        for row in range(0,world[col].len-1)
            world[col][row] = new Cell
        end for
    end for
    return world
end function

clear

buttonJustPressed = false

player = new GameSprite

tempBox = new Box
tempBox.col = 9
tempBox.row = 4
tempBox.init

world = setupWorld

world[9][9].box = tempBox

player.image = file.loadImage("player_sprite.png")

player.move = function(inputArray)
    player.row = mathUtil.clamp(player.row+inputArray[0]-inputArray[2],0,WORLD_HEIGHT-1)
    player.col = mathUtil.clamp(player.col+inputArray[1]-inputArray[3],0,WORLD_WIDTH-1)
    player.autoSpritePosition
end function

gfx.color = color.silver
gfx.fillRect floor(MAP_ZERO_ZERO.x)+GRID_SIZE/2, floor(MAP_ZERO_ZERO.y)+GRID_SIZE/2, WORLD_WIDTH*GRID_SIZE, WORLD_HEIGHT*GRID_SIZE

player.autoSpritePosition
display(4).sprites.push player

while not key.pressed("q")
    pressedKeys = [key.pressed("up"),key.pressed("right"),key.pressed("down"),key.pressed("left")]
    if pressedKeys.sum == 1 and not buttonJustPressed then
        player.move(pressedKeys)
        buttonJustPressed = true
    end if
    if pressedKeys.sum == 0 then buttonJustPressed = false
end while