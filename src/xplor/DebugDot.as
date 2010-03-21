package xplor 
{
	import org.flixel.*;
	
	public class DebugDot extends FlxSprite
	{
		[Embed(source="../../data/debugdot.png")] 
		private var DotImage:Class;
		
		public function DebugDot(x:int, y:int) 
		{
			super(DotImage, x, y, false);
			this.offset.x = 3;
			this.offset.y = 3;
			
			if(ConfigState.testing) FlxG.state.add(this);
		}
	}
}