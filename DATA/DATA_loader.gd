extends Node

var main_csv
# Called when the node enters the scene tree for the first time.
func _ready():
	main_csv = load_config_csv("res://DATA/MainDATA.csv")
	

func load_config_csv(path: String) -> Dictionary:
	var config = {}
	var file = FileAccess.open(path, FileAccess.READ)
	
	if not file:
		printerr("错误：无法打开配置文件 ", path)
		return config

	while !file.eof_reached():
		var line = file.get_csv_line()
		
		# 确保这一行至少有两列（变量名和内容）
		if line.size() >= 2:
			var var_name = line[0].strip_edges()  # 去掉名字两边的空格
			var var_value = line[1].strip_edges() # 去掉内容两边的空格
			
			# 过滤掉空行或注释行（如果你想在A列用 # 写注释的话）
			if var_name == "" or var_name.begins_with("#"):
				continue
				
			# 自动转换数值类型（可选）
			if var_value.is_valid_float():
				config[var_name] = var_value.to_float()
			elif var_value.to_lower() == "true":
				config[var_name] = true
			elif var_value.to_lower() == "false":
				config[var_name] = false
			else:
				config[var_name] = var_value # 保持字符串
				
	file.close()
	return config
	
func save_dict_to_csv(path: String, data_dict: Dictionary):
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if not file:
		printerr("错误：无法打开并写入文件 ", path)
		return

	for key in data_dict.keys():
		var value = data_dict[key]
		# 将键和值组合成一行，例如: gongde_sum,1000
		var line = str(key) + "," + str(value)
		file.store_line(line)
	
	file.close()
	print("数据已成功刻录至磁盘: ", path)
