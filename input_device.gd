class_name InputDevice
extends Resource

@export var filter_input: bool
@export var is_joypad: bool
@export var id: int

var actions_set_up: bool:
	get:
		return not custom_actions.is_empty()
	set(value):
		push_error("Cannot set actions_set_up directly as it depends on custom_actions.")
var custom_actions: Array[StringName] = []

## @param event_device The device of an input to be associated with the new input device.
static func create(new_filter_input: bool, new_is_joypad: bool, event_device: int) -> InputDevice:
	var input_device := InputDevice.new()
	input_device.filter_input = new_filter_input
	input_device.is_joypad = new_is_joypad
	input_device.id = determine_device_id(event_device)
	return input_device

static func is_event_joypad(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion

static func determine_device_id(event_device: int) -> int:
	if event_device == InputEvent.DEVICE_ID_MOUSE:
		return InputEvent.DEVICE_ID_KEYBOARD
	return event_device

static func set_joypad_event_device(event: InputEvent, device_id: int) -> void:
	if not is_event_joypad(event):
		return
	event.device = device_id

func setup_actions() -> void:
	if not filter_input:
		return

	for action: StringName in InputMap.get_actions():
		var custom_action: StringName = get_custom_action(action)
		if InputMap.has_action(custom_action):
			push_error("Custom action %s is already occupied." % custom_action)
			continue

		InputMap.add_action(custom_action)
		for event: InputEvent in InputMap.action_get_events(action):
			var new_event: InputEvent = event.duplicate(true)
			if is_event_joypad(new_event) != is_joypad:
				continue
			if is_joypad:
				set_joypad_event_device(new_event, id)
			InputMap.action_add_event(custom_action, new_event)

		custom_actions.push_back(custom_action)

func cleanup_actions() -> void:
	for action: StringName in custom_actions:
		InputMap.erase_action(action)

func get_custom_action(action: StringName) -> StringName:
	if not filter_input:
		return action
	return "%s_custom_%s_%d" % [action, is_joypad, id]
