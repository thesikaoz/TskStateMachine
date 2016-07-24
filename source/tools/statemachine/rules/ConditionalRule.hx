package tools.statemachine.rules;

/**
 * Holds all the necesary parameters for a transitional rule to happen.
 * @author Dany
 */
class ConditionalRule
{
	/**
	 * The destiny of this rule.
	 */
	public var destiny:String;
	/**
	 * A pointer to the method to be executed when this is true.
	 */
	public var onTransition:Void->Void;
	/**
	 * The condition for this rule.
	 */
	public var condition:Void->Bool;
	/**
	 * The required value for this rule to trigger.
	 */
	public var requiredValue:Bool;
	
	/**
	 * Creates a new conditional rule
	 * @param	_destiny The destiny state.
	 * @param	_condition The condition to be met.
	 * @param	_requiredValue The required output of the condition.
	 * @param	_onTransition A method to be executed if the condition happens.
	 */
	public function new(_destiny:String,_condition:Void->Bool,?_requiredValue:Bool=true, ?_onTransition:Void->Void) {
		this.destiny = _destiny;
		this.onTransition = _onTransition;
		this.condition = _condition;
		this.requiredValue = _requiredValue;
	}
	
	
}