package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class ScoreDisplay extends MovieClip
	{
		public var displayingNumbers:Array = new Array();
		public function ScoreDisplay()
		{
			super();
			this.x = 0;
			this.y = 400 - 60;
		}
		
		//Updates the score display to let the player know their current score
		//For some reason, only this object seems to be able to use addChild and removeChild. Believe me, I tried.
		// And their positions are realtive to this object's positions. Flash is weird.
		public function updateScore(curScore:int):void{
			for each(var n:GameTimerNumbers in displayingNumbers){
				removeChild(n);
			}
			displayingNumbers = new Array(); //Clear the array
			var scoreStr:String = curScore.toString();
			var pushNextNumConst:Point = new Point(30, 0);
			var curNumPoint:Point = new Point(120, 0);
			for(var i:int = 0; i < scoreStr.length; i++){
				var numToBeAdded:GameTimerNumbers = new GameTimerNumbers();
				numToBeAdded.x = curNumPoint.x;
				numToBeAdded.y = curNumPoint.y;
				numToBeAdded.gotoAndStop(parseInt(scoreStr.charAt(i)) + 1);
				displayingNumbers.push(numToBeAdded);
				addChild(numToBeAdded);
				
				curNumPoint = curNumPoint.add(pushNextNumConst); //Move the next number to the side for more digit clearance.
				
			}
		}
	}
}