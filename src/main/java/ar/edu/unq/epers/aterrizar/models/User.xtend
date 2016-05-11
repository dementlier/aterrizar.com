package ar.edu.unq.epers.aterrizar.models

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class User {
	String firstname
	String lastname
	String username
	String email
	Date birthdate
	String password
	boolean validated
	List<Reservation> reservations
	int id
	List<Search> searches
	

	/**
    * Constructor, si se usa el tipo data se puede ahorrar
    * */
	new(String firstName, String lastName, String userName, String mail, Date birthDay, String pass, boolean validation) {
		firstname = firstName
		lastname = lastName
		username = userName
		email = mail
		birthdate = birthDay
		password = pass
		validated = validation
		reservations = new ArrayList<Reservation>()
		searches = new ArrayList<Search>()
	}

	/**Para Hibernate */
	new() {
		searches = new ArrayList<Search>()
		reservations = new ArrayList<Reservation>()		
	}
	

	/**
     * Returns the validation code
     */
	def int getValidationCode() {
		return username.hashCode()
	}
	
	def void addReservation(Reservation r){
		reservations.add(r)
	}
	
	def void addSearch(Search search){
		searches.add(search)
	}
	
	override hashCode(){
		username.hashCode()
	}
	
	override equals(Object o){
		var userToCompare = o as User
		this.username == userToCompare.username
	}
}
