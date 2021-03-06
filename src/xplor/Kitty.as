﻿package xplor 
{
	import org.flixel.*;
 
	public class Kitty extends FlxSprite
	{
		[Embed(source="../../data/kitty.png")] 
		protected var KittyImage:Class;
  
		public function Kitty(x:int,y:int)
		{
			super(KittyImage, x*16, y*16, true, true);
			
			addAnimation("idle", [0,1,0,2], 4, true);
			play("idle");
		}
	}
}