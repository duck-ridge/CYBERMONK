using Godot;
using System;
using System.ComponentModel;
using System.Resources;

public partial class temple_1 : Node2D
{

	public TextureButton downgradeButton;
	public TextureButton upgradeButton;
	public TextureButton workButton;
	public TextureButton unselectButton;

	public Node2D buttons;


	public Area2D templeArea;

	public Node2D buildingPlace;

	public PackedScene littleMonk;

	public TextureProgressBar monkBar;
	public int monk_num_within = 0;

	//Signal Area
	[Signal]
	public delegate void ChangeBuildingEventHandler(int building_code);





	//单独制作一个initial方便重新调用ready
	public override void _Ready()
	{
		//小和尚的实例化
		// PackedScene littleMonk = ResourceLoader.Load<PackedScene>("res://Char/monk_little.tscn");
		// CharacterBody2D monkInstance = (CharacterBody2D)littleMonk.Instantiate();
		// monkInstance.Position = new Vector2(300, -100);
		// AddChild(monkInstance);
		monkBar = GetNode<TextureProgressBar>("MonkNumBar");
		buttons = GetNode<Node2D>("Buttons");
		downgradeButton = GetNode<TextureButton>("Buttons/HBoxContainer/DowngradeButton");
		upgradeButton = GetNode<TextureButton>("Buttons/HBoxContainer/UpgradeButton");
		workButton = GetNode<TextureButton>("Buttons/HBoxContainer/WorkButton");
		unselectButton = GetNode<TextureButton>("Buttons/HBoxContainer/UnselectButton");

		buildingPlace = GetNode<Node2D>("../..");

		templeArea = GetNode<Area2D>("Area2D");
		templeArea.InputEvent += ClickBuilding;

		unselectButton.Pressed += ClickUnselect;
		workButton.Pressed += ClickWork;
		upgradeButton.Pressed += ClickUpgrade;
		downgradeButton.Pressed += ClickDowngrade;
		Initialize();


    }


	// Called when the node enters the scene tree for the first time.
	public void Initialize()
	{

			
		buttons.Scale = Vector2.Zero;
	}



	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void ClickBuilding(Node vivewport, InputEvent @event, long shape_idx)
	{
		if (@event is InputEventMouseButton mouseEvent)
		{
			if (mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Left)
			{
				UnfoldButtonList();
			}
		}

	}


    public void GetAMonk(monk_little Monk)
    {
        if (monk_num_within >= 3) return;

        monk_num_within += 1;
        UpdateAnimation();

        if (IsInstanceValid(Monk))
            Monk.QueueFree();
    }

    public void ReleaseAMonk()
    {
        if (monk_num_within <= 0) return;
        monk_num_within -= 1;
        UpdateAnimation();
    }

    private void UpdateAnimation()
    {

        monkBar.Value = monk_num_within;
    }


    public void ClickWork()
    {
        if (monk_num_within <= 0) return;

        // 1. 加载并实例化小和尚，直接转换为 monk_little 类型
        PackedScene monkScene = GD.Load<PackedScene>("res://Char/monk_little.tscn");
        monk_little monk = monkScene.Instantiate<monk_little>();

        // 2. 获取主场景并添加子节点
        main world_system = GetTree().CurrentScene as main;
        if (world_system != null)
        {
            // 确保加入到主场景专门管理和尚的 MonkSystem 节点下
            if (world_system.MonkSystem != null)
                world_system.MonkSystem.AddChild(monk);
            else
                world_system.AddChild(monk);
        }

        // 3. 设置位置 (GlobalPosition 比较稳妥)
        monk.GlobalPosition = GlobalPosition + new Vector2(50, 50);

        // 4. 【关键修复】直接调用方法，不要用 Call
        // 只要调用 Unlock，小和尚内部的 Timer 就会启动（基于我们之前改过的 monk_little 逻辑）
        monk.Unlock();

        // 5. 扣除寺庙内的数量并更新动画
        ReleaseAMonk();
        FoldButtonList();
    }


	// public override void _Input(InputEvent @event)
	// {
	//     if (@event is InputEventMouseButton mouseEvent)
	// 	{
	// 		if (!mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Left)
	//         {
	// 			GD.Print("XX");
	//         }
	//     }
	// }


	public void ClickUnselect()
	{
		FoldButtonList();
	}

	// public void ClickWork()
	// {
	// 	//创建小和尚
	// 	PackedScene littleMonk = ResourceLoader.Load<PackedScene>("res://Char/monk_little.tscn");
	// 	CharacterBody2D monkInstance = (CharacterBody2D)littleMonk.Instantiate();
	// 	monkInstance.Position = new Vector2(300, -400);
	// 	AddChild(monkInstance);

	// 	FoldButtonList();
	// }

	public void ClickUpgrade()
	{
		FoldButtonList();
	}

	public void ClickDowngrade()
	{
		EmitSignal(nameof(ChangeBuilding), 0);
		FoldButtonList();
		main world_system = GetTree().CurrentScene as main;
		world_system.MonkNumMax -= 5;
		if (world_system.MonkNumMax < 2)
		{
			world_system.MonkNumMax = 1;
		}
	}
	
	

	public void UnfoldButtonList()
	{
		Tween tween = GetTree().CreateTween();
		tween.TweenProperty(buttons, "scale", Vector2.One, 0.2);
	}
	

	public void FoldButtonList()
    {
		Tween tween = GetTree().CreateTween();
		tween.TweenProperty(buttons, "scale", Vector2.Zero, 0.2);
    }
}
