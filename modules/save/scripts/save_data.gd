class_name SaveData
extends RefCounted

## Describe la forma del archivo de guardado: versión + una sección por
## módulo (cada manager aporta la suya vía get_save_data()). SaveManager usa
## esta clase como contrato; la lógica de leer/escribir a disco vive en
## autoloads/save_manager.gd.

var save_version: int = GameConstants.SAVE_VERSION
var modules: Dictionary = {}


func to_dict() -> Dictionary:
	return {
		"save_version": save_version,
		"modules": modules,
	}


static func from_dict(data: Dictionary) -> SaveData:
	var save := SaveData.new()
	save.save_version = data.get("save_version", GameConstants.SAVE_VERSION)
	save.modules = data.get("modules", {})
	return save
