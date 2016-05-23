package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.services.FriendService

class DestinationList {
	String username
	List<String> publicList
	List<String> privateList
	List<String> friendsList

	
	def getDestinations(Visibility visibility){
		val res = new ArrayList<String>()
		switch (visibility){
			case PUBLIC:
				return publicList
		
			case FRIENDS:{
				res.addAll(friendsList)
				res.addAll(publicList)
				return res
			}
			case PRIVATE:{
				res.addAll(friendsList)
				res.addAll(publicList)
				res.addAll(privateList)
				return res
			}
			default:
				return res
		}

	}
	
	def saveDestination(Destination destination, Visibility visibility){
		switch (visibility){
			case PUBLIC:
				publicList.add(destination.name)
		
			case FRIENDS:{
				friendsList.add(destination.name)
			}
			
			case PRIVATE:{
				privateList.add(destination.name)
			}
		}
	}
	
}