tool
extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _tileset

#Randomize these later
var topLeftCorner = Vector2(1,5)
var width
var height

var num_rooms


var random = RandomNumberGenerator.new()




var xPos
var tile_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize stuff here
	_tileset = get_tileset()
	
	
	num_rooms = random.randi_range(6,20)
	


	
	
	#GenerateEachRoomHere.
	var n = 4
	while n>0:
		random.randomize()
		var r_nextRoomDirection = 0
		r_nextRoomDirection = random.randi_range(0,1)
		createRoom(topLeftCorner,r_nextRoomDirection)
		

		if(r_nextRoomDirection == 0):
			topLeftCorner.x += width
			topLeftCorner.y += 4
			n -= 1
		else:
			topLeftCorner.x += 6
			topLeftCorner.y += height
			n -= 1
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func createRoom(topLeftCorner,r_nextRoomDirection):
	RandomizeWidthAndHeight()
	setFloor(topLeftCorner)
	setWalls(topLeftCorner)
	setDoor(topLeftCorner,r_nextRoomDirection)

func setFloor(startPos):
	for yPos in range(startPos.y,startPos.y+height):
		for xPos in range(startPos.x,startPos.x + width):
			tile_pos = Vector2(xPos,yPos)
			set_cellv(tile_pos, _tileset.find_tile_by_name("Floor"))


func setDoor(startPos,r_nextRoomDirection):
	random.randomize()
	var r_value = startPos.x
	print(r_nextRoomDirection)
	if(r_nextRoomDirection == 0): #Down
		random.randomize()
		r_value = random.randi_range(startPos.y+1,startPos.y+height-2)
		var doorPos = Vector2(startPos.x,r_value)
		set_cellv(doorPos, _tileset.find_tile_by_name("Gate"))
		doorPos.y += 1
		set_cellv(doorPos, _tileset.find_tile_by_name("Gate"))
	else: #Right
		random.randomize()
		r_value = random.randi_range(startPos.x+1,startPos.x+width-2)
		var doorPos = Vector2(r_value,startPos.y)
		set_cellv(doorPos, _tileset.find_tile_by_name("Gate"))
		doorPos.x += 1
		set_cellv(doorPos, _tileset.find_tile_by_name("Gate"))	


func setWalls(startPos):
	for xPos in range(startPos.x,startPos.x + width):
		tile_pos = Vector2(xPos,startPos.y)
		set_cellv(tile_pos, _tileset.find_tile_by_name("Boundary"))
	for xPos in range(startPos.x,startPos.x + width):
		tile_pos = Vector2(xPos,startPos.y+height)
		set_cellv(tile_pos, _tileset.find_tile_by_name("Boundary"))
	for yPos in range(startPos.y,startPos.y + height):
		tile_pos = Vector2(startPos.x,yPos)
		set_cellv(tile_pos, _tileset.find_tile_by_name("Boundary"))
	for yPos in range(startPos.y,startPos.y + height+1):
		tile_pos = Vector2(startPos.x+width,yPos)
		set_cellv(tile_pos, _tileset.find_tile_by_name("Boundary"))



func RandomizeWidthAndHeight():
	random.randomize()
	width = random.randi_range(3,40)
	height = random.randi_range(5,40)
