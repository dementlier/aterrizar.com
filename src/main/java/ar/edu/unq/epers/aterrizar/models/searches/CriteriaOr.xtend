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
		return "("+criterias.map[it.getHQL()].join(getConnector())+")"
	}
	
}