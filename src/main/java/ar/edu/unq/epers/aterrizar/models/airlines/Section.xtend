package ar.edu.unq.epers.aterrizar.models.airlines

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.models.user.Reservation

@Accessors
class Section {
	int price
	String origin
	String destination
	Date arrivalTime
	Date departureTime
	List<Seat> seats
	private int id
	
	new(){
	}
	//Se define a mano por que hemos tenido problemos con el Annotation Data en el pasado
	new(int price, String orig, String dest, Date arriv, Date deprtr, List<Seat> buttHolders){
		this.price 		 = price
		this.origin 	 = orig
		this.destination = dest
		this.arrivalTime = arriv
		this.departureTime = deprtr
		this.seats 		 = buttHolders
	}
	
	def void reserveSeats(User user, List<Seat> seatsToBeReserved){
		if(isReservationPossible(seatsToBeReserved)){
			for(seat : seatsToBeReserved){
				seat.reserver = user
			}
			user.addReservation(new Reservation(seatsToBeReserved))		
		}
	}
	
	
	def boolean isReservationPossible(List<Seat> seats){
		var res = true
		if(this.seats.containsAll(seats)){
			for(seat : seats){
				res = res && seat.isReservable()
			}	
		} else {
			res = false
		}
		return res
	}
	
	def List<Seat> reservableSeats(){
		var seatsReservables = new ArrayList<Seat>()
		for(seat : this.seats){
			if(seat.isReservable()){
				seatsReservables.add(seat)
			}
		}
		seatsReservables
	}
	
	def hasSeatsOfCategory(SeatCategory category){
		var bool = true
		var index = 0
		while(index < seats.size() && bool){
			bool = bool && (seats.get(index).category == category)
		}
		bool
	}
	
	def addSeat(Seat seat){
		seats.add(seat)
	}
	
}