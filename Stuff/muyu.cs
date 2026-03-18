using Godot;
using System;

public partial class muyu : Node2D
{

	public int MuyuClickValue;

	[Export]
	public int MuyuClickValueIron = 1;
	[Export]
	public int MuyuClickValueSilver = 3;
	[Export]
	public int MuyuClickValueGolden = 8;

	//custom signal singleton 其实是个global
	private CustomSignals _customSignal;
	private AudioStreamPlayer _muyusound;
	public AnimatedSprite2D MuyuSprite;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		MuyuClickValue = MuyuClickValueIron;

		_customSignal = GetNode<CustomSignals>("/root/CustomSignals");
		_customSignal.ClickMuyu += TapTheMuyu;

		_muyusound = GetNode<AudioStreamPlayer>("MuyuSound");
		MuyuSprite = GetNode<AnimatedSprite2D>("MuyuSprite");
	}

	public void TapTheMuyu(int MuyuClickValue)
	{
		_muyusound.Play();
		Tween tween = GetTree().CreateTween();
		tween.TweenProperty(this, "scale", new Vector2(1.2f, 1.2f), 0.1).From(Vector2.One);
		tween.TweenProperty(this, "scale", Vector2.One, 0.1).From(new Vector2(1.2f, 1.2f));	
	}

	private void OnArea2DInputEvent(Node viewport, InputEvent @event, int shape_index)
	{
		if (@event is InputEventMouseButton mouseEvent)
		{
			if (mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Left)
			{
				_customSignal.EmitSignal(nameof(CustomSignals.ClickMuyu), MuyuClickValue);
				UpgradeMuyu();
			}
		}
		
	}

	public void UpgradeMuyu()
	{
		if (MuyuClickValue == MuyuClickValueGolden)
		{
			MuyuSprite.Play("Gold");
			return;
		}
		else if (MuyuClickValue == MuyuClickValueSilver)
		{
			MuyuSprite.Play("Gold");
			MuyuClickValue = MuyuClickValueGolden;
		}
		else
		{
			MuyuSprite.Play("Silver");
			MuyuClickValue = MuyuClickValueSilver;
		}
	}




}
