# Calculates acceleration to take an agent to its target's location. The
# calculation attempts to arrive with zero remaining velocity.
class_name GSTArrive
extends GSTSteeringBehavior


# Target agent to arrive to.
var target: GSTAgentLocation
# Distance from the target for the agent to be considered successfully
# arrived.
var arrival_tolerance: float
# Distance from the target for the agent to begin slowing down.
var deceleration_radius: float
# Represents the time it takes to change acceleration.
var time_to_reach := 0.1


func _init(agent: GSTSteeringAgent, _target: GSTAgentLocation).(agent) -> void:
	target = _target


func _arrive(acceleration: GSTTargetAcceleration, target_position: Vector3) -> void:
	var to_target := target_position - agent.position
	var distance := to_target.length()

	if distance <= arrival_tolerance:
		acceleration.set_zero()
	else:
		var desired_speed := agent.linear_speed_max

		if distance <= deceleration_radius:
			desired_speed *= distance / deceleration_radius

		var desired_velocity := to_target * desired_speed/distance

		desired_velocity = (desired_velocity - agent.linear_velocity) * 1.0 / time_to_reach

		acceleration.linear = GSTUtils.clampedv3(desired_velocity, agent.linear_acceleration_max)
		acceleration.angular = 0


func _calculate_steering(acceleration: GSTTargetAcceleration) -> void:
	_arrive(acceleration, target.position)
