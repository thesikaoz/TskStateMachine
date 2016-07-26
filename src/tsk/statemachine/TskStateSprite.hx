package tsk.statemachine;

import tsk.statemachine.machines.TskGraphicStateMachine;
import flixel.FlxSprite;

/**
 * ...
 * @author Dany
 */
class TskStateSprite extends FlxSprite
{

	public var machine:TskGraphicStateMachine;
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, SimpleGraphic);
		machine = new TskGraphicStateMachine("MAIN", animation);
	}
	
	override public function update(elapsed:Float):Void 
	{
		machine.update(elapsed);
		super.update(elapsed);
	}
	
}