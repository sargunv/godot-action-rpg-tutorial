extends AnimatedSprite

func _ready() -> void:
    connect("animation_finished", self, "_on_animation_finished")
    play()

func _on_animation_finished() -> void:
    queue_free()
