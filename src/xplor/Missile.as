package xplor 
{
	import org.flixel.*;

	public class Missile extends FlxSprite
	{
		//Please change the missile graphic as mine is awful!
		//Also, please add sounds.
		
		[Embed(source="../../data/missile.png")] 
		private var MissileImage:Class;
		[Embed(source="../../data/laser.mp3")]
		protected var shootSnd:Class;
		[Embed(source="../../data/laserhit.mp3")] 
		protected var hitSnd:Class;

		public function Missile()
		{
			super(MissileImage,0,0,true,true);

			exists = false;
			
			width = 10;
			offset.x = 3;

			addAnimation("shoot",[0,1], 50);
			addAnimation("pop",[2,3,4], 50, false);
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
			facing = UP;
			FlxG.play(shootSnd);	
			play("shoot");
		}


	}
	
}