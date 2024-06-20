extends Area2D
class_name HitboxComponent

# Requires HealthComponent for this to work
@export var health_component: HealthComponent

func _ready():
	if not health_component:
		assert(false, 'HealthComponent not found')
		return

	if self.has_signal('area_entered'):
		self.connect('area_entered', self.damage)

func damage(area):
	if area.is_in_group('enemies') or area.is_in_group('enemy_bullets'):
		health_component.damage()
	if area.is_in_group('enemies') and area.has_method('explode'):
		area.explode()
	if area.is_in_group('enemy_bullets'):
		area.queue_free()
