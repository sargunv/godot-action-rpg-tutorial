extends Control

export(int) var heart_width = 15

var max_hearts setget set_max_hearts
var hearts setget set_hearts

func _ready() -> void:
    self.max_hearts = PlayerStats.max_health
    self.hearts = PlayerStats.health
    PlayerStats.connect("health_changed", self, "set_hearts")
    PlayerStats.connect("max_health_changed", self, "set_max_hearts")

func set_hearts(value: int) -> void:
    hearts = clamp(value, 0, max_hearts)
    if $HeartUIFull:
        $HeartUIFull.rect_size.x = hearts * heart_width

func set_max_hearts(value: int) -> void:
    max_hearts = max(value, 0)
    if $HeartUIEmpty:
        $HeartUIEmpty.rect_size.x = max_hearts * heart_width
