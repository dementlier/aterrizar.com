package ar.edu.unq.epers.aterrizar.user

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date


@Accessors
class User {
    private String nombre
    private String apellido
    private String nombreDeUsuario
    private String eMail
    private Date fechaDeNacimiento
    private String password

    /**
    * Constructor
    * */
    new(String firstName, String lastName, String userName, String mail, Date birthDay, String pass){
        nombre              = firstName
        apellido            = lastName
        nombreDeUsuario     = userName
        eMail               = mail
        fechaDeNacimiento   = birthDay
        password            = pass
    }
}