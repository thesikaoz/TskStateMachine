package statemachine.rules;
import flixel.FlxG;
/**
 * Contains all the necesary data and methods for a time based rule.
 * @author Dany
 */
class AfterRule extends ConditionalRule
{

	/**
	 * The counter updated every frame.
	 */
	private var waitCounter:Float;
	/**
	 * The numer of seconds to wait.
	 */
	private var seconds:Float;
	/**
	 * The second condition to be met.
	 */
	private var secondRule:Void->Bool;
	/**
	 * The required value of the second condition.
	 */
	private var secondRequiredValue:Bool;
	
	/**
	 * Creates a new rule that triggers after the given time and condition.
	 * @param	_destiny The destiny state.
	 * @param	_seconds The number of seconds to wait.
	 * @param	_onTransition A method to be executed on transition.
	 * @param	_condition A second condition to be met for the transition to happen.
	 * @param	_requiredValue The required output for the second condition. NOT the timer.
	 */
	public function new(_destiny:String, _seconds:Float, ?_onTransition:Void->Void,?_condition:Void->Bool,?_requiredValue:Bool=true) {
		super(_destiny, wait, true, _onTransition);
		waitCounter = 0;
		secondRule = _condition;
		secondRequiredValue = _requiredValue;
		seconds = _seconds;
	}
	
	/**
	 * The wait function that does the countdown of the timer, this is the function that's actually pased as transitional rule.
	 * Does the countdown and the second function should it be considered.
	 */
	private function wait() {
		if (waitCounter > seconds) {
			if ( secondRule == null) {
				resetCounter();
				return true;
			}else {
				return secondRule() == secondRequiredValue;
			}
		}else {
			waitCounter += FlxG.elapsed;
			return false;
		}
	}
	
	/**
	 * Resets the counter, to be called upon exiting the state so it doesn't hold up any values next time it enters.
	 */
	public function resetCounter() {
		waitCounter = 0;
	}
	
}