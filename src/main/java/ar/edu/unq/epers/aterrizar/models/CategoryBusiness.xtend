package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.SeatCategory

class CategoryBusiness implements SeatCategory {
	
	override priceFactor() {
		return 1
	}
	
}