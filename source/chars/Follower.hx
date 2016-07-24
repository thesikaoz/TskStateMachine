package chars;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import tools.statemachine.StateSprite;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxG;
using tools.extended.ExtInt;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import tools.statemachine.behaviours.TskBaseBehaviour;
/**
 * ...
 * @author ...
 */
class Follower extends StateSprite
{

	var objective:FlxPoint;
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/player2.png", true, 16, 16);
		
		acceleration.y = 500;
		
		width *= 0.4;
		height *= 0.9;
		centerOffsets();
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		FlxG.log.add(frames.frames.length);
		
		machine.addAnimState("idle",new FollowerDefaultB(this), [5]);
		machine.addAnimState("run", new FollowerMovingB(this) , 0.to(2),5);
		machine.addAnimState("jump", new FollowerMovingB(this), [4]);
		machine.addAnimState("fall",new FollowerMovingB(this), [4]);
		
		machine.getState("idle").addTransition("jump", pressJump,true,doJump);
		machine.getState("idle").addTransition("run", pressWalk);
		machine.getState("jump").addTransitionAfter("fall", 0.3);
		machine.getState("jump").addTransition("idle", isOnLand);
		machine.getState("run").addTransition("idle", pressWalk, false);
		machine.getState("run").addTransition("jump", pressJump,true,doJump);
		machine.getState("fall").addTransition("idle", isOnLand);
		machine.start("idle");
				
		FlxG.watch.add(machine,"currentState", "follower state");
	}
	
	private function pressJump():Bool{
		var r:Bool = false;
		if (PlayState.current._player.machine.currentState == "idle"){
			r = PlayState.current._player.y < this.y;
		}
		return r;
	}
	
	private function doJump(){
		velocity.y =-200;
	}
	
	private function pressWalk():Bool{
		if (Math.abs(PlayState.current._player.x - x)>20|| Math.abs(PlayState.current._player.y-y)>20){
			return true;
		}else{
			return false;
		}
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
		if (machine.currentState == "run" || machine.currentState=="idle"){
			if (PlayState.current._player.x > x){
				facing = FlxObject.RIGHT;
			}else{
				facing = FlxObject.LEFT;
			}
		}
	}
}


private class FollowerDefaultB<Follower> extends TskBehaviour<FlxSprite>{
	
	override public function onUpdate(e:Float) 
	{
		handleMovement();
	}
	
	private function handleMovement(){
		this.ownerSprite.velocity.x = 0;
	}
}

private class FollowerMovingB extends FollowerDefaultB<Follower>{
	override function handleMovement() 
	{
		var aux:Float = PlayState.current._player.x - ownerSprite.x;
		if (aux<-10){
			ownerSprite.velocity.x =-90;				
		}else if (aux>10){
			ownerSprite.velocity.x = 90;
		}else{
			ownerSprite.velocity.x = 0;
		}
	}
}