package ar.edu.unq.epers.aterrizar.models.user

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.models.airlines.Seat

@Accessors
class Reservation {
	private int price
	private List<Seat> seats
	private int id
	private String destination
	
	new(){
		
	}
	
	new(List<Seat> buttHolders){
		this.price = 0
		this.seats = buttHolders
		for(seat : seats){
			price += seat.price
		}
	}
	
	new(List<Seat> buttHolders, String destination){
		this(buttHolders);
		this.destination = destination
	}
}
