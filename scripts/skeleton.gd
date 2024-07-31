extends Node2D

const SPEED = 60

var dir = 1

@onready var animated_sprite = $AnimatedSprite2D # attack_1 | attack_2 | idle | move | die | hurt

@onready var ray_right = $ray_right
@onready var ray_left = $ray_left

@onready var timer = $Timer # 1 sec timer

func _process(delta):
	if ray_right.is_colliding():
		dir = -1
		animated_sprite.flip_h = true
	if ray_left.is_colliding():
		dir = 1
		animated_sprite.flip_h = false
		
	position.x += dir * SPEED * delta
