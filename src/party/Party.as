package party
{
	import org.flixel.*;
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	
	public class Party extends FlxGame
	{
		
		public function Party() 
		{
			super(320, 240, TitleState, 2, 0xFF000000, false);
			help("Shoot", "Nothing", "Nothing", "Move");
		}
	}
}