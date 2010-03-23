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
		
		protected var ext:String = "";

		public function Bomb()
		{
			super(0, 0);
			loadGraphic(LaserImage, true, true);

			exists = false;

			addAnimation("shoot", [1, 2, 3, 2], 30, true);
			addAnimation("pop", [1, 2, 3], 50, false);

			addAnimation("shoot_g", [5, 6, 7, 6], 30, true);
			addAnimation("pop_g", [5, 6, 7], 50, false);
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
		
		override public function hitLeft(Contact:FlxObject, Vel:Number):void
		{
			hurt(0); 
			if (onScreen()) FlxG.play(hitSnd);
			velocity.x = Vel;
		}
		
		override public function hitRight(Contact:FlxObject, Vel:Number):void
		{
			hitLeft(Contact, Vel);
		}
		
		override public function hitBottom(Contact:FlxObject, Vel:Number):void
		{ 
			velocity.y = Vel;
			hurt(0); 
			if (onScreen()) FlxG.play(hitSnd);
		}
		
		override public function hitTop(Contact:FlxObject, Vel:Number):void
		{ 
			velocity.y = Vel;
			hurt(0); 
			if (onScreen()) FlxG.play(hitSnd);
		}

		override public function hurt(Damage:Number):void
		{
			if(dead) 
				return;
			velocity.x = 0;
			velocity.y = 0;
			dead = true;
			play("pop" + ext);
			
		}

		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int, ext:String = ""):void
		{
			this.ext = ext;
			super.reset(X,Y);
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			if (velocity.x > 0)
				facing = RIGHT;
			else
				facing = LEFT;
			if (onScreen()) FlxG.play(shootSnd);
			play("shoot" + ext);
		}


	}
	
}