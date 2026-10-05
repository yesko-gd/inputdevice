# What is it

It's a script made for Godot 4+ that helps with handling input devices, by adding custom actions for each one at runtime.

# How to use

## Installation

Just put the script somewhere in your project, the class InputDevice exposes all functionality.

## Usage

To create a new device, use the static function `create` (not the default constructor).

There are also static helper functions:
`is_event_joypad` - Determines whether an event should be considered a joypad when constructing a matching device.
`determine_device_id` - Determines the ID used to uniquely identify a device matching the event.
`set_joypad_event_device` - Sets the event's device to the given ID, or returns if the event is not joypad.

To set up the custom actions, call `setup_actions` **exactly once** per device when all needed actions are in Godot's InputMap. To clean up a device's actions, use `cleanup_actions`.
Custom events can be queried as usual, but with the action returned by `get_custom_action`.
