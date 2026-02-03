using Godot;
using System;
using System.ComponentModel;
using System.Resources;
using System.Text.RegularExpressions;

public partial class temple_3 : Node2D
{

	public TextureButton downgradeButton;
	public TextureButton upgradeButton;
	public TextureButton workButton;
	public TextureButton unselectButton;

	public Node2D buttons;


	public Area2D templeArea;

	public Node2D buildingPlace;

	public PackedScene littleMonk;

	public int monk_num_within;

	public AnimatedSprite2D Sprite;

	//Signal Area
	[Signal]
	public delegate void ChangeBuildingEventHandler(int building_code);


	//单独制作一个initial方便重新调用ready
	public override void _Ready()
	{
		monk_num_within = 0;
		Sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

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





	public void ClickUnselect()
	{
		FoldButtonList();
	}

	public void ClickWork()
	{
		//创建小和尚
		PackedScene littleMonk = ResourceLoader.Load<PackedScene>("res://Char/monk_little.tscn");
		CharacterBody2D monkInstance = (CharacterBody2D)littleMonk.Instantiate();
		monkInstance.Position = new Vector2(300, -400);
		AddChild(monkInstance);

		FoldButtonList();
	}

	public void ClickUpgrade()
	{
		FoldButtonList();
	}

	public void ClickDowngrade()
	{
		EmitSignal(nameof(ChangeBuilding), 0);
		FoldButtonList();
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


	public void GetAMonk()
	{
		if (monk_num_within >= 3)
		{
			return;
		}
		monk_num_within += 1;

		if (monk_num_within == 0)
		{
			Sprite.Play("Low");
		}
		else if (monk_num_within == 1)
		{
			Sprite.Play("Median");
		}
		else
		{
			Sprite.Play("High");
		}
		return;
		
	}
}
