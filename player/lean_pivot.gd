extends Node3D

@onready var head: Head = $Head


func _process(_delta: float) -> void:
	for child in head.get_children():
		child.rotation.z = -rotation.z / 2
