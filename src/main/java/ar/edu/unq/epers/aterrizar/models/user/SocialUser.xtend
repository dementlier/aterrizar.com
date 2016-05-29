package ar.edu.unq.epers.aterrizar.models.user

import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.models.social.DestinationList

@Accessors
class SocialUser {
	String username
	DestinationList destinations
	
	def addDestination(Destination destination, Visibility visibility){
		this.destinations.saveDestination(destination, visibility)
	}
	
	def getDestinationsWithTopVisibility(Visibility visibility){
		this.destinations.getDestinations(visibility)
	}
	
}