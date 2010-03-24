package xplor 
{
	import org.flixel.*;
	
	public class Cursor extends FlxSprite
	{
		[Embed(source = "../../data/Cursor.png")]
		protected var CursorImg:Class;
		
		private var lastx:int;
		private var lasty:int;
		
		private static var current:Cursor = null;
		
		public function Cursor() 
		{
			super(0, 0, CursorImg);
			lastx = x = FlxG.mouse.x;
			lasty = y = FlxG.mouse.y;
			current = this;
		}
		
		override public function update():void
		{
			lastx = x; lasty = y;
			x = FlxG.mouse.x;
			y = FlxG.mouse.y;
		}
		
		public static function moved():Boolean
		{
			return (current.lastx != current.x) || (current.lasty != current.y);
		}
	}
}