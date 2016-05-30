package ar.edu.unq.epers.aterrizar.models.user

import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List

@Accessors
class SocialUser {
	String username
	List<Destination> destinations

	new(){
		destinations = new ArrayList<Destination>
	}
	
	new(String username){
		this.username = username
		destinations = new ArrayList<Destination>
	}

	def addDestination(Destination destination){
		destinations.add(destination)
	}
	
	
}