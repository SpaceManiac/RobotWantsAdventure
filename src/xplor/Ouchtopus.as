﻿package xplor 
{
	import org.flixel.*;
	
	public class Ouchtopus extends FlxSprite
	{
		[Embed(source="../../data/ouchtopus.png")]
		protected var AlienImage:Class;
  
		[Embed(source="../../data/blast.png")]
		protected var BlastImage:Class;
  
		[Embed(source="../../data/aliendie.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/alienhit.mp3")] 
		protected var hitSnd:Class;
		
		protected static const SPEED:Number = 20;
		protected static const HEALTH:int = 5;
		protected var boom:FlxEmitter;
		protected var reload:int = 0;
		protected var bombs:FlxGroup;
		public var justdied:Boolean;
		
		public function Ouchtopus(x:int,y:int,bombs:FlxGroup) 
		{
			super(x * 16, y * 16);
			loadGraphic(AlienImage, true, true);
   
			this.height = 11;
			this.bombs = bombs;
			addAnimation("sit", [0, 1, 2, 3], 5, true);
			play("sit");
			//health = ConfigState.RedAlienHealth;
			health = 5;
			
			reload = int(Math.random() * 360);
			
			boom = FlxG.state.add(new FlxEmitter().remakeOld(0,0,10,10,null,-1,-60,60,-60,
				60,-720,720,10,0,BlastImage,8,true)) as FlxEmitter;
		}
		
		public override function update():void
		{
			if (reload) {
				reload--;
			}
			var xx:int = x + width / 2;
			var yy:int = y + height / 2;
			
			super.update();
			
			if (reload == 0)
			{
				var b:Bomb = bombs.getFirstAvail() as Bomb;
				if(b != null) {
					reload = 360;
					b.shoot(xx, yy, -60, -150, "_g");
					b = bombs.getFirstAvail() as Bomb;
					if(b != null) {
						b.shoot(xx, yy, 60, -150, "_g");
					}
				}
			}
		}

		override public function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			if (dead)
			{
				FlxG.play(dieSnd);
				boom.x = x +width / 2;
				boom.y = y + height / 2;
				boom.start()
				justdied = true;
				return;
			}
			else
				FlxG.play(hitSnd);
		}
	}
}