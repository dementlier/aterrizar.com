package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors
import java.sql.Date

@Accessors
class User {
    private String nombre
    private String apellido
    private String nombreDeUsuario
    private String eMail
    private Date fechaDeNacimiento
    private String password
    private boolean validated

    /**
    * Constructor, si se usa el tipo data se puede ahorrar
    * */
    new(String firstName, String lastName, String userName, String mail, Date birthDay, String pass, boolean validation){
        nombre              = firstName
        apellido            = lastName
        nombreDeUsuario     = userName
        eMail               = mail
        fechaDeNacimiento   = birthDay
        password            = pass
        validated			= validation
    }
    
    new(){
		validated			= false
    }
    
    /**
     * Returns the validation code
     */
    def int getValidationCode(){
    	return nombreDeUsuario.hashCode()
    }
	
}