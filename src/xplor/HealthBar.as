package xplor 
{
	import org.flixel.*;
	
	public class HealthBar extends FlxSprite
	{
		[Embed(source="../../data/bar.png")]
		protected var BarImage:Class;
		
		public var current:int;
		protected var total:int;
		protected var xwidth:int;
		
		public function HealthBar(x:int, y:int, health:int, width:int = 16) 
		{
			super(BarImage, x, y, false, false);
			this.xwidth = width;
			this.current = this.total = health;
		}
		
		public override function update():void
		{
			this.scale.x = xwidth * (Number(current) / Number(total));
		}
	}
}