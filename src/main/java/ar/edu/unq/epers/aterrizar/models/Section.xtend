package ar.edu.unq.epers.aterrizar.models

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Section {
	int price
	String origin
	String destination
	Date arrivalTime
	Date departureTime
	List<Seat> seats
	private int id
	
	new(){}
	//Se define a mano por que hemos tenido problemos con el Annotation Data en el pasado
	new(int price, String orig, String dest, Date arriv, Date deprtr, List<Seat> buttHolders){
		this.price 		 = price
		this.origin 	 = orig
		this.destination = dest
		this.arrivalTime = arriv
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
		for(seat : seats){
			res = res && seat.isReservable()
		}
		return res
	}
	
	def List<Seat> reservableSeats(){
		var reservableSeats = new ArrayList<Seat>()
		for(seat : this.seats){
			if(seat.isReservable()){
				reservableSeats.add(seat)
			}
		}
		reservableSeats
	}
	
	def hasSeatsOfCategory(SeatCategory category){
		var bool = true
		var index = 0
		while(index < seats.size() && bool){
			bool = bool && (seats.get(index).category == category)
		}
		bool
	}
	
}