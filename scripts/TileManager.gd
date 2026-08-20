extends Node

var db = SQLite.new()

var x 
var y
var z = 15
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	db.path = "res://tiles/bavaria.mbtiles"
	db.open_db()


func gps_to_tile(lat:float, lon:float):
	var n = pow(2, z)
	var x = int((lon + 180.0) / 360.0 * n)
	var y = int((1.0 - log(tan(deg_to_rad(lat)) + 1.0 / cos(deg_to_rad(lat))) / PI) / 2.0 * n)
	return Vector2i(x, y)


func get_data(x: int, y: int,):
	var flipped_y = int(pow(2, z)) -1 -y
	db.query("SELECT tile_data FROM tiles WHERE zoom_level=%d AND tile_column=%d AND tile_row=%d" % [z, x, flipped_y])
	
	if db.query_result.is_empty():
		return null
	else:
		var result = db.query_result[0]["tile_data"]
		var image = Image.new()
		image.load_png_from_buffer(result)
		return ImageTexture.create_from_image(image)
