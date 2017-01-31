package
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class GameTimer extends MovieClip
	{
		public var timer:Timer = new Timer(1000);
		public var curTime:int = 0;
		
		public var hundreds:GameTimerNumbers = new GameTimerNumbers();
		public var tens:GameTimerNumbers = new GameTimerNumbers();
		public var ones:GameTimerNumbers = new GameTimerNumbers();
		
		public function GameTimer()
		{
			super();
			
			//Set the position of the timer numbers.
			hundreds.x = 80;
			hundreds.y = 5;
			tens.x = 110;
			tens.y = 5;
			ones.x = 140;
			ones.y = 5;
		}
		
		public function startTime(time:int):void {
			curTime = time;
			
			var timeStr:String = curTime.toString();
			switch(timeStr.length){
				case 3: //100-999
					hundreds.gotoAndStop(parseInt(timeStr.charAt(0)) + 1);
					tens.gotoAndStop(parseInt(timeStr.charAt(1)) + 1);
					ones.gotoAndStop(parseInt(timeStr.charAt(2)) + 1);
					break;
				case 2: //10-99
					tens.gotoAndStop(parseInt(timeStr.charAt(0)) + 1);
					ones.gotoAndStop(parseInt(timeStr.charAt(1)) + 1);
					break;
				case 1: //0-9
					ones.gotoAndStop(parseInt(timeStr) + 1);
					break;
			}
			timer.addEventListener(TimerEvent.TIMER, tickClock);
			timer.start();
		}
		
		//Stops this timer and any events that may cause it to reappear. In essence, makes the timer... go away.
		public function goAway(){
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, tickClock);
		}
		
		//Updates the clock with the current time left in this session.
		function tickClock(e:TimerEvent){
			curTime--;
			if(curTime >= 0){ //No frames exist for negative numbers (nor should there be a negative time)
				var timeStr:String = curTime.toString();
				switch(timeStr.length){
					case 3: //100-999
						hundreds.gotoAndStop(parseInt(timeStr.charAt(0)) + 1);
						tens.gotoAndStop(parseInt(timeStr.charAt(1)) + 1);
						ones.gotoAndStop(parseInt(timeStr.charAt(2)) + 1);
						break;
					case 2: //10-99
						tens.gotoAndStop(parseInt(timeStr.charAt(0)) + 1);
						ones.gotoAndStop(parseInt(timeStr.charAt(1)) + 1);
						break;
					case 1: //0-9
						ones.gotoAndStop(parseInt(timeStr) + 1);
						break;
				}
			}
		}
	}
}