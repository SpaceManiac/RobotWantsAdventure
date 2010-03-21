package xplor 
{
	import org.flixel.*;

	public class Bomb extends FlxSprite
	{
		[Embed(source="../../data/laser.png")] 
		private var LaserImage:Class;
		[Embed(source="../../data/bossshoot.mp3")] 
		protected var shootSnd:Class;
		[Embed(source="../../data/laserhit.mp3")] 
		protected var hitSnd:Class;

		public function Bomb()
		{
			super(LaserImage,0,0,true,true);

			exists = false;

			addAnimation("shoot", [1, 2, 3, 2], 30, true);
			addAnimation("pop", [1, 2, 3], 50, false);
			//addAnimation("shoot_green"
		}
		
		override public function update():void
		{
			acceleration.y = 420;
			if (dead && finished) 
			{
				exists = false;
			}
			else
				super.update();
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			hurt(0); 
			FlxG.play(hitSnd);
			return true; 
		}
		
		override public function hitFloor(Contact:FlxCore = null):Boolean 
		{ 
			hurt(0); 
			FlxG.play(hitSnd);
			return true; 
		}
		
		override public function hitCeiling(Contact:FlxCore = null):Boolean 
		{ 
			hurt(0); 
			FlxG.play(hitSnd);
			return true; 
		}

		override public function hurt(Damage:Number):void
		{
			if(dead) 
				return;
			velocity.x = 0;
			velocity.y = 0;
			dead = true;
			play("pop");
			
		}

		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			super.reset(X,Y);
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			if (velocity.x > 0)
				facing = RIGHT;
			else
				facing = LEFT;
			FlxG.play(shootSnd);	
			play("shoot");
		}


	}
	
}