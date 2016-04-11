package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.models.User
import java.sql.Connection
import java.sql.DriverManager
import org.eclipse.xtext.xbase.lib.Functions.Function1

class UserJDBCRepo {

	/**
     * Registers user into the database
     * */
	def registerUser(User user) throws Exception{

		val nombre = user.firstname
		val apellido = user.lastname
		val nombreDeUsuario = user.username
		val eMail = user.email
		val fechaDeNacimiento = user.birthdate
		val password = user.password
		val validated = user.validated

		execute[ conn |
			val ps = conn.prepareStatement(
				"INSERT INTO usuarios (name, surname, username, email, birth, password, validationstate) VALUES (?,?,?,?,?,?,?);")
			ps.setString(1, nombre)
			ps.setString(2, apellido)
			ps.setString(3, nombreDeUsuario)
			ps.setString(4, eMail)
			ps.setDate(5, fechaDeNacimiento)
			ps.setString(6, password)
			ps.setBoolean(7, validated)
			ps.execute()
		]
	}

	/**
     * Retrieves the user from the database if the user exists
     * */
	def User getUser(String username) throws Exception{
		execute[ conn |
			val ps = conn.prepareStatement("SELECT * FROM usuarios WHERE username=?;")
			ps.setString(1, username)
			val rs = ps.executeQuery()
			if (rs.next()) {
				new User(rs.getString("name"), rs.getString("surname"), rs.getString("username"),
					rs.getString("email"), rs.getDate("birth"), rs.getString("password"),
					rs.getBoolean("validationstate"))
			} else {
				null
			}
		]

	}

	/**
     * Changes the user password in the database
     * */
	def changePassword(String username, String passowrd) {
		execute[ conn |
			val ps = conn.prepareStatement("UPDATE usuarios SET password=? WHERE username=?;")
			ps.setString(1, passowrd)
			ps.setString(2, username)
			ps.execute()
		]
	}

	/**
     * Validates a user in the database
     * */
	def validateUser(String username) {
		execute[ conn |
			val ps = conn.prepareStatement("UPDATE usuarios SET validationstate=TRUE WHERE username=?;")
			ps.setString(1, username)
			ps.execute()
		]
	}

	def <T> T execute(Function1<Connection, Object> closure) {
		var Connection conn = null
		try {
			conn = this.connection
			closure.apply(conn) as T
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	def getConnection() {
		Class.forName("com.mysql.jdbc.Driver");
		return DriverManager.getConnection("jdbc:mysql://localhost:3306/epers_aterrizar?user=root&password=root")
	}

	def deleteAllUsersInDB() {
		execute[ conn |
			val ps = conn.prepareStatement("DELETE FROM usuarios;")
			ps.execute()
		]
	}

}
