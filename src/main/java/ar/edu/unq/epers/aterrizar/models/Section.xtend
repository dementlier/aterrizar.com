package ar.edu.unq.epers.aterrizar.models

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

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
	
	// Mepa que ademas de User debería recibir el Seat que quiere reservar.
	def void reserveSeat(User user){
	// primero se tendría que crear la reserva como corresponde, por ahora es un placeHolder.
	user.addReservation(new Reservation())	
	}
	
	def void updateBasePrice(int price){
	// me parece innecesario, con el setter de precio ya alcanza, pero como esta en el UML lo pongo.
		this.price = price
	}
	
	def boolean isReservationPossible(List<Seat> seats){
	// for(seat : seats) isReservationPossible(seat) && bla bla, no hace falta recursion, declaramos una var antes.
	// hay que ver si lo que nos pasan son seat, o solo el ID del seat..., porque sino ni tengo
	// que checkear contra this.seats, el mismo seat me sabe decir si es reservable...
		return true
	}
	
	def List<Seat> reservableSeats(){
	// for(seat : this.seats) bla bla bla
	}
	
	def boolean isReservationPossible(Seat seat){
		return true
	}
}