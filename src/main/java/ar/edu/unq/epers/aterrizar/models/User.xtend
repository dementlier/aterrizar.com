package ar.edu.unq.epers.aterrizar.models

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class User {
	private String firstname
	private String lastname
	private String username
	private String email
	private Date birthdate
	private String password
	private boolean validated
	private List<Reservation> reservations

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
	}

	new() {
		validated = false
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

}
