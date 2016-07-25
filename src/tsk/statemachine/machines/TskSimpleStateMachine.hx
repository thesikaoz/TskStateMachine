package tsk.statemachine.machines;
import tsk.statemachine.behaviours.TskBaseBehaviour;
import tsk.statemachine.states.TskState;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
/**
 * Simple Machine that does not implement any graphical functionality AKA animation control. Can be used
 * with any Flixel object as long as it can update the machine calling this class' update() method.
 * @author Dany
 */
class TskSimpleStateMachine extends TskState
{
	/**
	 * A string containing this machine's current state's name.
	 */
	public var currentState:String;
	public var lastState:String;
	/**
	 * A pointer to the current state of the machine.
	 */
	private var state:TskState;
	
	/**
	 * Wheter this machine should be in execution.
	 */
	public var paused:Bool = false;
	
	/**
	 * Array of posible machine states.
	 */
	private var states:Array<TskState>;
	/**
	 * The name of the first state, to be used by start() and restart().
	 */
	private var startingState:String;
	/**
	 * The name of the last state, used for the executionEnded() check.
	 */
	private var endingState:String;
	
	
	/**
	 * Creates a new state machine.
	 * @param	_name The name of the machine, important only if this is a submachine.
	 */
	public function new(_name:String) {
		super(_name);
		this.states = new Array<TskState>();
		paused = true;
	}
	
	/**
	 * Starts execution of the machine. Fails if inital state dos not exist.
	 * @param	initialState The name of the initial machine state.
	 */
	public function start(initialState:String) {
		startingState = initialState;
		if(startingState!=null){
			if (forceState(startingState)) {
				paused = false;
			}
		}else {
			FlxG.log.error("Machine has no starting state");
		}
	}
	
	/**
	 * A simple function that prints this machine's name, states, starting and ending state to the
	 * default log FlxG.log
	 */
	public function printDebug() {
		FlxG.log.add("States for " + name+":");
		for ( st in states) {
			var _st:TskState = cast st;
			FlxG.log.add(st.name);
		}
		FlxG.log.add("Initial State: " + startingState);
		FlxG.log.add("Ending State: "+endingState);
	}
	
	/**
	 * Restarts the machine using the state previously defined with start() as the initial state.
	 */
	public function restart() {
		if(startingState!=null){
			if (forceState(startingState)) {
				paused = false;
			}
		}else {
			FlxG.log.error("Machine has no starting state");
		}
	}
	
	/**
	 * Sets the ending state, useful for the executionEnded() check.
	 * @param	_state The name of the ending state.
	 */
	public function setEndingState(_state:String) {
		endingState = _state;
	}
	
	/**
	 * This method can be pointed at with transitional rules to exit submachines once they've ended execution.
	 * @return Wheter the machine has reached the final state.
	 */
	public function executionEnded():Bool {
		return state.name == endingState;
	}
	
	/**
	 * Forces the machine to go to the given state regardless of transitional rules. Use with caution, can cause fuzzy logic.
	 * @param	_state The name of the state to go to.
	 * @return Wheter the new state was initiated succesfully
	 */
	public function forceState(_state:String,?_force:Bool=false):Bool {
		var s:TskState = getState(_state);
		if (s != null) {
			if (!_force){
				if(state!=null){
					state.behaviour.onExit();
				}
				s.behaviour.onEnter();
			}
			state = s;
			return true;
		}else {
			FlxG.log.warn("State " + _state + " does not exist!");
			return false;
		}
	}
	
	/**
	 * Adds a simple state to the machine. It will overwrite any previous states with the same name and discard the former's transitional rules.
	 * @param	s The name of the state.
	 */
	public function addState(s:String,?_behaviour:TskBehaviour<FlxSprite>) {
		removeState(s);
		var _s:TskState = new TskState(s,_behaviour);
		this.states.push(_s);
	}
	
	/**
	 * Adds a submachine as a substate of this machine. The submachine must extend SimpleStateMachine in order to be
	 * handled as a state by this machine.
	 * @param	sm The substate machine.
	 */
	public function addSubMachine(sm:TskSimpleStateMachine) {
		states.push(sm);
	}
	
	
	/**
	 * Removes a state and all of it's transitional rules.
	 * @param	s The name of the state.
	 */
	public function removeState(s:String) {
		var _s:TskState = getState(s);
		if (_s != null) {
			this.states.remove(_s);
		}
	}
	
	/**
	 * To be called on the update method on the object, performs all the processing of transitions and submachines.
	 */
	public function update() {
		if (!paused){
			if (state != null) {
				currentState = state.name; //update string value
				state.behaviour.onUpdate(0.0);
				for (rule in state.rules) {
					if (rule.condition() == rule.requiredValue) { //the rule has met it's condition
						//we clean up the current state to ready up for change
						if(rule.onTransition!=null)rule.onTransition();
						cleanUpState();
						
						if (forceState(rule.destiny)) { //if the state it's not null change it, if it is launch error
							lastState = currentState;
							
							//we starte it if it's a machine
							if (Std.instance(state, TskSimpleStateMachine) != null) {
								var sm:TskSimpleStateMachine = cast state;
								sm.restart();
							}
							
						}else {
							FlxG.log.error("State " + rule.destiny + " does not exist! Execution stopped");
							paused = true;
						}
						return;
					}
				}
				if (Std.instance(state, TskSimpleStateMachine) != null) {
					var sm:TskSimpleStateMachine = cast state;
					sm.update();
				}
			}else {
				FlxG.log.error("State machine \""+name+"\" was started without starting state. Execution stopped");
				paused = true;
				currentState = "NULL";
			}
		}
	}
	
	/**
	 * A function to do the last clean up operations of the state when this is exited.
	 */
	private function cleanUpState() {
		//if (rule.playAnimation) owner.animation.play(state.name);
		state.resetCounters();
	}
	
	
	
	/**
	 * Pulls a state from the state machine so new transitional rules can be added to it. WARNING: Does not perfom null check.
	 * @param	_name The name of the desired state.
	 * @return A pointer to the desired state.
	 */
	public function getState(_name:String):TskState{
		for (s in states) {
			if (s.name == _name) {
				return s;
			}
		}
		return null;
	}
	
	
}