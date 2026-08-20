extends Node

func _ready() -> void:
	GpsActivation.location_updated.connect(show_location)
	#show_location(0.0)

func show_location(longitude: float, latitude: float):
	$".".text = str(longitude) + ", " + str(latitude)
