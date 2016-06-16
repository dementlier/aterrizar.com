package ar.edu.unq.epers.aterrizar.models.user

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.models.airlines.Seat
import java.util.ArrayList

@Accessors
class Reservation {
	private int price
	private List<Seat> seats
	private int id
	String dest
	String orig
	
	new(){
		seats = new ArrayList<Seat>
		price = 0
	}
	
	new(List<Seat> buttHolders, String orig, String dest){
		this.price = 0
		this.seats = buttHolders
		for(seat : seats){
			price += seat.price
		}
		this.orig = orig
		this.dest = dest
	}
}
