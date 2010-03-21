package xplor 
{
	import org.flixel.*;
	
	public class Cursor extends FlxSprite
	{
		[Embed(source = "../../data/Cursor.png")]
		protected var CursorImg:Class;
		
		public function Cursor() 
		{
			super(CursorImg, FlxG.mouse.x, FlxG.mouse.y);
		}
		
		override public function update():void
		{
			x = FlxG.mouse.x;
			y = FlxG.mouse.y;
		}
	}
}