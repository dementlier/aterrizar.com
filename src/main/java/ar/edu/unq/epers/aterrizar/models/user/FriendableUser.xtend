package ar.edu.unq.epers.aterrizar.models.user

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class FriendableUser {
	String firstname
	String lastname
	String username

	override hashCode() {
		username.hashCode()
	}

	override equals(Object o) {
		var userToCompare = o as FriendableUser
		this.username == userToCompare.username
	}
}
