package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Reservation {
	private int price
	private List<Seat> seats
	private int id
	
	new(){
		
	}
	
	new(List<Seat> buttHolders){
		this.price = 0
		this.seats = buttHolders
		for(seat : seats){
			price += seat.price
		}
	}
}
