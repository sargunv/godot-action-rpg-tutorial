extends KinematicBody2D

const ENEMY_DEATH_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")
const PLAYER_HURT_SOUND = preload("res://Player/PlayerHurtSound.tscn")

export(int) var max_speed = 100
export(float) var roll_speed_multiplier = 1.5
export(float) var time_to_max_speed = .25
onready var acceleration = max_speed / time_to_max_speed

enum {
    MOVE, ROLL, ATTACK
}

var velocity: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.DOWN
var state = MOVE

onready var animationState: AnimationNodeStateMachinePlayback = $AnimationTree.get('parameters/playback')

func _ready() -> void:
    PlayerStats.connect("no_health", self, "_on_PlayerStats_no_health")
    $AnimationTree.active = true
    $HitboxPivot/SwordHitbox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
    match(state):
        MOVE:
            process_move_state(delta)
        ROLL:
            process_roll_state(delta)
        ATTACK:
            process_attack_state(delta)

func process_move_state(delta: float) -> void:
    var input_vector: Vector2 = get_move_input()
    set_move_animation(input_vector)

    if input_vector != Vector2.ZERO:
        roll_vector = input_vector.normalized()
        $HitboxPivot/SwordHitbox.knockback_vector = roll_vector

    velocity = velocity.move_toward(max_speed * input_vector, acceleration * delta)
    move()

    if Input.is_action_just_pressed('attack'):
        state = ATTACK
    if Input.is_action_just_pressed('roll'):
        state = ROLL

func process_roll_state(_delta: float) -> void:
    animationState.travel('Roll')
    velocity = roll_vector * max_speed * roll_speed_multiplier
    move()

func process_attack_state(_delta: float) -> void:
    animationState.travel('Attack')
    velocity = Vector2.ZERO

func move() -> void:
    velocity = move_and_slide(velocity)

func get_move_input() -> Vector2:
    return Vector2(
        Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
        Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
    ).normalized()

func set_move_animation(input_vector: Vector2) -> void:
    if input_vector.length() == 0:
        animationState.travel('Idle')
    else:
        animationState.travel('Run')
        $AnimationTree.set('parameters/Idle/blend_position', input_vector)
        $AnimationTree.set('parameters/Run/blend_position', input_vector)
        $AnimationTree.set('parameters/Attack/blend_position', input_vector)
        $AnimationTree.set('parameters/Roll/blend_position', input_vector)

func on_roll_animation_finished() -> void:
    state = MOVE
    velocity *= .5

func on_attack_animation_finished() -> void:
    state = MOVE

func _on_HurtBox_area_entered(area: Area2D) -> void:
    PlayerStats.health -= area.damage
    $HurtBox.start_invincibility(.6)
    $HurtBox.create_hit_effect()
    get_tree().current_scene.add_child(PLAYER_HURT_SOUND.instance())

func _on_PlayerStats_no_health() -> void:
    queue_free()
    var effectInstance = ENEMY_DEATH_EFFECT.instance()
    get_parent().add_child(effectInstance)
    effectInstance.position = position


func _on_HurtBox_invincibility_started() -> void:
    $BlinkAnimationPlayer.play("Start")


func _on_HurtBox_invincibility_ended() -> void:
    $BlinkAnimationPlayer.play("Stop")
