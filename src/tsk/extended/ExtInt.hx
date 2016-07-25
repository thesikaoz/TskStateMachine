package tsk.extended;

/**
 * ...
 * @author Dany
 */
class ExtInt
{
	static public function to(i:Int, j:Int):Array<Int> {
		return [for (x in i...j) x];
	}
	
}