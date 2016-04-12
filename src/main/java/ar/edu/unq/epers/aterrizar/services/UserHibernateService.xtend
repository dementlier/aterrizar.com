package ar.edu.unq.epers.aterrizar.services

import ar.edu.unq.epers.aterrizar.exceptions.UserAlreadyExistsException
import ar.edu.unq.epers.aterrizar.models.User
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.UserHibernateRepo
import ar.edu.unq.epers.aterrizar.utils.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.utils.Mail

class UserHibernateService {
    
    EnviadorDeMails mailSender;

    /**
     * 
     */
    def getUser(String username) {
        SessionManager.runInSession([
            new UserHibernateRepo().getBy("username", username) as User
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
            val repo = new UserHibernateRepo()
            if (repo.getBy("username", user.username) as User != null) {
                throw new UserAlreadyExistsException
            } else {
                repo.save(user)
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
            new UserHibernateRepo().deleteAllInDB("usuarios")
        ])
    }

}
