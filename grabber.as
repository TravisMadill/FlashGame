package
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class grabber extends MovieClip
	{
		var animTimer:Timer = new Timer(500);
		
		/** Whether or not the hand is doing something or not */
		public var isIdle:Boolean = true;
		
		/** The speed at which the hand moves */
		var delta:Point = new Point();
		public var hasGun:Boolean = false;
		
		/**
		 * A grabber grabs the player's gun if the user's mouse happens to hover over the hand (not just click)
		 * If a grabber grabs your gun, you have to click the hand as it tries to runa away from you.
		 */
		public function grabber()
		{
			super();
			stop();
			animTimer.start();
			animTimer.addEventListener(TimerEvent.TIMER, continueAnim);
		}
		
		public function startGrabbing(delta:Point):void{
			this.delta = delta;
		}
		
		public function updateGrabberRotation(xDiff:Number, yDiff:Number):void {
			if(this.hasGun){
				this.rotation = Math.atan2(-yDiff, -xDiff) * 180 / Math.PI;
			} else {
				this.rotation = Math.atan2(yDiff, xDiff) * 180 / Math.PI;
			}
		}
		
		public function updatePosition(mouseX:Number, mouseY:Number):void {
			// Try to run away from user mouse
			// Otherwise, the hand will just move in a "straight" line.
			if(hasGun){
				delta.x += limitOutput((mouseX - this.x)/50, 10, -10);
				delta.y += limitOutput((mouseY - this.y)/50, 10, -10);
				
				delta.x = limitOutput(delta.x, 100, -100);
				delta.y = limitOutput(delta.y, 100, -100);
				
				if(this.x + this.width < 0 || this.x + this.width < 550){
					delta.x = -delta.x;
				}
				if(this.y + this.height < 0 || this.y + this.height < 400){
					delta.y = -delta.y;
				}
			}
			this.x += delta.x;
			this.y += delta.y;
		}
		
		//Limits the number so that the hand doesn't go flying off the screen and gets stuck out of bounds.
		function limitOutput(num:Number, upperLimit:Number, lowerLimit:Number):Number{
			if(num > upperLimit){
				return upperLimit;
			}
			else if(num < lowerLimit){
				return lowerLimit;
			}
			return num;
		}
		
		function continueAnim(e:TimerEvent):void {
			if(!this.hasGun){
				if(this.currentFrame == 2){
					gotoAndStop(1);
				}
				else {
					gotoAndStop(2);
				}
			}
			else
				gotoAndStop(2);
		}
	}
}