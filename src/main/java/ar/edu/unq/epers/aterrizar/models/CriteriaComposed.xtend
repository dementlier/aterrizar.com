package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class CriteriaComposed extends Criteria {
	
	List<Criteria> criterias
	
	override getHQL(){
		var res = "("
		var i = 0
		for(;i<criterias.size()-1 ; i++){
			res + criterias.get(i).getHQL() + this.getConnector()
		}
		res + criterias.get(i).getHQL() + ")"
		return res
	}
	
	def abstract String getConnector()
}