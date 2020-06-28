extends Camera2D

func _ready() -> void:
    limit_top = $Limits/TopLeft.position.y
    limit_left = $Limits/TopLeft.position.x
    limit_bottom = $Limits/BottomRight.position.y
    limit_right = $Limits/BottomRight.position.x
