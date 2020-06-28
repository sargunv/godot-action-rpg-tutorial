extends KinematicBody2D

const ENEMY_DEATH_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

export var max_speed = 50
export var time_to_max_speed = .25
onready var acceleration = (max_speed / time_to_max_speed)

enum {
    IDLE,
    WANDER,
    CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

func _ready() -> void:
    $Sprite.frame = int(rand_range(0, $Sprite.frames.frames.size()))

func _physics_process(delta: float) -> void:
    knockback = knockback.move_toward(Vector2.ZERO, delta * acceleration)
    knockback = move_and_slide(knockback)

    match state:
        IDLE:
            seek_player()
            idle_or_wander_if_timeout()
            velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
        WANDER:
            seek_player()
            idle_or_wander_if_timeout()
            if global_position.distance_to($WanderController.target_position) > max_speed / 10:
                var direction: Vector2 = global_position.direction_to($WanderController.target_position)
                velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
            else:
                state = IDLE
        CHASE:
            var player = $PlayerDetectionZone.player
            if player != null:
                var direction: Vector2 = global_position.direction_to(player.global_position)
                velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
            else:
                state = IDLE

    if velocity.x < 0:
        $Sprite.flip_h = true
    elif velocity.x > 0:
        $Sprite.flip_h = false

    velocity += $SoftCollision.get_push_vector() * delta * 400
    velocity = move_and_slide(velocity)

func seek_player():
    if $PlayerDetectionZone.can_see_player():
        state = CHASE

func idle_or_wander_if_timeout():
    if $WanderController.get_time_left() == 0:
        state = pick_random_state([IDLE, WANDER])
        $WanderController.start_timer(rand_range(1, 3))

func pick_random_state(state_list):
    return state_list[int(rand_range(0, state_list.size()))]

func _on_HurtBox_area_entered(area: Area2D) -> void:
    $Stats.health -= area.damage
    knockback = area.knockback_vector * 120
    $HurtBox.create_hit_effect()

func _on_Stats_no_health() -> void:
    queue_free()
    var effectInstance = ENEMY_DEATH_EFFECT.instance()
    get_parent().add_child(effectInstance)
    effectInstance.position = position
