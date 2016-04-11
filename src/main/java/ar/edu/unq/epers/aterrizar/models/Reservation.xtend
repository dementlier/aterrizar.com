package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Reservation {
	private int price
	private List<Seat> seats
	
	new(){
		
	}
	
	new(int price, List<Seat> buttHolders){
		this.price = price
		this.seats = buttHolders
	}
}
