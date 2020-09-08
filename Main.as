package {
	import flash.desktop.NativeApplication;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.text.engine.JustificationStyle;
	
	
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.StageQuality;
	
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.desktop.SystemIdleMode;
	
	import Vines.Vine;
	
	/**
	 * ...
	 * @author Xiler
	 */
	public class Main extends Sprite {
		private var spawnLastTime:Number;
		//DEVELOER VARIABLES
		private var godMode:Boolean = false;
		
		// DEVICE CONSTANTS
		private const screenSizeX:int = stage.stageWidth;
		private const screenSizeY:int = stage.stageHeight;
		
		//xiler animation
		private var xiler:Xiler;
		private var xilerTimer:Timer;
		private const xilerShowTime:int = 3000;
		
		//loading screen
		private var loadingScreen:LoadingScreen;
		private var loadingScreenTimer:Timer;
		private const loadingScreenShowTime:int = 5000;
		//UI system
		private var playButton:Play;
		private var pointsShower:PointsShower;
		private var highScoreShower:HighScoreShower;
		private var jungleBird:JungleBird;
		
		// all x movement system
		private var movingSprite:Sprite;
			private var movingSpritePosition:Point;
			private var screenPasses:int;
			private var base1:CachedSprite;
			private var base2:CachedSprite;
			private var spawnTimer:Timer;
			private var timesSpawnTimerGoneOff:int;
			private var vinesSpawned:int;
		private var vines:Array;
		private var gameSpeed:Number = 2.4; // seconds for a full revolution (across whole screen)
		private var vineSeparation:int = 415;
		private var beginingOffset:Number = 500;
		
		
		//bird movement system
		private var birdy:CachedSprite;
		private var birdyOffsetX:Number = 0.25;
		private var birdyPosition:Point;
		private var birdyVelocityY:Number;
		private var rasingGravity:Number = 2.6;
		private var fallingGravity:Number = 2.6;
		private var birdyTapVelocity:Number = -28;
		private var birdyMaxFallVelocity:Number = 65;
		
		//collision system
		private var collisionMinY:Number;
		private var collisionMaxY:Number;
		private var collisionVine:Vine
		
		private var birdyHalfWidth:Number;
		private var birdyHalfHeight:Number;
		private var birdyWidthMultiplier:Number = 1.2;
		private var birdyHeightMultiplier:Number = .75;
		
		// Player system
		private var points:int;
		private var pointReceived:Boolean;
		private var pointsTracker:PointsTracker;
		private var dead:Boolean;
		private var isGameOver:Boolean;
		
		// Save
		private var theData:SharedObject = SharedObject.getLocal("Hola!");
		private var highscore:int;
		
		// Sounds
		private var jumpSound:Sound;
		private var hitSound:Sound;
		private var pointGainSound:Sound;
		private var loopSound:Sound;
		private var theChannel:SoundChannel;
		private var loopIsPlaying:Boolean;
		
		private var loopPausePosition:int;
		private var loopIsPaused:Boolean;
		//other
		private var lastTime:int;
		private var playedOnce:Boolean = false;
		private var inGame:Boolean;
		private var background:CachedSprite;
		private var pausedTime:int;
		private var gameActive:Boolean;
		
		public function Main():void {
			stage.scaleMode = StageScaleMode.EXACT_FIT
			stage.align = StageAlign.TOP_LEFT;
			
			if(Capabilities.cpuArchitecture=="ARM"){
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}
			
			
			
			// entry point
			xilerAnimation();
		}
		 
		private function deactivate(event:Event):void{
			pause();
		}
		private function activate(event:Event):void{
			resume();
		}
		 
		private function handleKeys(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.BACK) NativeApplication.nativeApplication.exit();
		}
		
		
		
		private function startMusicLoop(position:int = 0):void {
			if(!loopIsPlaying && gameActive){
				loopIsPlaying = true;
				theChannel = loopSound.play(position);
				theChannel.addEventListener(Event.SOUND_COMPLETE, musicLoop);
			}
		}
		private function endMusicLoop():void {
			if(loopIsPlaying){
				loopIsPlaying = false
				theChannel.stop();
				theChannel.removeEventListener(Event.SOUND_COMPLETE, musicLoop);
			}
		}
		private function pauseMusicLoop():void {
			if (loopIsPlaying && !loopIsPaused) {
				loopPausePosition = theChannel.position;
				loopIsPaused = true;
				endMusicLoop();
			}
		}
		private function resumeMusicLoop():void {
			if (!loopIsPlaying && loopIsPaused) {
				loopIsPaused = false;
				startMusicLoop(loopPausePosition);
			}
		}
		private function musicLoop(event:Event):void {
			if(gameActive){
				theChannel.removeEventListener(Event.SOUND_COMPLETE, musicLoop);
				theChannel = loopSound.play();
				theChannel.addEventListener(Event.SOUND_COMPLETE, musicLoop);
			}else {
				endMusicLoop();
			}
		}
		
		private function xilerAnimation():void {
			xiler = new Xiler();
			addChild(xiler);
			xilerTimer = new Timer(xilerShowTime, 1);
			xilerTimer.addEventListener(TimerEvent.TIMER, endXilerAnimation);
			xilerTimer.start();
		}
		
		private function endXilerAnimation(event:TimerEvent):void {
			xilerTimer.stop();
			xilerTimer.removeEventListener(TimerEvent.TIMER, endXilerAnimation);
			removeChild(xiler);
			
			startLoadingScreen();
		}
		
		private function startLoadingScreen():void {
			loopSound = new Loop();
			startMusicLoop();
			
			loadingScreen = new LoadingScreen();
			addChild(loadingScreen);
			loadingScreenTimer = new Timer(loadingScreenShowTime,1);
			loadingScreenTimer.addEventListener(TimerEvent.TIMER, endLoadingScreen);
			loadingScreenTimer.start();
			
		}
		private function endLoadingScreen(event:Event):void {
			loadingScreenTimer.stop();
			loadingScreenTimer.removeEventListener(TimerEvent.TIMER, endLoadingScreen);
			removeChild(loadingScreen);
			
			preAppSetup();
			
		}
		
		
		
		
		private function preAppSetup():void {
			
			//stage.quality = StageQuality.LOW
			
			// Menu UI
			
			jungleBird = new JungleBird();
			jungleBird.y = 25;
			
			highScoreShower = new HighScoreShower();
			highScoreShower.y = 225;
			//TextField(highScoreShower.text).autoSize = TextFieldAutoSize.CENTER;
			
			pointsShower = new PointsShower();
			pointsShower.y = 550;
			//TextField(pointsShower.text).autoSize = TextFieldAutoSize.CENTER;
			
			
			playButton = new Play();
			playButton.width = screenSizeX / 2;
			playButton.x = (screenSizeX / 2) - (playButton.width / 2);
			playButton.y = (screenSizeY - playButton.height) - 50;
			
			// Save
			if (theData.data.score != undefined) {
				//a save is here
				updateHighScore(theData.data.score);
			}else {
				updateHighScore(0);
			}
			
			// Game
			movingSprite = new Sprite();
			movingSpritePosition = new Point();
			base1 = new CachedSprite(Base,false,1);
			base1.y = screenSizeY - base1.height;
			
			base2 = new CachedSprite(Base,false,1);
			base2.y = screenSizeY - base2.height;
			
			birdy = new CachedSprite(Bird, true,1);
			birdyPosition = new Point();
			birdyPosition.x = screenSizeX * birdyOffsetX;
			birdy.x = birdyPosition.x
			birdyHalfWidth = (birdy.width / 2) * birdyWidthMultiplier;
			birdyHalfHeight = (birdy.height / 2) * birdyHeightMultiplier;
			
			
			spawnTimer = new Timer((vineSeparation / (screenSizeX / gameSpeed)) * (1000/2), 0);
			
			//Game UI
			pointsTracker = new PointsTracker();
			TextField(pointsTracker.text).autoSize=TextFieldAutoSize.LEFT
			pointsTracker.x = 25;
			pointsTracker.y = 0;
			
			background = new CachedSprite(Background, false , 1);
			
			Vine.setParent(movingSprite);
			
			
			
			jumpSound = new Jump();
			hitSound = new Hit();
			pointGainSound = new PointGain();
			
			//start
			appLoop();
		}
		
		private function appLoop():void {
			inGame = false;
			addChild(jungleBird);
			addChild(highScoreShower);
			addChild(pointsShower);
			pointsShower.text.text = String(points);
			addChild(playButton);
			if (playedOnce) {
				playButton.addEventListener(MouseEvent.CLICK, reverse);
			}else {
				playButton.addEventListener(MouseEvent.CLICK, startGameLoop);
			}
			if (!loopIsPlaying) {
				startMusicLoop();
			}
		}
		
		private function reverse(event:MouseEvent = null):void {
			
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, tap);
			
			spawnTimer.removeEventListener(TimerEvent.TIMER, retrieveAVine);
			
			removeChild(background);
			for (var i:int = 0; i < vines.length; i++) {
				movingSprite.removeChild(vines[i]);
			}
			removeChild(movingSprite);
			movingSprite.removeChild(base1);
			movingSprite.removeChild(base2);
			removeChild(birdy);
			
			
			
			startGameLoop();
		}
		
		private function startGameLoop(event:MouseEvent = null):void {
			
			endMusicLoop();
			
			if (playedOnce) {
				playButton.removeEventListener(MouseEvent.CLICK, reverse);
			}else {
				playButton.removeEventListener(MouseEvent.CLICK, startGameLoop);
			}
			playedOnce = true;
			inGame = true;
			removeChild(jungleBird);
			removeChild(playButton);
			removeChild(pointsShower);
			removeChild(highScoreShower);
			
			
			
			Vine.spawnVines();
			
			
			screenPasses = 0;
			points = 0;
			dead = false;
			isGameOver = false;
			collisionVine = null; // this is set to null becasue its null value is used in the game loop to start the collisions tracker with the vines
			pointReceived = false;
			vinesSpawned = 0;
			vines = new Array();
			timesSpawnTimerGoneOff = 0;
			
			addChild(background);
			
			addChild(movingSprite);
			movingSpritePosition.x = 0;
			movingSprite.addChild(base1);
			base1.x = 0
			movingSprite.addChild(base2);
			base2.x = base1.width;
			
			addChild(birdy);
			birdyPosition.y = screenSizeY / 2-340;
			birdy.y = birdyPosition.y;
			birdyVelocityY = 0;
			
			
			addChild(pointsTracker);
			updatePoints();
			
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, tap);
			
			spawnTimer.addEventListener(TimerEvent.TIMER, retrieveAVine);
			spawnTimer.start();
			
			
			lastTime = getTimer();
		}
		
		
		
		
		private function loop(event:Event):void {
			// movingSprite movement calculation based on device size (so, same screen speedno matter what device screen size)
			var thisTime:int = getTimer();
			var change:Number = (thisTime- lastTime) / 1000;
			lastTime = thisTime;
			var pixelChange:Number = (change / gameSpeed) * screenSizeX;
			
			
			// BIRDY MOVEMENT ( happens whether dead of alive
			if (birdyVelocityY < 0) { // if going up
				birdyVelocityY += rasingGravity;
			}else { // must be falling
				birdyVelocityY += fallingGravity;
			}
			birdyPosition.y += birdyVelocityY; // for technical reasons
			if (birdyVelocityY > birdyMaxFallVelocity) {
				birdyVelocityY = birdyMaxFallVelocity;
			}
			birdy.y = birdyPosition.y;
			
		// if bird hits ground (whether already dead=true or not)
			if (birdyPosition.y + birdyHalfHeight >= base1.y) {
				birdyPosition.y = base1.y - birdy.height / 2;
				birdy.y = birdyPosition.y;
				die();
				gameOver()
			}
				
			if (!dead){
				movingSpritePosition.x += -pixelChange;
				movingSprite.x = int(movingSpritePosition.x);
				
				if (movingSprite.x < (screenPasses + 1) * -base1.width) {
					if (screenPasses % 2 == 0) {
						base1.x = (screenPasses + 2) * base1.width;
					}else {
						base2.x = (screenPasses + 2) * base2.width;
					}
					screenPasses++;
				}
			
			
			//BIRDY COLLISION (with vines)
				if (collisionVine != null) {
					var relativeCollisionX:Number = (collisionVine.x - collisionVine.getOffsetX ) + movingSpritePosition.x;
					if (relativeCollisionX < birdyPosition.x + birdyHalfWidth) {
						
						if ((relativeCollisionX + Vine.VINE_WIDTH > birdyPosition.x - birdyHalfWidth)) {
							if (!pointReceived && relativeCollisionX + (Vine.VINE_WIDTH/2) < birdyPosition.x) {
								pointReceived = true;
								points++;
								theChannel = pointGainSound.play();
								updatePoints();
							}
							if (birdyPosition.y - birdyHalfHeight < collisionMinY || birdyPosition.y + birdyHalfHeight > collisionMaxY) {
								// houston, we have a collision...
								if (!godMode) {
									die();
									theChannel = hitSound.play();
								}
							}
						}else {
							pointReceived = false;
							setCollisionTracker(vines[vines.indexOf(collisionVine)+1]);
						}
						
					}
				}
			}
		}
		
		private function retrieveAVine(event:TimerEvent):void {
			if (timesSpawnTimerGoneOff % 2 == 0) {
				var newVine:Vine = Vine.getRandomVine();
				newVine.spawn((vinesSpawned * vineSeparation) + screenSizeX + beginingOffset);
				vines.push(newVine);
				vinesSpawned++;
				// this happens just once
				if (collisionVine==null) {
					setCollisionTracker(newVine);
				}
			}else {
				if (vines[0].x + movingSpritePosition.x < -vines[0].width) {
					vines[0].x = Vine.VINE_WIDTH
					vines[0].y = vines[0].height;
					//Vine(vines[0]).unSpawn();
					Vine.addBackVine(vines[0]);
					vines.shift();
				}
			}
			timesSpawnTimerGoneOff++;
		}
		
		private function tap(event:MouseEvent):void {
			if (!dead) {
				birdyVelocityY = birdyTapVelocity;
				theChannel = jumpSound.play();
			}
		}
		private function setCollisionTracker(vine:Vine):void {
			collisionVine = vine;
			collisionMinY = collisionVine.collisionMinY;
			collisionMaxY = collisionVine.collisionMaxY;
		}
		private function updatePoints():void {
			pointsTracker.text.text = String(points);
		}
		private function die():void {
			dead = true;
		}
		private function gameOver():void {
			isGameOver = true;
			removeChild(pointsTracker);
			removeEventListener(Event.ENTER_FRAME, loop);
			spawnTimer.stop();
			appLoop();
			save();
		}
		
		private function pause():void {
			pauseMusicLoop();
			gameActive = false;
			if (inGame) {
				removeEventListener(Event.ENTER_FRAME, loop);
				pausedTime = getTimer();
			}
		}
		private function resume():void {
			gameActive = true;
			resumeMusicLoop();
			if (inGame) {
				addEventListener(Event.ENTER_FRAME, loop);
				lastTime += (getTimer() - pausedTime);
			}
		}
		
		private function save():void {
			if (points > highscore) {
				updateHighScore(points);
			}
		}
		private function updateHighScore(num:int):void {
			highscore = num;
			theData.data.score = num;
			highScoreShower.text.text = String(highscore);
			theData.flush();
		}
	}
}