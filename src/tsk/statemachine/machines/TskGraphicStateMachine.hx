package tsk.statemachine.machines;
import flixel.animation.FlxAnimationController;
import tsk.statemachine.behaviours.TskBaseBehaviour;
import flixel.FlxSprite;
/**
 * An extended machine that can control animations for FlxSprite too.
 * @author Dany
 */
class TskGraphicStateMachine extends TskSimpleStateMachine
{

	/**
	 * A reference to the animation controller to be used.
	 */
	private var animation:FlxAnimationController;
	
	/**
	 * Creates a new state machine with the given name, requires animation controller to automatically set up the animations
	 * allong with the states.
	 * @param	_name The name of this machine.
	 * @param	anim The reference to the animation controller to be used.
	 */
	public function new(_name:String,anim:FlxAnimationController) 
	{
		super(_name);
		this.animation = anim;
	}
	
	/**
	 * Adds a new state to this machine along with the required fields to create a matching animation.
	 * @param	s The name of the state.
	 * @param	behaviour 
	 * @param	frames An array of integers for the frames of the animation.
	 * @param	framerate The speed of the animation.
	 * @param	looped Wheter this animation should repeat itself once it finishes. This has nothing to do with the state machine execution, just the animation itself.
	 */
	public function addAnimState(s:String,behaviour:TskBehaviour<FlxSprite>,frames:Array<Int>,?framerate:Int=30,?looped:Bool=true) 
	{
		super.addState(s,behaviour);
		animation.add(s, frames, framerate, looped);
	}
	
	
	override function switchState(_state:String,?_force:Bool=false) :Bool
	{
		var r:Bool=super.switchState(_state,_force);
		if (animation.getByName(state.name) != null) {
			animation.play(state.name);
		}
		return r;
	}
	
	
	/**
	 * Simple function to be used as a rule for transitions more easily.
	 * @return Wheter the currently playing animation has ended.
	 */
	public function animationEnded():Bool {
		return animation.finished;
	}
}