extends Area2D

const HIT_EFFECT = preload("res://Effects/HitEffect.tscn")

var invincible: bool = false

signal invincibility_started
signal invincibility_ended

func start_invincibility(duration: float) -> void:
    invincible = true
    $Timer.start(duration)
    emit_signal("invincibility_started")

func create_hit_effect() -> void:
    var effect = HIT_EFFECT.instance()
    get_tree().current_scene.add_child(effect)
    effect.global_position = global_position

func _on_Timer_timeout() -> void:
    invincible = false
    emit_signal("invincibility_ended")

func _on_HurtBox_invincibility_started() -> void:
    $CollisionShape2D.set_deferred("disabled", true)

func _on_HurtBox_invincibility_ended() -> void:
    $CollisionShape2D.disabled = false
