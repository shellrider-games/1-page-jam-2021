import "mathUtil"

MAP_ZERO_ZERO = {"x":gfx.width/4,"y":gfx.height/4}
GRID_SIZE = 32
WORLD_WIDTH = 20
WORLD_HEIGHT = 10

buttonJustPressed = false
player = new Sprite

player.image = file.loadImage("player_sprite.png")
player.col = 0
player.row = 0

player.autoSpritePosition = function()
    player.x = MAP_ZERO_ZERO.x+((1+player.col)*GRID_SIZE)
    player.y = MAP_ZERO_ZERO.y+((1+player.row)*GRID_SIZE)
end function

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