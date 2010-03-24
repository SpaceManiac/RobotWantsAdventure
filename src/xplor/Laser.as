package xplor 
{
	import org.flixel.*;

	public class Laser extends FlxSprite
	{
		[Embed(source="../../data/laser.png")] 
		private var LaserImage:Class;
		[Embed(source="../../data/laser.mp3")] 
		protected var shootSnd:Class;
		[Embed(source="../../data/laserhit.mp3")] 
		protected var hitSnd:Class;

		public function Laser()
		{
			super(0, 0);
			loadGraphic(LaserImage, true, true);

			exists = false;

			addAnimation("shoot",[0]);
			addAnimation("pop",[1,2,3], 50, false);
		}
		
		override public function update():void
		{
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
			FlxG.play(hitSnd);
		}
		
		override public function hitRight(Contact:FlxObject, Vel:Number):void
		{
			hitLeft(Contact, Vel);
		}
		
		override public function hitBottom(Contact:FlxObject, Vel:Number):void
		{ 
			hurt(0); 
			FlxG.play(hitSnd);
		}
		
		override public function hitTop(Contact:FlxObject, Vel:Number):void
		{ 
			hurt(0); 
			FlxG.play(hitSnd);
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