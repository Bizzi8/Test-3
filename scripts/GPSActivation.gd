extends Node

var gps_provider

signal location_updated(longitude: float, latitude: float)

func _ready():
  #The rest of your startup code goes here as usual
	get_tree().on_request_permissions_result.connect(permCheck)
  
  #NOTE: OS.request_permissions() should be called from a button the user actively touches after being informed of 
  #what the button will enable.  This is placed in _ready() only to indicate this must be called, and how to structure
  #handling the 2 paths code can follow after calling it.

	var allowed = OS.request_permissions() 
	if allowed:
		enableGPS()

func permCheck(permName, wasGranted):
	if permName == "android.permission.ACCESS_FINE_LOCATION" and wasGranted == true:
		enableGPS()

func enableGPS():
	gps_provider = Engine.get_singleton("PraxisMapperGPSPlugin")
	if gps_provider != null:
		gps_provider.onLocationUpdates.connect(update_location)
		gps_provider.StartListening()

func update_location(location_data: Dictionary):
	if location_data.has("longitude") and location_data.has("latitude"):
		var lon = location_data["longitude"]
		var lat = location_data["latitude"]
		
		#var speed = location_data.get("speed", 0.0)
		
		emit_signal("location_updated", lon , lat)
		print(str(lon) + "," + str(lat))
