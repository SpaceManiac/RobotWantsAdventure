package xplor 
{
	import org.flixel.*;
	
	public class Drip extends FlxSprite
	{
		[Embed(source="../../data/alien3.png")]
		protected var AlienImage:Class;
  
		[Embed(source="../../data/blast.png")]
		protected var BlastImage:Class;
  
		[Embed(source="../../data/aliendie.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/alienhit.mp3")] 
		protected var hitSnd:Class;
		
		protected static const HEALTH:int = 4;
		protected static const SPEED:Number = 20;
		protected var player:Player;
		protected var bombs:Array;
		protected var reload:Number;
		protected var map:Array;
		protected var boom:FlxEmitter;
		
		public function Drip(x:int, y:int, map:Array, bombs:Array, player:xplor.Player) 
		{
			super(AlienImage, x*16, y*16, true,true);
			
			this.player = player;
			this.bombs = bombs;
			this.map = map;
			addAnimation("wiggle", [0, 1, 2, 1, 0, 1, 3, 1], 10, true);
			play("wiggle");
			health = HEALTH;
			reload = Math.random() * 1.5;
			boom = FlxG.state.add(new FlxEmitter(0,0,10,10,null,-1,-60,60,-60,
				60,-720,720,10,0,BlastImage,8,true)) as FlxEmitter;
		}
		
		public override function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			if (dead)
			{
				org.flixel.FlxG.play(dieSnd, Xplor.FX_VOL);
				boom.x = x + width / 2;
				boom.y = y + height / 2;
				boom.restart();
				return;
			}
			org.flixel.FlxG.play(hitSnd, Xplor.FX_VOL);
			return;
		}
		
		public override function update():void
		{
			var xx:int,yy:int;
				
			if (reload)
			{
				reload = reload - FlxG.elapsed;
				if (reload < 0)
				{
					reload = 0;
				}
			}
			xx = x + width / 2 - 4;
			yy = y + height / 2;
			super.update();
			if (reload == 0)
			{
				reload = 1.5;
				var loc4:*= 0;
				var loc5:*= bombs;
				for each(var b:Bomb in bombs)
				{
					if (b.exists != false)
					{
						continue;
					}
					b.shoot(xx, yy, 0, 100);
					break;
				}
			}
			return;
		}
	}
}