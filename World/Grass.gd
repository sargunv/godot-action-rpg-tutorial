extends Node2D

const GRASS_EFFECT = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect() -> void:
    var effectInstance = GRASS_EFFECT.instance()
    get_parent().add_child(effectInstance)
    effectInstance.position = position

func _on_HurtBox_area_entered(_area: Area2D) -> void:
    create_grass_effect()
    queue_free()
