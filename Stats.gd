extends Node2D

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value: int) -> void:
    max_health = max(1, value)
    if health != null && health > max_health:
        set_health(max_health)
    emit_signal("max_health_changed", value)

func set_health(value: int) -> void:
    health = clamp(value, 0, max_health)
    emit_signal("health_changed", value)
    if health <= 0:
        emit_signal("no_health")
