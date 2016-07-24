package tools.statemachine.behaviours;
import flixel.FlxSprite;
import tools.statemachine.machines.SimpleStateMachine;
import tools.statemachine.states.State;

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