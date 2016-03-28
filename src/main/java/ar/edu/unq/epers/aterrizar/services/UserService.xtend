package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.persistence.UserRepo
import ar.edu.unq.epers.aterrizar.models.User

class UserService {
	
	UserRepo repository
	EnviadorDeMails mailSender
	
	new(){
		repository = new UserRepo()
	}
	
	def setEnviador(EnviadorDeMails enviador){
		mailSender = enviador
	}

    /**
    * Registers a User in the system
    * */
    def registerUser(User user) throws Exception{
    	try{
			repository.registerUser(user)
			this.enviarMail(user.getEMail())
		} catch(Exception e) {
			throw new Exception(e.getMessage())
		}
    }

    /**
    * Gets the user with the specified userName
    * @param userName a valid userName
    * @returns a User
    * */
    def getUser(String userName) throws Exception{
        repository.getUser(userName)
    }
    
    /**
    * Deletes EVERYTHING
    * */
    def cleanDatabase() throws Exception{
        repository.cleanDatabase()
    }

    /**
    * Changes the password for a given User.
    * */
    def changePassword(String username, String pass){
		repository.changePassword(username, pass)
    }

    /**
    * Validates an User's identity with a code
    * */
    def validateUser(String username, String code) throws Exception{
		val user = repository.getUser(username)
		if(user.getValidationCode() == code){
			repository.validateUser(username)
		}
    }

    /**
    * logs a User into the system
    * */
    def login(String username, String pass){
		// Hay que penser una manera de que un login tenga sentido.
		// Podriamos poner un campo en la DB en el que le ponemos un boolean y cuando hace login el boolean se setea a true
		// y cuando hace logout el boolean se setea a false, y así siempre que tengamos que chequear si esta conectado lo vemos en la DB
		// Aunque me parece una implementacion horrible, es la única manera que se me ocurrió.
    }
    
    def enviarMail(String email){
    	// this.mailSender.enviarMail(new Mail(body, subject, email, from))
    	// Habra que testear con Mockito esto, al ser una interfaz...
    }
}
