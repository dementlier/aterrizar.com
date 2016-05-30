package ar.edu.unq.epers.aterrizar.models.user

import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty

@Accessors
class SocialUser {
	@JsonProperty("_id")
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