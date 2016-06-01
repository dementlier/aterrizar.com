package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.exceptions.UserAlreadyExistsException
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail
import ar.edu.unq.epers.aterrizar.persistence.HibernateRepo
import ar.edu.unq.epers.aterrizar.models.user.Reservation
import ar.edu.unq.epers.aterrizar.models.searches.Search

class UserHibernateService {
    
    EnviadorDeMails mailSender;

    /**
     * 
     */
    def getUser(String username) {
        SessionManager.runInSession([
            new HibernateRepo(User).getBy("username", username) as User
        ])
    }
    
    /**
     * 
     */
    def setEnviador(EnviadorDeMails enviador) {
        mailSender = enviador
    }

    /**
     * 
     */
    def registerUser(User user) {
        SessionManager.runInSession([
            val repo = new HibernateRepo(User)
            if (repo.getBy("username", user.username) as User != null) {
                throw new UserAlreadyExistsException
            } else {
                repo.save(user)
                new FriendService().addUser(user) // Necesario para asegurar que exista el usuario en la base de datos para friendships
				new DestinationService().addUser(user)
                this.enviarMail(user.email, user.validationCode)
                void
            }
        ]);
    }

    /**
     * 
     */
    def enviarMail(String email, int code) {
        this.mailSender.enviarMail(new Mail("Su codigo es: " + code, "Codigo de validacion", email, "admin@pp.com"))
    }

    /**
     * Deletes EVERYTHING
     * */
    def deleteAllUsersInDB() {
        SessionManager.runInSession([
            new HibernateRepo(Reservation).deleteAllInDB("Reservation") 
            new HibernateRepo(Search).deleteAllInDB("Search")          	
            new HibernateRepo(User).deleteAllInDB("User")
        ])
    }
    
    def saveUser(User userToSave){
    	SessionManager.runInSession([
            new HibernateRepo(User).save(userToSave)
            void
        ])
    }

}
