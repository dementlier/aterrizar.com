package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.CriteriaComposed

class CriteriaOr extends CriteriaComposed {
	
	override getConnector() {
		return " OR "
	}
	
}