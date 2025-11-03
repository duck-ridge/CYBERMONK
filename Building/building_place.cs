using Godot;
using System;
using Godot.Collections;
using System.Net;
using System.Text.RegularExpressions;
using System.Security.Cryptography.X509Certificates;


public partial class building_place : Node2D
{
	public temple_0 _temple_0;
	public temple_1 _temple_1;
	public Node2D buildings; 


	public override void _Ready()
	{
		_temple_0 = GetNode<temple_0>("Building/Temple0");
		_temple_1 = GetNode<temple_1>("Building/Temple1");
		buildings = GetNode<Node2D>("Building");

		_temple_0.Show();
		_temple_1.Hide();


		_temple_0.ChangeBuilding += change_building;
		_temple_1.ChangeBuilding += change_building;
	}

	public void change_building(int building_code)
    {
		if (building_code == 0)
		{
			foreach (Node2D t in buildings.GetChildren())
            {
				t.Hide();
            }
			_temple_0.Initialize();
			_temple_0.Show();
		}
		
		if (building_code == 1)
		{
			foreach (Node2D t in buildings.GetChildren())
			{
				t.Hide();
			}
			_temple_1.Initialize();
			_temple_1.Show();
        }
    }



}