package ar.edu.unq.epers.aterrizar.user
import java.util.Date


class UserService {

    /**
    * Registers a User in the system
    * */
    def registrarUsuario(String nombre,
                        String apellido,
                        String nombreDeUsuario,
                        String eMail,
                        Date fechaDeNacimiento,
                        String pass){

        new User(nombre,
                    apellido,
                    nombreDeUsuario,
                    eMail,
                    fechaDeNacimiento,
                    pass)
    }

    /**
    * Changes the password for a given User.
    * */
    def cambiarContraseña(User u, String pass){

    }

    /**
    * Validates an User's identity with a codigo
    * */
    def validarUsuario(User u, String codigo){

    }

    /**
    * logs a User into the system
    * */
    def login(String nombreDeUsuario, String pass){

    }
}