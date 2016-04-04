package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Reservation {
	private int price
	private List<Seat> seats
	
	new(List<Seat> buttHolders){
		seats = buttHolders
	}
}
