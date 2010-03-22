package xplor 
{
	import org.flixel.*;
	
	public class ArrowButton extends FlxButton
	{
		[Embed(source = "../../data/arrows.png")]
		private var ArrowsImg:Class;
		
		private var txt:FlxText;
		
		public function ArrowButton(X:int, Y:int, callback:Function, type:String = "right") 
		{
			var sprite:FlxSprite = new FlxSprite(ArrowsImg, 0, 0, true);
			sprite.addAnimation("up", [0]);
			sprite.addAnimation("down", [1]);
			sprite.addAnimation("left", [2]);
			sprite.addAnimation("right", [3]);
			sprite.play(type);
			
			super(X, Y, sprite, callback);
		}
	}
}