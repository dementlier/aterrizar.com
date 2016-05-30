package ar.edu.unq.epers.aterrizar.models.user

import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.social.Destination
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.models.social.DestinationList
import java.util.ArrayList

@Accessors
class SocialUser {
	String username
	DestinationList publicList
	DestinationList friendsList
	DestinationList privateList

	new(){
		this.publicList = new DestinationList(Visibility.PUBLIC)
		this.friendsList = new DestinationList(Visibility.FRIENDS)
		this.privateList = new DestinationList(Visibility.PRIVATE)
	}
	
	new(String username){
		this.username = username
		this.publicList = new DestinationList(Visibility.PUBLIC)
		this.friendsList = new DestinationList(Visibility.FRIENDS)
		this.privateList = new DestinationList(Visibility.PRIVATE)
	}

	def addDestination(Destination destination, Visibility visibility){
		switch (visibility){
			case PUBLIC:
				publicList.destinations.add(destination.name)
		
			case FRIENDS:{
				friendsList.destinations.add(destination.name)
			}
			
			case PRIVATE:{
				privateList.destinations.add(destination.name)
			}
		}
	}

	def getDestinations(Visibility visibility){
		val res = new ArrayList<String>()
		switch (visibility){
			case PUBLIC:
				return publicList.destinations
		
			case FRIENDS:{
				res.addAll(friendsList.destinations)
				res.addAll(publicList.destinations)
				return res
			}
			case PRIVATE:{
				res.addAll(friendsList.destinations)
				res.addAll(publicList.destinations)
				res.addAll(privateList.destinations)
				return res
			}
			default: {}
		}
		return res
	}
	
	
}