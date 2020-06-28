extends Node2D

export(int) var wander_range = 32

onready var start_position: Vector2 = global_position
onready var target_position: Vector2 = global_position

func update_target_position() -> void:
    var offset = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
    target_position = start_position + offset

func get_time_left() -> float:
    return $Timer.time_left

func start_timer(duration: float) -> void:
    $Timer.start(duration)

func _on_Timer_timeout() -> void:
    update_target_position()
