package xplor 
{
	import org.flixel.*;
	
	public class Fireball extends FlxSprite
	{
		[Embed(source="../../data/rocket.png")]
		protected var rocketPic:Class;
		protected var map:FlxTilemap;
		
		public function Fireball(map:FlxTilemap) 
		{
			this.map = map;
			super(rocketPic);
			exists = true;
		}
		
		override public function update():void
		{
			var tx:int = (x + width / 2) / 16;
			var ty:int = (y + height / 2) / 16;
			if (map.getTile(tx, ty) == 59)	// wood block
			{
				map.setTile(tx, ty, 0);
				exists = false;
			}
			
			super.update();
		}
	}
}