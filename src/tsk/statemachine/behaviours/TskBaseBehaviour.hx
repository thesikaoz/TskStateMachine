package tsk.statemachine.behaviours;
import flixel.FlxSprite;
import tsk.statemachine.machines.TskSimpleStateMachine;
import tsk.statemachine.states.TskState;

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