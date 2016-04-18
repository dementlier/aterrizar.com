package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriteriaAnd extends Criteria {
	
	List<Criteria> criterias
		
	def getConnector() {
		return " AND "
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