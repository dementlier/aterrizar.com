package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.CriteriaComposed

class CriteriaAnd extends CriteriaComposed {
	
	override getConnector() {
		return " AND "
	}
	
}