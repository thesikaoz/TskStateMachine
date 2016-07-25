package statemachine.behaviours;
import flixel.FlxSprite;
import statemachine.machines.SimpleStateMachine;
import statemachine.states.State;

typedef TskBaseBehaviour=TskBehaviour<FlxSprite>

/**
 * ...
 * @author ...
 */
class TskBehaviour<C:FlxSprite>
{

	public var ownerSprite:C;
	public function new(?_ownerSprite:C) 
	{
		this.ownerSprite = _ownerSprite;
	}
	
	public function onUpdate(e:Float){
		
	}
	
	public function onEnter(){
		
	}
	
	public function onExit(){
		
	}
}