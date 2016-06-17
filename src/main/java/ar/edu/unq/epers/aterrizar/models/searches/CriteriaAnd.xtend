package ar.edu.unq.epers.aterrizar.models.searches

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class CriteriaAnd extends Criteria {
	
	List<Criteria> criterias
	
	new(){
		criterias = new ArrayList<Criteria>()
	}
		
	def getConnector() {
		return " AND "
	}

	override getHQL(){
		return "("+criterias.map[it.getHQL()].join(getConnector())+")"
	}
	
}