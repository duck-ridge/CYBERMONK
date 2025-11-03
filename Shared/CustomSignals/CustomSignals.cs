using Godot;
using System;

public partial class CustomSignals : Node
{

	[Signal]
	public delegate void SignalTestEventHandler(string messageFromChef);

	[Signal]
	public delegate void ClickMuyuEventHandler(string MuyuMessage);

	[Signal]
	public delegate void MonkLittleUnlockEventHandler();

	//registered monk, DND means drag & drop
	[Signal]
	public delegate void MonkRegisteredToDNDEventHandler(monk_little monk);

	[Signal]
	public delegate void ReleaseMonkRegisteredToDNDEventHandler();

	
}
