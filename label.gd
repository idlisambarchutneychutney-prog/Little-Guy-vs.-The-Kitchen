extends Label

@export var timer_node: Timer  # Drag your Timer node here from the Scene tree in the Inspector

func _process(_delta: float) -> void:
	if timer_node:
		text = "Time: " + str(int(timer_node.time_left)) + "s"
