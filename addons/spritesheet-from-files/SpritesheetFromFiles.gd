@tool
extends MarginContainer

@onready var data                  = $Data
@onready var spritesheet_generator = $SpriteSheetGenerator
@onready var options               = $VBoxContainer/Mid/Options
@onready var actions               = $VBoxContainer/Actions
@onready var file_list             = $VBoxContainer/Mid/FileList
var editor_interface

# TODO
# add renaming of files in a way that they can be matched at export time
# so source files of spritesheets can be excluded from export and avoid bloating
# exported game size.

func _on_files_selected(files : Array, _biggest_size):
	options.enabled = files.size() > 0
	actions.enabled = options.enabled

func _on_process_started(output_file : String):
	data.output_file = output_file
	spritesheet_generator.process(data)

func _on_process_finished(file_path: String, err):
	var label = $VBoxContainer/Label
	label.visible = true
	if err != 0:
		label.text = "Error saving png: " + str(err)
	else:
		label.text = "File saved at " + file_path
	await get_tree().create_timer(5.0).timeout
	label.visible = false

func _ready():
	options.connect("changed",Callable(data,"_on_options_changed"))
	options.connect("changed",Callable(file_list,"_on_options_changed"))
	actions.connect("files_selected",Callable(self,"_on_files_selected"))
	actions.connect("files_selected",Callable(data,"_on_files_selected"))
	actions.connect("files_selected",Callable(options,"_on_files_selected"))
	actions.connect("files_selected",Callable(file_list,"_on_files_selected"))
	actions.connect("process_started",Callable(self,"_on_process_started"))
	spritesheet_generator.connect("process_finished",Callable(self,"_on_process_finished"))
	print(editor_interface)
	print(actions.editor_interface)
	actions.editor_interface = editor_interface
	print(actions.editor_interface)
