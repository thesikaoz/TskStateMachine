package tools.statemachine;

import tools.statemachine.machines.GraphicStateMachine;
import flixel.FlxSprite;

/**
 * ...
 * @author Dany
 */
class StateSprite extends FlxSprite
{

	public var machine:GraphicStateMachine;
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, SimpleGraphic);
		machine = new GraphicStateMachine("MAIN", animation);
	}
	
	override public function update(elapsed:Float):Void 
	{
		machine.update();
		super.update(elapsed);
	}
	
}