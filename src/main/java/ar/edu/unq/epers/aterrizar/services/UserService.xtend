package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.persistence.UserRepo
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail
import ar.edu.unq.epers.aterrizar.exceptions.UserAlreadyExistsException
import ar.edu.unq.epers.aterrizar.exceptions.UserNewPasswordSameAsOldPasswordException
import ar.edu.unq.epers.aterrizar.exceptions.UserDoesNotExistsException

class UserService {

	UserRepo repository
	EnviadorDeMails mailSender

	new() {
		repository = new UserRepo()
	}

	def setEnviador(EnviadorDeMails enviador) {
		mailSender = enviador
	}

	/**
    * Registers a User in the system
    * */
	def registerUser(User user) {

		if (repository.getUser(user.username) != null) {
			throw new UserAlreadyExistsException
		} else {
			repository.registerUser(user)
			this.enviarMail(user.email, user.validationCode)
		}
	}

	/**
    * Deletes EVERYTHING
    * */
	def deleteAllUsersInDB() {
		repository.deleteAllUsersInDB()
	}

	/**
    * Changes the password for a given User.
    * */
	def changePassword(String username, String password) throws Exception{
		val user = checkForUser(username)
		if (user.password != password) {
			repository.changePassword(username, password)
		} else {
			throw new UserNewPasswordSameAsOldPasswordException
		}

	}

	/**
    * Validates an User's identity with a code
    * */
	def validateUser(String username, int code) throws Exception{

		val user = checkForUser(username)
		if (user.validationCode == code && !user.validated) {
			repository.validateUser(username)
			user.setValidated(true)
		}
		user.isValidated()
	}

	/**
    * logs a User into the system
    * */
	def login(String username, String pass) throws Exception{
		val user = checkForUser(username)
		user.password == pass

	}

	def enviarMail(String email, int code) {
		this.mailSender.enviarMail(new Mail("Su codigo es: " + code, "Codigo de validacion", email, "admin@pp.com"))
	}

	/**
     * Checks if a user exists in the DB, if it does, it returns it, if it doesn't it throws an UserDoesNotExistException
     */
	def checkForUser(String username) throws Exception{
		val user = repository.getUser(username)
		if (user == null) {
			throw new UserDoesNotExistsException()
		} else {
			user
		}
	}
}
