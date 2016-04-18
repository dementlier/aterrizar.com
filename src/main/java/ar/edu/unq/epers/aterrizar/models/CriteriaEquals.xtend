package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriteriaEquals extends Criteria {
	
	String field
	String value
	
	override getHQL() {
		return field + "='" + value + "' "	
	}
	
}