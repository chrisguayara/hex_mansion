extends TileMapLayer


@onready var DoorLocked = true
var checkedAlready = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DoorLocked:
		visible =true
		collision_enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not checkedAlready:
		DoorLocked = false
		if checkIfLocked() == true:
			checkedAlready = true
			

func checkIfLocked() -> bool:
	if not DoorLocked:
		collision_enabled = false
		visible = false
		return true
	return false
