# This script creates basic sprite assets programmatically
# Run this in Godot editor to generate the basic sprites

@tool
extends EditorScript

func _run():
	create_player_sprite()
	create_wall_sprite()
	create_door_sprite()
	create_exit_sprite()
	create_heart_sprite()
	print("Basic sprites created!")

func create_player_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.CYAN)
	var texture = ImageTexture.new()
	texture.set_image(image)
	ResourceSaver.save(texture, "res://assets/player.png")

func create_wall_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.DIM_GRAY)
	var texture = ImageTexture.new()
	texture.set_image(image)
	ResourceSaver.save(texture, "res://assets/wall.png")

func create_door_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.SADDLE_BROWN)
	var texture = ImageTexture.new()
	texture.set_image(image)
	ResourceSaver.save(texture, "res://assets/door.png")

func create_exit_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.GOLD)
	var texture = ImageTexture.new()
	texture.set_image(image)
	ResourceSaver.save(texture, "res://assets/exit.png")

func create_heart_sprite():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Draw a simple heart shape
	for y in range(32):
		for x in range(32):
			var nx = (x - 16.0) / 16.0
			var ny = (y - 16.0) / 16.0
			
			# Heart equation: (x^2 + y^2 - 1)^3 - x^2*y^3 <= 0
			var heart_eq = pow(nx*nx + ny*ny - 0.5, 3) - nx*nx * ny*ny*ny
			if heart_eq <= 0:
				image.set_pixel(x, y, Color.RED)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	ResourceSaver.save(texture, "res://assets/heart.png")