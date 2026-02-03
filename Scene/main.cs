using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public partial class main : Node2D
{
	

	private CustomSignals _customSignal;
	public Label gongdeAccountLabel;
	public int gongdeBalance = 0;

	public monk_little monk_1;
	public Timer monk_1_gongde_timer;

	//Drag and drop register monk
	public monk_little registered_monk;
	public Vector2? monk_little_place_pos;
	public Node2D building_system;

	//为读取指定一个路径
	[Export(PropertyHint.File,"*.csv")]

	public string appointed_csv_path = "";

	public override void _Ready()
	{
		building_system = GetNode<Node2D>("BuildingSystem");
		monk_1 = GetNode<monk_little>("MonkLittle");
		monk_1_gongde_timer = GetNode<Timer>("MonkLittle/GongdeTimer");

		gongdeAccountLabel = GetNode<Label>("/root/Main/CanvasLayer/Label");
		_customSignal = GetNode<CustomSignals>("/root/CustomSignals");
		_customSignal.ClickMuyu += gongdeIncrease;
		_customSignal.MonkLittleUnlock += MonkLittleUnlockConfirm;

		monk_1_gongde_timer.Timeout += AddGongde;

		//Drag and drop register monk
		_customSignal.MonkRegisteredToDND += register_dragged_monk;
		_customSignal.ReleaseMonkRegisteredToDND += release_dragged_monk;
		LoadAndReadCSV(appointed_csv_path);
		// GD.Print(LoadAndReadCSV(appointed_csv_path));
	}


	//载入和读取csv(注意是 Godot.Collections.Array)
	public Godot.Collections.Array LoadAndReadCSV(string csv_path)
	{
		// 先创建返回用的 Godot Array（注意是 Godot.Collections.Array）
		var csv_array_result = new Godot.Collections.Array();

		var csv_file = Godot.FileAccess.Open(csv_path, Godot.FileAccess.ModeFlags.Read);
		GD.Print("Step_B");
		if (csv_file == null)
		{
			GD.PrintErr("Main.cs func LoadAndReadCSV: CSV file no read!");
			GD.PrintErr("在Main.tscn中是否没指定路径，你可以在inspector中寻找所谓Appointed CSV");
			return csv_array_result;
		}

		while (!csv_file.EofReached())
		{
			var line = csv_file.GetLine();
			if (string.IsNullOrWhiteSpace(line))
				continue;

			var cols = new Godot.Collections.Array();
			foreach (var s in line.Split(","))
				cols.Add(s.Trim()); // 去掉前后空格
			// GD.Print(cols[0]);
				
				
			csv_array_result.Add(cols);
		}

		csv_file.Close();


		// 获取第三行（index 2）
		var thirdRow = (Godot.Collections.Array)csv_array_result[2];
		// 获取第二列（index 1）
		var secondColumn = thirdRow[1];
		var secondColumnStr = thirdRow[1].ToString(); // 先转成 string

		GD.Print(secondColumn);

		//update

		gongdeBalance = int.Parse(secondColumnStr);
		gongdeAccountLabel.Text = gongdeBalance.ToString();

		GD.Print(gongdeBalance);

		return csv_array_result;

	}




	public void AddGongde()
	{
		gongdeBalance += 1;
		gongdeAccountLabel.Text = gongdeBalance.ToString();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void CheckUnlockAllowence(int currentGongde)
	{
		GD.Print("confirm");
		if (monk_1.unlockState == false && gongdeBalance > 10)
		{
			
			monk_1.ShowUnlockButton();
			

		}
	}

	//receive signal
	public void MonkLittleUnlockConfirm()
	{
		gongdeBalance -= 10;
		monk_1_gongde_timer.Start();
		gongdeAccountLabel.Text = gongdeBalance.ToString();

		GD.Print("confirm");
	}

	public void gongdeIncrease(string MuyuMessage)
	{
		GD.Print("ddd");

		gongdeBalance += 1;
		gongdeAccountLabel.Text = gongdeBalance.ToString();

		CheckUnlockAllowence(gongdeBalance);
	}

	private void _on_button_pressed()
	{
		GD.Print("Test printed");
	}


	public void register_dragged_monk(monk_little monk)
    {
		GD.Print("registered");
		
		monk.isDragging = true;
		registered_monk = monk;
    }
	
	public void release_dragged_monk()
    {
		GD.Print("unregistered");
		monk_little_place_pos = registered_monk.GlobalPosition;
		
		if(monk_little_place_pos.HasValue)
		{
			place_dragged_monk(monk_little_place_pos.Value);
		}

		registered_monk = null;
		monk_little_place_pos = null;
    }

	public void place_dragged_monk(Vector2 monk_pos)
	{
		var building_pool = new List<Node2D>();
		foreach (Node2D child in building_system.GetChildren())
		{
			if (child is Node2D building)
        	{
            building_pool.Add(building);
        	}
		}

		var building_distance_pool = new List<float>();
		foreach (Node2D child in building_pool)
		{

			float distance = monk_pos.DistanceTo(child.GlobalPosition);
			building_distance_pool.Add(distance);
		}

		// 计算monk到建筑的距离中最小的值
		int minIndex = 0;
		float minValue = building_distance_pool[0];

		for (int i = 1; i < building_distance_pool.Count; i++)
		{
			if(building_distance_pool[i] < minValue)
			{
				minValue = building_distance_pool[i];
				minIndex = i;
			}
		}
		GD.Print("最小值是 " + minValue + "，索引是 " + minIndex);

		
		if (minValue < 50)
		{
			GD.Print(building_pool[minIndex].HasMethod("GetAMonk"));
			if (building_pool[minIndex].HasMethod("GetAMonk"))
			{
				GD.Print("XXXXXXXXXXX");
				registered_monk.Hide();
				building_pool[minIndex].Scale *= 1.05f;
				building_pool[minIndex].Call("GetAMonk");
			}
			building_pool[minIndex].Scale *= 1.05f;
		}
	}
}