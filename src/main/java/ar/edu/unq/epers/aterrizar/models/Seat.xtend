package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Seat {
	private int price
	private User reserver
	private SeatCategory category
	private int id
	
	new(){}
	
	new(int cost){
		price = cost
		reserver = null
	}
	
	def boolean isReservable(){
		reserver == null
	}
	
	def getPriceFactor(SeatCategory seatCategory){
		switch(seatCategory){
			case Business: return 1
			case Tourist: return 2
			case First: return 3
		}
	}
}