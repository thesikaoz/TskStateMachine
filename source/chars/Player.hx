package chars;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import tools.statemachine.StateSprite;
import tools.statemachine.behaviours.TskBaseBehaviour;
using tools.extended.ExtInt;
/**
 * ...
 * @author ...
 */
class Player extends StateSprite
{

	public function new(X:Float,Y:Float) 
	{
		super(X,Y);
		acceleration.y = 500;
		loadGraphic("assets/images/player.png", true, 16, 16);
		width *= 0.4;
		height *= 0.9;
		centerOffsets();
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		machine.addAnimState("idle",new TskBaseBehaviour(this),[5]);
		machine.addAnimState("jump",new TskBaseBehaviour(this),[4]);
		machine.addAnimState("run",new TskBaseBehaviour(this),0.to(2),5);
		machine.addAnimState("fall",new TskBaseBehaviour(this),[4]);
		
		machine.getState("idle").addTransition("jump", pressJump,true,doJump);
		machine.getState("idle").addTransition("run", pressWalk);
		machine.getState("jump").addTransitionAfter("fall", 0.3);
		machine.getState("jump").addTransition("idle", isOnLand);
		machine.getState("run").addTransition("idle", pressWalk, false);
		machine.getState("run").addTransition("jump", pressJump,true,doJump);
		machine.getState("fall").addTransition("idle", isOnLand);
		machine.start("idle");
		
		FlxG.watch.add(machine, "currentState", "player state");
	}
	
	private function doJump(){
		velocity.y =-200;
	}
	
	private function pressJump():Bool{
		return FlxG.keys.justPressed.UP;
	}
	
	private function pressWalk():Bool{
		return FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT;
	}
	
	private function isOnLand():Bool{
		return isTouching(FlxObject.FLOOR);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		handleMovement();
	}
	
	private function handleMovement(){
		if (machine.currentState == "run" || machine.currentState == "jump" || machine.currentState == "fall"){
			if (FlxG.keys.pressed.LEFT){
				velocity.x =-100;
				facing = FlxObject.LEFT;
			}else if (FlxG.keys.pressed.RIGHT){
				velocity.x = 100;
				facing = FlxObject.RIGHT;
			}else{
				velocity.x = 0;
			}
		}else{
			velocity.x = 0;
		}
	}
}