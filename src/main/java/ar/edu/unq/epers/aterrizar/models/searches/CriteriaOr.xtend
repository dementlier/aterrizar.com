package ar.edu.unq.epers.aterrizar.models.searches

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class CriteriaOr extends Criteria {
	
	List<Criteria> criterias
	
	new(){
		criterias = new ArrayList<Criteria>()
	}
		
	def getConnector() {
		return " OR "
	}

	override getHQL(){
		var res = "("
		var i = 0
		for(;i<criterias.size()-1 ; i++){
			res = res + criterias.get(i).getHQL() + this.getConnector()
		}
		res = res + criterias.get(i).getHQL() + ")"
		return res
	}
	
}