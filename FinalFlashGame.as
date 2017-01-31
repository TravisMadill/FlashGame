package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	//import flashx.textLayout.elements.BreakElement;
	
	
	public class FinalFlashGame extends MovieClip {
		
		//Main screen objects (Frame 1)
		public var f1_startBtn:customBtn = new customBtn();
		/** TODO: add logos and stuff */
		
		//Main screen object positions (Frame 1)
		public var f1_startBtn_pos:Point = new Point(175, 150);
		/** TODO: ...and their positions. */
		
		//Game screen objects and variables (Frame 2) (Also, there's a lot more stuff than the menu)
		public var theme:Sound = new DesertSong();
		public var hasGun:Boolean = true;
		public var f2_stopBtn:customBtn = new customBtn();
		public var objects:Array = new Array();
		public var score:int = 0;
		public var timeLimit:int = 100;
		public var scoreDisplay:ScoreDisplay = new ScoreDisplay();
		public var timerDisplay:GameTimer = new GameTimer();
		public var timer_isHundDigitGone:Boolean = false;
		public var timer_isTensDigitGone:Boolean = false;
		public var gunFollower:gun = new gun();
		public var handGrabber1:grabber = new grabber();
		public var handGrabber2:grabber = new grabber();
		public var showingGetGunMsg:Boolean = false;
		public var getGunMsg:msg_getGun = new msg_getGun();
		
		//Game screen object positions (Frame 2)
		public var f2_stopBtn_pos:Point = new Point(387, 352); //Point values determined by (stage width - button width, and same for height)
		public var handGrabber1_startPos:Point = new Point(-100, -100);
		public var handGrabber2_startPos:Point = new Point(-100, -100);
		public var getGunMsg_pos:Point = new Point(100, 300);
		/** TODO: ...and their positions. */
		
		//Game timer for events
		public var gameTimer:Timer = new Timer(50);
		
		public function FinalFlashGame() {
			stop();
			addChild(f1_startBtn.txtBox);
			f1_startBtn.initBtn(f1_startBtn_pos, "Start");
			f1_startBtn.addEventListener(MouseEvent.CLICK, startTheGame);
			addChild(f1_startBtn); // */
			//gotoAndStop(3);
		}
		
		//Starts the game and initialises the targets
		function startTheGame(e:MouseEvent):void {
			//Frame 1 cleanup
			gotoAndStop(2);
			theme.play();
			f1_startBtn.removeEventListener(MouseEvent.CLICK, startTheGame);
			removeChild(f1_startBtn.txtBox);
			removeChild(f1_startBtn);
			
			//Actual game startup. The braces are for organising and easier "notice-ability"
			{
				gameTimer.start();
				gameTimer.addEventListener(TimerEvent.TIMER, updateGame);
				if(objects.length < 3){
					for(var i:int = 0; objects.length < 4; i++){
						addATarget();
					}
				}
				
				timerDisplay.startTime(timeLimit);
				addChild(timerDisplay);
				timer_isHundDigitGone = false;
				addChild(timerDisplay.hundreds);
				timer_isTensDigitGone = false;
				addChild(timerDisplay.tens);
				addChild(timerDisplay.ones);
				addChild(scoreDisplay);
				
				handGrabber1.x = handGrabber1_startPos.x;
				handGrabber1.y = handGrabber1_startPos.y;
				handGrabber2.x = handGrabber2_startPos.x;
				handGrabber2.y = handGrabber2_startPos.y;
				
				f2_stopBtn.initBtn(f2_stopBtn_pos, "Quit");
				f2_stopBtn.addEventListener(MouseEvent.CLICK, stopGameAndGotoMenu);
				addChild(f2_stopBtn.txtBox);
				addChild(f2_stopBtn);
				
				Mouse.hide();
				addChild(gunFollower);
				stage.addEventListener(Event.ENTER_FRAME, updateGun);
			}
		}
		
		function updateGun(e:Event):void{
			if(hasGun){
				gunFollower.x = mouseX - 7;
				gunFollower.y = mouseY - 28;
			} else {
				if(handGrabber1.hasGun){
					gunFollower.x = handGrabber1.x - 7;
					gunFollower.y = handGrabber1.y - 28;
				} else {
					gunFollower.x = handGrabber2.x - 7;
					gunFollower.y = handGrabber2.y - 28;
				}
			}
		}
		
		//Happens every time the timer ticks to update the game and their positions.
		function updateGame(e:TimerEvent):void {
			
			//Possibly add a target
			if(Math.random() > 0.9 && objects.length < 10){
				addATarget();
			}
			
			if(handGrabber1.isIdle && Math.random() > 0.95){
				//Flash keeps bugging me about duplicate variables... despite the fact that every variable is declared in its own subsection
				// That's why Flash is probably warning you about duplicate variables. It's irritating.
				switch(int(Math.random() * 2)){
					case 0: //Horizontal
						var y1:Number = Math.random() * stage.stageHeight;
						var y2:Number = Math.random() * stage.stageHeight;
						if(Math.random() > 0.5)  //Left to right
							handGrabber1.x = 0 - handGrabber1.width;
						else //Right to left
							handGrabber1.x = stage.stageWidth + handGrabber1.width;
						
						handGrabber1.y = y1;
						var rotationalOffset:Number;
						if(handGrabber1.x < 0){ //Starting on left
							rotationalOffset = (-Math.atan2(stage.stageWidth - handGrabber1.x, y2 - y1) + Math.PI);
							handGrabber1.delta = new Point(Math.sin(rotationalOffset) * 10, -Math.cos(rotationalOffset) * 10);
						} else { //Starting on right
							rotationalOffset = (-Math.atan2(handGrabber1.x, y1 - y2) + Math.PI);
							handGrabber1.delta = new Point(Math.sin(rotationalOffset) * 10, -Math.cos(rotationalOffset) * 10);
						}
						break;
					case 1: //Vertical
						var x1:Number = Math.random() * stage.stageHeight;
						var x2:Number = Math.random() * stage.stageHeight;
						if(Math.random() > 0.5)  //Top to bottom
							handGrabber1.y = 0 - handGrabber1.height;
						else //Bottom to top
							handGrabber1.y = stage.stageHeight + handGrabber1.height;
						
						handGrabber1.x = x1;
						var rotations:Number;
						if(handGrabber1.y < 0){ //Starting on top
							rotations = (-Math.atan2(x2 - x1, stage.stageHeight - handGrabber1.y) + Math.PI);
							handGrabber1.delta = new Point(Math.sin(rotations) * 10, -Math.cos(rotations) * 10);
						} else { //Starting on the bottom
							rotations = (-Math.atan2(handGrabber1.x, x1 - x2) + Math.PI);
							handGrabber1.delta = new Point(Math.sin(rotations) * 10, -Math.cos(rotations) * 10);
						}
						break;
				}
				addChild(handGrabber1); //Can't forget this... I did many times...
				handGrabber1.isIdle = false; //Now it's doing stuff!
			} else if(handGrabber2.isIdle && Math.random() > 0.95){
				switch(int(Math.random() * 2)){
					case 0: //Horizontal
						var y1:Number = Math.random() * stage.stageHeight;
						var y2:Number = Math.random() * stage.stageHeight;
						if(Math.random() > 0.5)  //Left to right
							handGrabber2.x = 0 - handGrabber2.width;
						else //Right to left
							handGrabber2.x = stage.stageWidth + handGrabber2.width;
						
						handGrabber2.y = y1;
						var rotationalOffset:Number;
						if(handGrabber2.x < 0){ //Starting on left
							rotationalOffset = (-Math.atan2(stage.stageWidth - handGrabber2.x, y2 - y1) + Math.PI);
							handGrabber2.delta = new Point(Math.sin(rotationalOffset) * 10, -Math.cos(rotationalOffset) * 10);
						} else { //Starting on right
							rotationalOffset = (-Math.atan2(handGrabber2.x, y1 - y2) + Math.PI);
							handGrabber2.delta = new Point(Math.sin(rotationalOffset) * 10, -Math.cos(rotationalOffset) * 10);
						}
						break;
					case 1: //Vertical
						var x1:Number = Math.random() * stage.stageHeight;
						var x2:Number = Math.random() * stage.stageHeight;
						if(Math.random() > 0.5)  //Top to bottom
							handGrabber2.y = 0 - handGrabber2.height;
						else //Bottom to top
							handGrabber2.y = stage.stageHeight + handGrabber2.height;
						
						handGrabber2.x = x1;
						var rotations:Number;
						if(handGrabber2.y < 0){ //Starting on top
							rotations = (-Math.atan2(x2 - x1, stage.stageHeight - handGrabber2.y) + Math.PI);
							handGrabber2.delta = new Point(Math.sin(rotations) * 10, -Math.cos(rotations) * 10);
						} else { //Starting on the bottom
							rotations = (-Math.atan2(handGrabber2.x, x1 - x2) + Math.PI);
							handGrabber2.delta = new Point(Math.sin(rotations) * 10, -Math.cos(rotations) * 10);
						}
						break;
				}
				addChild(handGrabber2); //Can't forget this... I did many times...
				handGrabber2.isIdle = false; //Now it's doing stuff!
			}
			
			handGrabber1.updatePosition(mouseX, mouseY);
			handGrabber2.updatePosition(mouseX, mouseY);
			
			if(!handGrabber1.isIdle){
				if(handGrabber1.x + handGrabber1.width < 0 || handGrabber1.x + handGrabber1.width > stage.stageWidth){
					handGrabber1.x = handGrabber1_startPos.x;
					handGrabber1.y = handGrabber1_startPos.y;
					handGrabber1.isIdle = true;
				}
				if(handGrabber1.y + handGrabber1.height < 0 || handGrabber1.y + handGrabber1.height > stage.stageHeight){
					handGrabber1.x = handGrabber1_startPos.x;
					handGrabber1.y = handGrabber1_startPos.y;
					handGrabber1.isIdle = true;
				}
			}
			if(!handGrabber2.isIdle){
				if(handGrabber2.x + handGrabber2.width < 0 || handGrabber2.x + handGrabber2.width > stage.stageWidth){
					handGrabber2.x = handGrabber2_startPos.x;
					handGrabber2.y = handGrabber2_startPos.y;
					handGrabber2.isIdle = true;
				}
				if(handGrabber2.y + handGrabber2.height < 0 || handGrabber2.y + handGrabber2.height > stage.stageHeight){
					handGrabber2.x = handGrabber2_startPos.x;
					handGrabber2.y = handGrabber2_startPos.y;
					handGrabber2.isIdle = true;
				}
			}
			
			//Update score
			scoreDisplay.updateScore(score);
			
			if(handGrabber1.hitTestObject(gunFollower)){
				hasGun = false;
				handGrabber1.hasGun = true;
				Mouse.show();
				handGrabber1.addEventListener(MouseEvent.CLICK, giveBackGun);
				//handGrabber1.x = handGrabber1_startPos.x;
				//handGrabber1.y = handGrabber1_startPos.y;
				//removeChild(handGrabber1);
			} else if(handGrabber2.hitTestObject(gunFollower)){
				hasGun = false;
				handGrabber2.hasGun = true;
				Mouse.show();
				handGrabber2.addEventListener(MouseEvent.CLICK, giveBackGun);
				//handGrabber2.x = handGrabber2_startPos.x;
				//handGrabber2.y = handGrabber2_startPos.y;
				//removeChild(handGrabber2);
			}
			
			handGrabber1.updateGrabberRotation(mouseX - handGrabber1.x, mouseY - handGrabber1.y);
			handGrabber2.updateGrabberRotation(mouseX - handGrabber2.x, mouseY - handGrabber2.y);
			
			if(!hasGun && !showingGetGunMsg){
				getGunMsg.x = getGunMsg_pos.x;
				getGunMsg.y = getGunMsg_pos.y;
				addChild(getGunMsg);
				showingGetGunMsg = true;
			}
			if(hasGun && showingGetGunMsg){
				removeChild(getGunMsg);
				showingGetGunMsg = false;
			}
			//When time runs out
			if(timerDisplay.curTime <= 0){
				//Go to results frame and stop game
				gotoAndStop(3);
				stopGame(null);
				SoundMixer.stopAll();
				var applause:Sound = new Claps();
				applause.play(0, 500)
				
				//Display final score (Copied from score display, number positions modified for, you know... read-ability)
				var scoreStr:String = score.toString();
				var pushNextNumConst:Point = new Point(30, 0);
				var curNumPoint:Point = new Point(200, 320);
				for(var i:int = 0; i < scoreStr.length; i++){
					var numToBeAdded:GameTimerNumbers = new GameTimerNumbers();
					numToBeAdded.x = curNumPoint.x;
					numToBeAdded.y = curNumPoint.y;
					numToBeAdded.gotoAndStop(parseInt(scoreStr.charAt(i)) + 1);
					addChild(numToBeAdded);
					
					curNumPoint = curNumPoint.add(pushNextNumConst); //Move the next number to the side for more digit clearance.
				}
			}
			
			//Remove unnecessary digits from the timer to make the numbers look nicer (i.e. 35 rather than 035)
			if(!timer_isHundDigitGone && timerDisplay.curTime < 100){
				removeChild(timerDisplay.hundreds);
				timer_isHundDigitGone = true;
			}
			if(!timer_isTensDigitGone && timerDisplay.curTime < 10){
				removeChild(timerDisplay.tens);
				timer_isTensDigitGone = true;
			}
		}
		
		//Gives the player back their gun so that they can shoot targets again.
		function giveBackGun(e:MouseEvent):void {
			hasGun = true;
			handGrabber1.removeEventListener(MouseEvent.CLICK, giveBackGun);
			handGrabber2.removeEventListener(MouseEvent.CLICK, giveBackGun);
			handGrabber1.hasGun = false;
			handGrabber1.x = handGrabber1_startPos.x;
			handGrabber1.y = handGrabber1_startPos.y;
			handGrabber2.x = handGrabber2_startPos.x;
			handGrabber2.y = handGrabber2_startPos.y;
			handGrabber2.hasGun = false;
			handGrabber1.delta = new Point();
			handGrabber2.delta = new Point();
			Mouse.hide();
		}
		
		//Adds a target to the stage. Happens when the computer feels like it.
		function addATarget(){
			var toBeAdded:Target = new Target(new Point(Math.random()*422, Math.random()*290));
			
			//Overlap prevention
			var overlapping:Boolean = false;
			for each(var target:Target in objects){
				if(target.occupyingBox().intersects(toBeAdded.occupyingBox())){
					overlapping = true;
				}
			}
			while(overlapping){ //Just keep going until there's a good spot to stop
				var falseAlarm:Boolean = false;
				toBeAdded = new Target(new Point(
					Math.random()*(stage.stageWidth-new Target(new Point()).occupyingBox().width), 	   // X
					Math.random()*(stage.stageHeight-new Target(new Point()).occupyingBox().height))); // Y
				
				for each(var tar:Target in objects){
					if(!tar.occupyingBox().intersects(toBeAdded.occupyingBox()) && !falseAlarm){
						overlapping = false;
					}
					else if(!falseAlarm){
						overlapping = true;
						falseAlarm = true;
					}
				}
			}
			
			toBeAdded.addEventListener(MouseEvent.CLICK, targetWasClicked);
			objects.push(toBeAdded);
			addChild(toBeAdded);
		}
		
		//What happens when the target is clicked 
		function targetWasClicked(e:MouseEvent){
			if(hasGun){
				for(var i:int; i < objects.length; i++){
					var t:Target = objects[i];
					if(t.occupyingBox().contains(mouseX, mouseY)){
						removeChild(t);
						objects.splice(i, 1);
						new Gunshot().play();
						score++;
					}
				}
			}
		}
		
		function stopGameAndGotoMenu(e:MouseEvent):void{
			//Go to the menu frame and stop
			gotoAndStop(1);
			stopGame(null);
			SoundMixer.stopAll();
			
			//Actual menu transition
			f1_startBtn.addEventListener(MouseEvent.CLICK, startTheGame);
			addChild(f1_startBtn.txtBox);
			addChild(f1_startBtn);
			
			//Reset variables
			hasGun = true;
			handGrabber1.hasGun = false;
			handGrabber2.hasGun = false;
			score = 0;
		}
		
		//Stops the game and returns to the main menu.
		function stopGame(e:MouseEvent):void{
			//Frame 2 cleanup
			f2_stopBtn.removeEventListener(MouseEvent.CLICK, stopGame);
			removeChild(f2_stopBtn.txtBox);
			removeChild(f2_stopBtn);
			removeChild(gunFollower);
			stage.removeEventListener(Event.ENTER_FRAME, updateGun);
			
			//Remove the targets
			if(objects.length > 0){
				for each(var t:Target in objects){
					removeChild(t);
				}
			}
			objects = new Array();
			
			//Remove the hands
			Mouse.show();
			removeChild(handGrabber1);
			
			//Remove the UI
			timerDisplay.goAway();
			removeChild(scoreDisplay);
			removeChild(timerDisplay);
			if(!timer_isHundDigitGone)
				removeChild(timerDisplay.hundreds);
			if(!timer_isTensDigitGone)
				removeChild(timerDisplay.tens);
			removeChild(timerDisplay.ones);
			
			//Stop the timers
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER, updateGame);
		}
	}
	
}
