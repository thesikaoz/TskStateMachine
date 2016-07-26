package tsk.statemachine.states;
import tsk.statemachine.behaviours.TskBaseBehaviour;
import tsk.statemachine.rules.TskAfterRule;
import tsk.statemachine.rules.TskRule;
import flixel.FlxSprite;
/**
 * ...
 * @author Dany
 */
class TskState
{
	/**
	 * The name of this state.
	 */
	public var name(default, null):String;
	/**
	 * Array containing the rules to transition from this state into others.
	 */
	public var rules(default, null):Array<TskRule>;
	
	private var behaviour:TskBehaviour<FlxSprite>;
	/**
	 * Constructs a new state.
	 * @param	_name The name of this state.
	 */
	public function new(_name:String,?_behaviour:TskBehaviour<FlxSprite>) {
		this.name = _name;
		this.rules = new Array<TskRule>();
		if (_behaviour != null){
			behaviour = _behaviour;
		}else{
			behaviour = new TskBaseBehaviour();
		}
	}

	/**
	 * Adds a new transitional rule for the state or submachine.
	 * @param	_destiny The state to go to if the rule is met.
	 * @param	_condition The function necesary for the transition to happen.
	 * @param	_requiredValue The value the previous function needs to meet for the transition to happen.
	 * @param	_onTransition A function to execute if the transition happens succesfuly.
	 */
	public function addTransition(_destiny:String , _condition:Void->Bool, ?_requiredValue:Bool = true, ?_onTransition:Void->Void) {
		removeTransitionTo(_destiny);
		rules.push(new TskRule(_destiny, _condition, _requiredValue, _onTransition));
	}
	
	/**
	 * Adds a new transitional rule for this state after a given time in seconds. You may also configure an aditional condition to be met before the transition happens.
	 * @param	_destiny The next state to execute.
	 * @param	_seconds Time in seconds to wait.
	 * @param	_onTransition Optional method to be executed when transition happens.
	 * @param	_condition Optional aditional condition to be met.
	 * @param	_requiredValue Required value for the second optional condition. NOT for the timer.
	 */
	public function addTransitionAfter(_destiny:String, _seconds:Float, ?_onTransition:Void->Void, ?_condition:Void->Bool, ?_requiredValue:Bool = true) {
		removeTransitionTo(_destiny);
		rules.push(new TskAfterRule(_destiny, _seconds, _onTransition, _condition, _requiredValue));
	}
	
	/**
	 * Removes any transitional rules to the given state.
	 * @param	_state The name of the destination state to look for.
	 */
	public function removeTransitionTo(_state:String) {
		var filteredRules:Array<TskRule> = rules.filter(function(r:TskRule):Bool { return r.destiny == _state; } );
		for (rule in filteredRules) {
			rules.remove(rule);
		}
	}
	
	/**
	 * Resets all the rule counters for rules that depend on time.
	 */
	public function resetCounters() {
		for (rule in rules) {
			if (Std.instance(rule, TskAfterRule) != null) {
				var r:TskAfterRule = cast rule;
				r.resetCounter();
			}
		}
	}
	
	public function onUpdate(e:Float){
		if (behaviour != null){
			behaviour.onUpdate(e);
		}
	}
	
	public function onEnter(){
		if (behaviour != null){
			behaviour.onEnter();
		}
	}
	
	public function onExit(){
		if (behaviour != null){
			behaviour.onExit();
		}
	}
}