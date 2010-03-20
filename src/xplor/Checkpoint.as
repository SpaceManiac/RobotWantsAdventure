package xplor 
{
	import org.flixel.*;
 
	public class Checkpoint extends FlxSprite
	{
		[Embed(source="../../data/checkpoint.png")] 
		protected var CheckpointImage:Class;
  
		public function Checkpoint(x:int,y:int)
		{
			super(CheckpointImage, x*16, y*16, true, true);
			
			addAnimation("idle", [0], 12, true);
			addAnimation("activated", [1, 2, 3], 20 , true);
			play("idle");
		}
	}
}