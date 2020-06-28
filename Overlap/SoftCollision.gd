extends Area2D

func get_push_vector() -> Vector2:
    var areas = get_overlapping_areas()
    if areas.size() > 0:
        return areas[0].global_position.direction_to(global_position)
    else:
        return Vector2.ZERO
