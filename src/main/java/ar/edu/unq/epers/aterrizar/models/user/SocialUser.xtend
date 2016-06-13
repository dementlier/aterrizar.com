package ar.edu.unq.epers.aterrizar.models.user

import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List
import org.mongojack.Id
import com.datastax.driver.mapping.annotations.UDT

@UDT(keyspace = "cached_users", name = "social_user")
@Accessors
class SocialUser {
	@Id
	String username
	List<Destination> destinations
	boolean cached;
	
	new(){
		destinations = new ArrayList<Destination>
		cached = false;
	}
	
	new(String username){
		this.username = username
		destinations = new ArrayList<Destination>
		cached = false
	}
	
	new(String username, List<Destination> destinations){
		this.username = username
		this.destinations = destinations
	}

	def addDestination(Destination destination){
		destinations.add(destination)
	}
	
	def updateDestination(Destination destination){
		for(dest : destinations){
			if(dest.name == destination.name){
				destinations.remove(dest)
				destinations.add(destination)
			}
		}
	}
}