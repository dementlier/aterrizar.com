package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.persistence.UserRepo
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail

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
        repository.registerUser(user)
        this.enviarMail(user.getEMail(), user.getValidationCode())
    }

    /**
    * Gets the user with the specified userName
    * The user must be registered
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
    def changePassword(String username, String password){
        val user = repository.getUser(username)
        if(user.getPassword != password) {
            repository.changePassword(username, password)
        } else {
            throw new Exception("La nueva contraseña no puede ser igual a la anterior.")
        }

    }

    /**
    * Validates an User's identity with a code
    * */
    def validateUser(String username, int code) throws Exception{

        val user = repository.getUser(username)
        if(user.getValidationCode() == code && !user.isValidated()) {
            repository.validateUser(username)
        }

        repository.isValidated(username)
    }

    /**
    * logs a User into the system
    * */
    def login(String username, String pass){
        repository.checkLogin(username, pass)
    }

    def enviarMail(String email, int code){
        this.mailSender.enviarMail(new Mail("Su codigo es: " + code, "Codigo de validacion", email, "admin@pp.com"))
    }
}
