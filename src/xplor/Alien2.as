package xplor 
{
	import org.flixel.*;
	
	public class Alien2 extends FlxSprite
	{
		[Embed(source="../../data/alien2.png")]
		protected var AlienImage:Class;
  
		[Embed(source="../../data/blast.png")]
		protected var BlastImage:Class;
  
		[Embed(source="../../data/aliendie.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/alienhit.mp3")] 
		protected var hitSnd:Class;
		
		protected static const SPEED:Number = 20;
		protected static const HEALTH:int = 2;
		protected var map:Array;
		protected var boom:FlxEmitter;
		public var justdied:Boolean;
		
		public function Alien2(x:int,y:int,map:Array) 
		{
			super(x * 16, y * 16);
			loadGraphic(AlienImage, true, true);
   
			this.map = map;
			addAnimation("float", [0, 1, 2, 3], 16, true);
			play("float");
			health = ConfigState.BlueAlienHealth;
			velocity.y = ConfigState.BlueAlienSpeed;
			
			boom = FlxG.state.add(new FlxEmitter(0,0,10,10,null,-1,-60,60,-60,
				60,-720,720,10,0,BlastImage,8,true)) as FlxEmitter;
		}
		
		public override function update():void
		{
			var xx:int,yy:int;
			
			super.update();
		}

		override public function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			if (dead)
			{
				FlxG.play(dieSnd);
				boom.x = x +width / 2;
				boom.y = y + height / 2;
				boom.start();
				justdied = true;
				return;
			}
			else
				FlxG.play(hitSnd);
			velocity.y = -velocity.y;
		}
		
		public override function hitBottom(Contact:FlxObject, Vel:Number):void
		{
			this.velocity.y = -ConfigState.BlueAlienSpeed;
			if (Math.random() < 0.5)
				this.facing = LEFT;
			else
				this.facing = RIGHT;
				
		}
		
		public override function hitTop(Contact:FlxObject, Vel:Number):void
		{
			this.velocity.y = ConfigState.BlueAlienSpeed;
			if (Math.random() < 0.5)
				this.facing = LEFT;
			else
				this.facing = RIGHT;
				
		}

	}
	
}