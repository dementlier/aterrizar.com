package ar.edu.unq.epers.aterrizar.models.airlines

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.models.user.User

@Accessors
class Seat {
	private int price
	private User reserver
	private SeatCategory category
	private int id
	
	new(){}
	
	new(int cost, SeatCategory seatCategory){
		category = seatCategory
		price = cost + getPriceFactor()
		reserver = null
	}
	
	override int hashCode(){
		id
	}
	
	override boolean equals(Object o){
		this.id == (o as Seat).id
	}
	
	def boolean isReservable(){
		reserver == null
	}
	
	def getPriceFactor(){
		switch(category){
			case Business: return 1
			case Tourist: return 2
			case First: return 3
			default: 0
		}
	}
	
}