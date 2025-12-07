using Godot;
using System;
using System.Numerics;

public partial class monk_little : CharacterBody2D
{
	[Export] public float Gravity = 900f;    // 重力值


	public bool isUnlock = false;
	public AnimatedSprite2D sprite;
	public Button unlockButton;
	public bool unlockState = false;

	//抓取
	public bool isDragging;
	public Godot.Vector2 draggingoffset;

	public Node stateMachine;


	private CustomSignals _customSignal;
	private Color LockedColor;
	private Color UnlockedColor;
	private Area2D dragArea;
	private main mainScene;



	public override void _Ready()
	{
		isDragging = false;

		_customSignal = GetNode<CustomSignals>("/root/CustomSignals");
		sprite = GetNode<AnimatedSprite2D>("Sprite");
		unlockButton = GetNode<Button>("UnlockButton");
		dragArea = GetNode<Area2D>("DragArea2D");

		stateMachine = GetNode<Node>("StateMachine");

		unlockButton.Pressed += Unlock;
		dragArea.InputEvent += DragInteraction;

		LockedColor = new Color(0.1f, 0.1f, 0.1f, 1.0f);
		UnlockedColor = new Color(1.0f, 1.0f, 1.0f, 1.0f);
		sprite.Modulate = LockedColor;

		Tween hide_tween = GetTree().CreateTween();
		hide_tween.TweenProperty(unlockButton, "scale", Godot.Vector2.Zero, 0.1);

	}

	public void ShowUnlockButton()
	{
		Tween showButtonTween = GetTree().CreateTween();
		showButtonTween.TweenProperty(unlockButton, "scale", Godot.Vector2.One, 0.1f);
	}
	public void Unlock()
	{
		TurnOnPrayAction();
		unlockButton.Disabled = true;

		unlockButton.Hide();

		stateMachine.Call("ready_start");


		_customSignal.EmitSignal(nameof(_customSignal.MonkLittleUnlock));
	}



	public override void _Process(double delta)
    {
        if (isDragging)
			{
				GlobalPosition = GetGlobalMousePosition() - draggingoffset;
				GD.Print("Dragging...");
			}
    }

	private void TurnOnPrayAction()
	{
		sprite.Modulate = UnlockedColor;
		sprite.Play();
		var frames = sprite.SpriteFrames;
		frames.SetAnimationLoop("default", true);

	}


	private void DragInteraction(Node viewport, InputEvent @event, long shape_idx)
		{
			if (@event is InputEventMouseButton mouseEvent)
			{
				if (mouseEvent.ButtonIndex == MouseButton.Left)
				{
					if (mouseEvent.Pressed)
					{
						
						// _draggingoffset = GetGlobalMousePosition() - GlobalPosition;

						// 发射信号，注册这个 monk
						_customSignal.EmitSignal(nameof(_customSignal.MonkRegisteredToDND), this);
						Gravity = 0f;
						// GD.Print("Start dragging");
						// GD.Print(isDragging);
						
						
						if (isDragging == true)
						{
						draggingoffset = GetGlobalMousePosition() - GlobalPosition;
						}
					}
					else
					{
						isDragging = false;
						Gravity = 800f;
						_customSignal.EmitSignal(nameof(_customSignal.ReleaseMonkRegisteredToDND));
						GD.Print("Released");
					}
				}
			}
			else if (@event is InputEventMouseMotion)
			{
				// if (isDragging)
				// {
				// 	GlobalPosition = GetGlobalMousePosition() - draggingoffset;
				// 	GD.Print("Dragging...");
				// }
			}
		}



	public override void _PhysicsProcess(double delta)
	{
		Godot.Vector2 vel = Velocity;


		// 重力
		if (!IsOnFloor())
			vel.Y += Gravity * (float)delta;
		else
			vel.Y = 0;

		Velocity = vel; // 重新赋值
		MoveAndSlide(); // 应用速度
	}

}



