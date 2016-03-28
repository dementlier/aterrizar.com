package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import java.sql.Connection
import java.sql.DriverManager
import org.eclipse.xtext.xbase.lib.Functions.Function1

class UserRepo {

    /**
     * Checks if the username is in the database
     * */
    private def boolean checkForUser(String userName){
        execute[conn|
            val ps = conn.prepareStatement("SELECT * FROM usuarios WHERE username=?;")
            ps.setString(1, userName)
            val rs = ps.executeQuery()

            rs.next()
        ]
    }

    def boolean checkLogin(String userName, String passWord){
        execute[conn|
            val ps = conn.prepareStatement("SELECT * FROM usuarios WHERE username=? AND password=?;")
            ps.setString(1, userName)
            ps.setString(2, passWord)
            val rs = ps.executeQuery()

            rs.next()
        ]
    }

    /**
     * Registers user into the database if the user doesn't exist
     * */
    def registerUser(User user) throws Exception{

        if(!this.checkForUser(user.getNombreDeUsuario())) {
            val nombre = user.getNombre()
            val apellido = user.getApellido()
            val nombreDeUsuario = user.getNombreDeUsuario()
            val eMail = user.getEMail()
            val fechaDeNacimiento = user.getFechaDeNacimiento()
            val password = user.getPassword()
            val validated = user.isValidated()

            execute[conn|
                val ps = conn.prepareStatement("INSERT INTO usuarios (name, surname, username, email, birth, password, validationstate) VALUES (?,?,?,?,?,?,?);")
                ps.setString(1, nombre)
                ps.setString(2, apellido)
                ps.setString(3, nombreDeUsuario)
                ps.setString(4, eMail)
                ps.setDate(5, fechaDeNacimiento)
                ps.setString(6, password)
                ps.setBoolean(7, validated)

                ps.execute()

            ]
        } else {
            throw new Exception("El usuario ya esta registrado.")
        }
    }

    /**
     * Retrieves the user from the database if the user exists
     * */
    def User getUser(String userName) throws Exception{
        if(this.checkForUser(userName)) {
            execute[conn|
                val ps = conn.prepareStatement("SELECT * FROM usuarios WHERE username=?;")
                ps.setString(1, userName)
                val rs = ps.executeQuery()
                rs.next()

                new User(rs.getString("name"), rs.getString("surname"), rs.getString("username"), rs.getString("email"), rs.getDate("birth"), rs.getString("password"), rs.getBoolean("validationstate"))
            ]
        } else {
            throw new Exception("No existe un usuario con ese nombre.")
        }
    }

    /**
     * Changes the user password in the database if the user exists
     * */
    def changePassword(String username, String passowrd) throws Exception{
        execute[conn|
            val ps = conn.prepareStatement("UPDATE usuarios SET password=? WHERE username=?;")
            ps.setString(1, passowrd)
            ps.setString(2, username)
            ps.execute()
        ]
    }

    /**
     * Validates a user in the database
     * */
    def validateUser(String userName){
        execute[conn|
            val ps = conn.prepareStatement("UPDATE usuarios SET validationstate=TRUE WHERE username=?;")
            ps.setString(1, userName)
            ps.execute()
        ]
    }

    def isValidated(String userName){
        execute[conn|
            val ps = conn.prepareStatement("SELECT validationstate FROM usuarios WHERE username=?;")
            ps.setString(1, userName)
            val rs = ps.executeQuery()
            rs.next()

            rs.getBoolean("validationstate")
        ]
    }

    def <T> T execute(Function1<Connection, Object> closure){
        var Connection conn = null
        try{
            conn = this.connection
            closure.apply(conn) as T
        }finally{
            if(conn != null)
                conn.close();
        }
    }

    def getConnection() {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/epers_aterrizar?user=root&password=root")
    }

    def cleanDatabase(){
        execute[conn|
            val ps = conn.prepareStatement("DELETE FROM usuarios;")
            ps.execute()
        ]
    }

}