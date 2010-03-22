package xplor
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
    import org.flixel.*;
	
    public class ConfigState extends FlxState
    {
		[Embed(source="../../data/powerup.mp3")] 
		protected var hitSnd:Class;
		
		public static const CNT_C:int = 0;
		public static const CNT_DT:int = 1;
		public static var Controls:int = 0; // 0 = C/Duck-C, 1 = Double-tap/Duck-jump
		public static var PowerStart:Boolean = false; //
		public static var DuckJump:Boolean = false; //
		
		public static var Timer:Boolean = true;
		public static var KillBonus:uint = 1;
		public static var DeathPenalty:uint = 20;
		
		public static var RedAlienHealth:uint = 3; //
		public static var BlueAlienHealth:uint = 1; //
		public static var BossHealth:uint = 50; //
		
		public static var RedAlienSpeed:uint = 20; //
		public static var BlueAlienSpeed:uint = 20; //
		public static var BossSpeed:uint = 20; //
		
		public static var RocketOnFloor:Boolean = true;
		public static var LargeBlockFactor:uint = 50;
		
		private var arrow:FlxText;
		private var contT:FlxText;
		private var powerT:FlxText;
		private var duckjT:FlxText;
		private var timerT:FlxText;
		private var killbT:FlxText;
		private var deathpT:FlxText;
		private var rahT:FlxText;
		private var bahT:FlxText;
		private var bosshT:FlxText;
		private var rasT:FlxText;
		private var basT:FlxText;
		private var bosssT:FlxText;
		private var rfloorT:FlxText;
		private var lbfT:FlxText;
		
		public static var testing:uint = 0;
		
		private var fading:Boolean = false;
		private var selection:uint = 0;
		
        override public function ConfigState() {
			FlxG.log("ConfigState opened");
			this.add(new Background());
            add(new FlxText(0, 8, FlxG.width, "Game Options", 0xffffffff, null, 16, "center"));
            add(new FlxText(0, 190, FlxG.width, "Up/down to select, l/r to change", 0xffffffff, null, 8, "center"));
            //add(new FlxText(0, FlxG.height  -12, FlxG.width, "Press Z to return", 0xffffffff, null, 8, "center"));
			
            add(new MenuButton(FlxG.width / 2, 210, finish, "Main Menu"));
			
			// pointer
			arrow = new FlxText(70, 32, 10, ">");
			add(arrow);
			var i:uint = 11, y:uint = 32 - i;
			
			// controls
			var ctrlText:Array = ["C-based", "Double-tap-based"];
			add(new FlxText(80, y += i, 120, "Rocket Control: "));
			add(contT = new FlxText(200, y, 200, ctrlText[Controls]));
			// super start
			add(new FlxText(80, y += i, 120, "Start Superpowered: "));
			add(powerT = new FlxText(200, y, 200, boolstr(PowerStart)));
			// duckjump
			add(new FlxText(80, y += i, 120, "Duck-Jump Glitch: "));
			add(duckjT = new FlxText(200, y, 200, boolstr(DuckJump)));
			// timer
			add(new FlxText(80, y += i, 120, "Timer Display: "));
			add(timerT = new FlxText(200, y, 200, boolstr(Timer)));
			// kill bonus
			add(new FlxText(80, y += i, 120, "Kill Time Bonus: "));
			add(killbT = new FlxText(200, y, 200, KillBonus.toString()));
			// death penalty
			add(new FlxText(80, y += i, 120, "Death Time Penalty: "));
			add(deathpT = new FlxText(200, y, 200, DeathPenalty.toString()));
			// red enemy health
			add(new FlxText(80, y += i, 120, "Red Alien Health: "));
			add(rahT = new FlxText(200, y, 200, RedAlienHealth.toString()));
			// blue enemy health
			add(new FlxText(80, y += i, 120, "Blue Alien Health: "));
			add(bahT = new FlxText(200, y, 200, BlueAlienHealth.toString()));
			// boss health
			add(new FlxText(80, y += i, 120, "Boss Monster Health: "));
			add(bosshT = new FlxText(200, y, 200, BossHealth.toString()));
			// red enemy speed
			add(new FlxText(80, y += i, 120, "Red Alien Speed: "));
			add(rasT = new FlxText(200, y, 200, RedAlienSpeed.toString()));
			// blue enemy speed
			add(new FlxText(80, y += i, 120, "Blue Alien Speed: "));
			add(basT = new FlxText(200, y, 200, BlueAlienSpeed.toString()));
			// boss speed
			add(new FlxText(80, y += i, 120, "Boss Monster Speed: "));
			add(bosssT = new FlxText(200, y, 200, BossSpeed.toString()));
			// rocket on floor
			add(new FlxText(80, y += i, 120, "Dashing on Floor: "));
			add(rfloorT = new FlxText(200, y, 200, boolstr(RocketOnFloor)));
			// large block factor
			add(new FlxText(80, y += i, 120, "Large Block Factor: "));
			add(lbfT = new FlxText(200, y, 200, LargeBlockFactor.toString() + "%"));
			// drippazorg health
			//add(new FlxText(80, y += i, 120, "Blue Alien Health: "));
			//add(bahT = new FlxText(200, y, 200, BlueAlienHealth.toString()));
			// drippazorg speed
			//add(new FlxText(80, y += i, 120, "Blue Alien Speed: "));
			//add(basT = new FlxText(200, y, 200, BlueAlienSpeed.toString()));
			
			add(new Cursor());
        }
		
		private function boolstr(x:Boolean):String {
			if (x) return "on";
			else return "off";
		}
		
		private function finish():void {
			if(!fading) {
				fading = true;
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 0.5, onFade);
				FlxG.play(hitSnd);
			}
		}
		
        override public function update():void {
            if (FlxG.keys.Z && !fading) {
				finish();
			}
			
			if (Cursor.moved()) {
				var s:int = (FlxG.mouse.y - 32) / 11;
				if (s >= 0 && s <= 13) {
					selection = s;
				}
			}
			var mouseInRect:Boolean = (FlxG.mouse.y >= 32 && FlxG.mouse.y <= (32 + 14 * 11));
			
			if (FlxG.keys.justPressed("UP")) {
				if (selection > 0) selection--;
			}
			if (FlxG.keys.justPressed("DOWN")) {
				if (selection < 13) selection++;
			}
			arrow.y = 32 + 11 * selection;
			
			if (FlxG.mouse.x < FlxG.width / 2) {
				arrow.text = "<";
			} else {
				arrow.text = ">";
			}
			
			var ctrlText:Array = ["C-based", "Double-tap-based"];
			
			if (FlxG.keys.justPressed("LEFT") || (FlxG.mouse.justPressed() && FlxG.mouse.x < FlxG.width/2 && mouseInRect)) {
				if (selection == 0) {
					if (Controls == 0) {
						Controls = 1;
					} else {
						Controls = 0;
					}
					contT.text = ctrlText[Controls];
				} else if (selection == 1) {
					PowerStart = !PowerStart;
					powerT.text = boolstr(PowerStart);
				} else if (selection == 2) {
					DuckJump = !DuckJump;
					duckjT.text = boolstr(DuckJump);
				} else if (selection == 3) {
					Timer = !Timer;
					timerT.text = boolstr(Timer);
				} else if (selection == 4) {
					if (KillBonus > 0) KillBonus--;
					killbT.text = KillBonus.toString();
				} else if (selection == 5) {
					if (DeathPenalty > 0) DeathPenalty--;
					deathpT.text = DeathPenalty.toString();
				} else if (selection == 6) {
					if (RedAlienHealth > 1) RedAlienHealth--;
					rahT.text = RedAlienHealth.toString();
				} else if (selection == 7) {
					if (BlueAlienHealth > 1) BlueAlienHealth--;
					bahT.text = BlueAlienHealth.toString();
				} else if (selection == 8) {
					if (BossHealth > 10) BossHealth -= 5;
					bosshT.text = BossHealth.toString();
				} else if (selection == 9) {
					if (RedAlienSpeed > 10) RedAlienSpeed--;
					rasT.text = RedAlienSpeed.toString();
				} else if (selection == 10) {
					if (BlueAlienSpeed > 10) BlueAlienSpeed--;
					basT.text = BlueAlienSpeed.toString();
				} else if (selection == 11) {
					if (BossSpeed > 10) BossSpeed--;
					bosssT.text = BossSpeed.toString();
				} else if (selection == 12) {
					RocketOnFloor = !RocketOnFloor;
					rfloorT.text = boolstr(RocketOnFloor);
				} else if (selection == 13) {
					if (LargeBlockFactor > 0) LargeBlockFactor -= 5;
					lbfT.text = LargeBlockFactor.toString() + "%";
				}
			}
			
			if (FlxG.keys.justPressed("RIGHT") || (FlxG.mouse.justPressed() && FlxG.mouse.x >= FlxG.width/2 && mouseInRect)) {
				if (selection == 0) {
					if (Controls == 0) {
						Controls = 1;
					} else {
						Controls = 0;
					}
					contT.text = ctrlText[Controls];
				} else if (selection == 1) {
					PowerStart = !PowerStart;
					powerT.text = boolstr(PowerStart);
				} else if (selection == 2) {
					DuckJump = !DuckJump;
					duckjT.text = boolstr(DuckJump);
				} else if (selection == 3) {
					Timer = !Timer;
					timerT.text = boolstr(Timer);
				} else if (selection == 4) {
					if (KillBonus < 10) KillBonus++;
					killbT.text = KillBonus.toString();
				} else if (selection == 5) {
					if (DeathPenalty < 30) DeathPenalty++;
					deathpT.text = DeathPenalty.toString();
				} else if (selection == 6) {
					if (RedAlienHealth < 8) RedAlienHealth++;
					rahT.text = RedAlienHealth.toString();
				} else if (selection == 7) {
					if (BlueAlienHealth < 8) BlueAlienHealth++;
					bahT.text = BlueAlienHealth.toString();
				} else if (selection == 8) {
					if (BossHealth < 100) BossHealth += 5;
					bosshT.text = BossHealth.toString();
				} else if (selection == 9) {
					if (RedAlienSpeed < 60) RedAlienSpeed++;
					rasT.text = RedAlienSpeed.toString();
				} else if (selection == 10) {
					if (BlueAlienSpeed < 60) BlueAlienSpeed++;
					basT.text = BlueAlienSpeed.toString();
				} else if (selection == 11) {
					if (BossSpeed < 60) BossSpeed++;
					bosssT.text = BossSpeed.toString();
				} else if (selection == 12) {
					RocketOnFloor = !RocketOnFloor;
					rfloorT.text = boolstr(RocketOnFloor);
				} else if (selection == 13) {
					if (LargeBlockFactor < 100) LargeBlockFactor += 5;
					lbfT.text = LargeBlockFactor.toString() + "%";
				}
			}
			
            super.update();
        }
		
        private function onFade():void {
			FlxG.switchState(TitleState);
        }
    }
}