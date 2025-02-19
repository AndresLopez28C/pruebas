extends ColorRect

const MAX_BLIPS := 15 # Maximum blips that can be displayed at one time. Set the MAX_BLIPS constant in the shader to the same value.
const MAX_PULSE := 2.0 # How far the pulse will go until it resets. The edge of the tracker is 1.0.
const PULSE_SPEED := 1.0 # How fast the pulse moves, e.g 1.0 = one second to reach edge of tracker, 2.0 = half a second and so on.
const SCALE := 400.0 # How many pixels in global space the tracker's radius equals.
const BLIP_PARKED_POS := Vector2(2.0, 2.0) # Where unused blips are 'parked' out of view.
var pulse := MAX_PULSE
var player_handle : Object = null # Handle to the player object that will be used to set the central position and rotation of the tracker.
var player_position := Vector2.ZERO
var enemy_handles := [] # Handles to all the enemy objects that will potentially be displayed on the tracker as blips.
var blip_positions := PackedVector2Array() # Positions of the displayed blips relative to the position and rotation of the player object and converted to the tracker's SCALE.
var contact_distance := -1.0
var ping_played := false


func _ready() -> void:
	blip_positions.resize(MAX_BLIPS)
	blip_positions.fill(BLIP_PARKED_POS)
	update_blip_positions()


func _physics_process(delta : float) -> void:
	if is_instance_valid(player_handle):
		pulse += PULSE_SPEED * delta
		if pulse > MAX_PULSE:
			pulse -= MAX_PULSE
			player_position = player_handle.global_position
			update_blip_positions()
			ping_played = contact_distance == -1.0
# Insert code to play sound effect of initial tracker ping here, e.g:
			#$TrackerSFX.play()

# Insert code to reset contact distance displayed here, e.g:
			if contact_distance == -1.0:
				print("bip")
			#	$ContactDistance.text = "-------"
			

# Insert code to update contact distance displayed and play contact sound effect here, e.g:
		if not ping_played and pulse >= contact_distance:
			ping_played = true
			#$ContactDistance.text = "%4.2f" % (contact_distance * SCALE)
			#$ContactSFX.pitch_scale = 2.0 - contact_distance
			#$ContactSFX.play()
			print("enemigo")

		material.set_shader_parameter("pulse", pulse)

# If you do not want the blips to rotate remove the following line:
		material.set_shader_parameter("rotation", player_handle.rotation + PI / 2.0)
# If you do not want the blips to move remove the following line:
		material.set_shader_parameter("offset", (player_handle.global_position - player_position) / SCALE)


func setup_player(handle : Object) -> void:
	player_handle = handle


func add_enemy(handle : Object) -> void:
	enemy_handles.append(handle)


func remove_enemy(handle : Object) -> void:
	enemy_handles.erase(handle)


func update_blip_positions() -> void:
	var a := 0
	var lengths := []
	contact_distance = -1.0

	for i in range(enemy_handles.size() - 1, -1, -1):
		if is_instance_valid(enemy_handles[i]):
			var pos : Vector2 = (enemy_handles[i].global_position - player_handle.global_position) / SCALE
			var l := pos.length()

# If you are showing the corners of the tracker and rotating the blips then replace the following line of code with:
			#if abs(pos.rotated(-player_handle.rotation).x) <= 1.0 and abs(pos.rotated(-player_handle.rotation).y) <= 1.0:
# Or if you are showing the corners of the tracker but not rotating the blips then replace the follow line of code with:
			#if abs(pos.x) <= 1.0 and abs(pos.y) <= 1.0:
# If you are making a semicircular tracker add the following to the end of the if statement:
# and pos.rotated(-player_handle.rotation).y <= 0.0:
			if l <= 1.0:
				if contact_distance == -1.0 or l < contact_distance:
					contact_distance = l

# Simple code that can be used if there will never be more enemies in enemy_handles than MAX_BLIPS:
				#blip_positions.set(a, pos)
				#a +=1
				#if a == MAX_BLIPS:
					#break

# More complex code to be used if there could be more enemies in enemy_handles than MAX_BLIPS.
# If there are more enemies in range of the tracker than MAX_BLIPS then only the MAX_BLIPS number of enemies nearest the center of the tracker will be displayed:
				for b in MAX_BLIPS:
					if b == lengths.size() or l < lengths[b]:
						lengths.insert(b, l)
						blip_positions.insert(b, pos)
						a += 1
						if lengths.size() > MAX_BLIPS:
							lengths.resize(MAX_BLIPS)
							blip_positions.resize(MAX_BLIPS)
						break

# Removes the handle if it is no longer valid:
		else:
			enemy_handles.remove_at(i)

# 'Parks' any unused blips out of view:
	for i in range(a, blip_positions.size()):
		blip_positions.set(i, BLIP_PARKED_POS)

	material.set_shader_parameter("blips_arr", blip_positions)
