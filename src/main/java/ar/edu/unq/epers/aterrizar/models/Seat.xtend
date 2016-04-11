package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Seat {
	private int price
	private User reserver
	private SeatCategory category
	
	new(int cost){
		price = cost
		reserver = null
	}
	
	def boolean isReservable(){
		reserver == null
	}
	
}