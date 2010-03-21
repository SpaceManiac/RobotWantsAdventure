package xplor 
{
	import org.flixel.*;
	
	public class Background extends FlxSprite
	{
		[Embed(source="../../data/background.png")] 
		private var BgImage:Class;
		
		public function Background() 
		{
			super(BgImage, FlxG.scroll.x, FlxG.scroll.y);
		}
		
		override public function update():void
		{
			var sx:Number = Math.abs(FlxG.scroll.x);
			var sy:Number = Math.abs(FlxG.scroll.y);
			
			x = sx - .5 * (sx % 64);
			y = sy - .5 * (sy % 64);
		}
	}
}