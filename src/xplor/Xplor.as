package xplor 
{
	import org.flixel.*;
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] //Set the size and color of the Flash file
	
	public class Xplor extends FlxGame
	{
		
		public function Xplor() 
		{
			super(320, 240, TitleState, 2, 0xFF000000, false); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
			help("Jump", "Shoot", "Nothing", "Move");
		}
		
	}
	
}