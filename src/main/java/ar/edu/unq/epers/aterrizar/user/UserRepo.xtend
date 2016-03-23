package ar.edu.unq.epers.aterrizar.user
 

class UserRepo {
	/**
	 * Checks if the username is in the database
	 * */
	 private def boolean checkForUser(String username){
	 	return false
	 }
	 
	 /**
	  * Registers user into the database
	  * */
	 def registerUser(User user){
	 	
	 }
	 
	 /**
	  * Retrieves the user from the database
	  * */
	 def User getUser(String username){
	  	return new User()
	 }
	 
	 /**
	  * Changes the user password in the database
	  * */
	 def changePassword(String username, String password){
	 	
	 } 
	 
}