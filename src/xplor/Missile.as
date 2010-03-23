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
		
		private var map:FlxTilemap;

		public function Missile(map:FlxTilemap)
		{
			this.map = map;
			super(MissileImage, 0, 0, true, true);

			exists = false;
			
			width = 8;
			offset.x = 4;

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
		
		override public function hitWall(Contact:FlxObject = null):Boolean 
		{
			return false;
		}
		
		override public function hitFloor(Contact:FlxObject = null):Boolean 
		{ 
			return false;
		}
		
		override public function hitCeiling(Contact:FlxObject = null):Boolean 
		{
			var tx:int = x / 16;
			var ty:int = y / 16;
			if (map.getTile(tx, ty) == 58) {
				map.setTile(tx, ty, 0);
			}
			tx = (x + width) / 16;
			if (map.getTile(tx, ty) == 58) {
				map.setTile(tx, ty, 0);
			}
			
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
			new DebugDot(X, Y);
			
			super.reset(X,Y);
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			facing = UP;
			FlxG.play(shootSnd);	
			play("shoot");
		}


	}
	
}