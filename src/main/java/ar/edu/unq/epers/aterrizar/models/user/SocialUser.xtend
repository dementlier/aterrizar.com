package ar.edu.unq.epers.aterrizar.models.user

import java.util.List
import java.util.HashMap
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.social.Destination

class SocialUser {
	String username
	DestinationList destinations
	
	def addDestination(Destination destination, Visibility visibility){
		this.destinations.saveDestination(destination, visibility)
	}
}