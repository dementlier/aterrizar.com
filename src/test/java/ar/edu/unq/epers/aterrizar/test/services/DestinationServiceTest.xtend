package ar.edu.unq.epers.aterrizar.test.services

import ar.edu.unq.epers.aterrizar.models.airlines.Seat
import ar.edu.unq.epers.aterrizar.models.airlines.SeatCategory
import ar.edu.unq.epers.aterrizar.models.airlines.Section
import ar.edu.unq.epers.aterrizar.models.social.Comment
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.user.User
import ar.edu.unq.epers.aterrizar.services.CachingService
import ar.edu.unq.epers.aterrizar.services.DestinationService
import ar.edu.unq.epers.aterrizar.services.SearcherService
import ar.edu.unq.epers.aterrizar.services.UserHibernateService
import java.sql.Date
import java.util.ArrayList
import org.junit.After
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.aterrizar.utils.UserTransformer.*
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.FriendService

class DestinationServiceTest {
	DestinationService service
	SocialUser user
	Destination publicDestination
	Destination friendDestination
	Destination privateDestination
	UserHibernateService uService
	User fullUser
	SearcherService searchService
	FriendService fService
	
	@Before
	def void setUp(){
		service = new DestinationService
		uService = new UserHibernateService
		searchService = new SearcherService
		searchService.deleteAll()
		uService.deleteAllUsersInDB()
		service.dropDB()
		fullUser = new User("Pepe", "Osvaldez", "pepe", "pp@pp.com", new Date(0), "1234", true)
		user = new SocialUser("pepe")
		uService.registerUser(fullUser)		
		publicDestination = new Destination("pompeya", Visibility.PUBLIC)
		friendDestination = new Destination("cancun", Visibility.FRIENDS)
		privateDestination = new Destination("mdq", Visibility.PRIVATE)
		var sectionPompeya = new Section(1, "Madrid", "pompeya", new Date(0), new Date(0), new ArrayList<Seat>)
		var seatPompeya = new Seat(1, SeatCategory.Business)
		var sectionCancun = new Section(1, "Orlando", "cancun", new Date(0), new Date(0), new ArrayList<Seat>)
		var seatCancun = new Seat(1, SeatCategory.Tourist)
		var sectionMDQ = new Section(1, "Tokyo", "mdq", new Date(0), new Date(0), new ArrayList<Seat>)
		var seatMDQ = new Seat(1, SeatCategory.First)
		sectionPompeya.addSeat(seatPompeya)
		sectionCancun.addSeat(seatCancun)
		sectionMDQ.addSeat(seatMDQ)
		searchService.reserveSeat(fullUser, sectionPompeya, seatPompeya)
		searchService.reserveSeat(fullUser, sectionCancun, seatCancun)
		searchService.reserveSeat(fullUser, sectionMDQ, seatMDQ)
		fService = new FriendService
	}
	
	@Test
	def void testAddFriendDestination(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		
		var result = service.getDestinationsFilter(user, visibility)
		assertEquals(1, result.size)
		assertEquals(friendDestination.name, result.get(0).name)
	}
	
	@Test
	def void testAddEveryDestination(){
		
		service.addDestination(user, publicDestination)
		service.addDestination(user, friendDestination)
		service.addDestination(user, privateDestination)
		
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.PUBLIC)
		visibility.add(Visibility.FRIENDS)
		visibility.add(Visibility.PRIVATE)
		
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(3, result.size)
		
	}
	
	@Test
	def void testAddEveryDestinationAndGetOnlyPublic(){
		
		service.addDestination(user, publicDestination)
		service.addDestination(user, friendDestination)
		service.addDestination(user, privateDestination)
		
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.PUBLIC)
		
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals("pompeya", result.head.name)
		
	}
	
	@Test
	def void testUpdateDestinationLikesAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.likes.size)
						
		service.like("pepe", user, friendDestination)
		
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.likes.size)			
	
	}
	
	@Test
	def void testUpdateDestinationLikesAfterAddingItAndGettingItUpdatedButWithoutMultipleLikesFromSameUser(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.likes.size)
						
		service.like("pepe", user, friendDestination)
		service.like("pepe", user, friendDestination)
		service.like("pepe", user, friendDestination)
				
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.likes.size)			
	
	}	

	@Test
	def void testLikeDestinationAndThenDislikeAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.likes.size)
						
		service.like("pepe", user, friendDestination)
				
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.likes.size)
		assertEquals(0, result2.head.dislikes.size)			
		
		service.dislike("pepe", user, friendDestination)		
		var result3 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result3.size)
		assertEquals(0, result3.head.likes.size)	
		assertEquals(1, result3.head.dislikes.size)		
	}	
	
	@Test
	def void testUpdateDestinationDislikesAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.dislikes.size)
						
		service.dislike("pepa", user, friendDestination)
		
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.dislikes.size)			
	}
	
	@Test
	def void testUpdateDestinationDislikesAfterAddingItAndGettingItUpdatedButWithoutMultipleDislikesFromSameUser(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.dislikes.size)
						
		service.dislike("pepa", user, friendDestination)
		service.dislike("pepa", user, friendDestination)		
		service.dislike("pepa", user, friendDestination)
				
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.dislikes.size)			
	}
	
	@Test
	def void testDislikeDestinationAndThenLikeAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.likes.size)
						
		service.dislike("pepe", user, friendDestination)
				
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(0, result2.head.likes.size)
		assertEquals(1, result2.head.dislikes.size)			
		
		service.like("pepe", user, friendDestination)		
		var result3 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result3.size)
		assertEquals(1, result3.head.likes.size)	
		assertEquals(0, result3.head.dislikes.size)		
	}				
	
	@Test
	def void testAddCommentToDestinationAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
		var result = service.getDestinationsFilter(user, visibility)
		
		assertEquals(1, result.size)
		assertEquals(0, result.head.comments.size)

		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)			
	}
	
	@Test
	def void testLikeCommentAddedToDestinationAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.likes.size)	
		
		service.like("pepe", user, friendDestination, comment)	
		
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(1, result2.head.comments.head.likes.size)			
	}	

	@Test
	def void testLikeCommentAddedToDestinationAfterAddingItAndGettingItUpdatedWithoutRepeatedLikes(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.likes.size)	
		
		service.like("pepe", user, friendDestination, comment)	
		service.like("pepe", user, friendDestination, comment)	
		service.like("pepe", user, friendDestination, comment)	
						
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(1, result2.head.comments.head.likes.size)			
	}
	
	@Test
	def void testLikeAndThenDislikeCommentAddedToDestinationAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.likes.size)	
		
		service.like("pepe", user, friendDestination, comment)	
						
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(1, result2.head.comments.head.likes.size)
		assertEquals(0, result2.head.comments.head.dislikes.size)
		
		service.dislike("pepe", user, friendDestination, comment)

		var result3 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result3.size)
		assertEquals(1, result3.head.comments.size)	
		assertEquals(0, result3.head.comments.head.likes.size)
		assertEquals(1, result3.head.comments.head.dislikes.size)							
	}			

	@Test
	def void testDislikeCommentAddedToDestinationAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.dislikes.size)	
		
		service.dislike("pepa", user, friendDestination, comment)	
		
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(1, result2.head.comments.head.dislikes.size)			
	}

	@Test
	def void testDislikeCommentAddedToDestinationAfterAddingItAndGettingItUpdatedWithoutRepeatedDislikes(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.dislikes.size)	
		
		service.dislike("pepa", user, friendDestination, comment)	
		service.dislike("pepa", user, friendDestination, comment)
		service.dislike("pepa", user, friendDestination, comment)
						
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(1, result2.head.comments.head.dislikes.size)			
	}
	
	@Test
	def void testDislikeAndThenLikeCommentAddedToDestinationAfterAddingItAndGettingItUpdated(){
		service.addDestination(user, friendDestination)
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)			
	
		var comment = new Comment(user.username, "Este es un comentario")
		service.addComment(user, friendDestination, comment)
		
		var result = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result.size)
		assertEquals(1, result.head.comments.size)	
		assertEquals(0, result.head.comments.head.likes.size)	
		
		service.dislike("pepe", user, friendDestination, comment)	
						
		var result2 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result2.size)
		assertEquals(1, result2.head.comments.size)	
		assertEquals(0, result2.head.comments.head.likes.size)
		assertEquals(1, result2.head.comments.head.dislikes.size)
		
		service.like("pepe", user, friendDestination, comment)

		var result3 = service.getDestinationsFilter(user, visibility)		
		assertEquals(1, result3.size)
		assertEquals(1, result3.head.comments.size)	
		assertEquals(1, result3.head.comments.head.likes.size)
		assertEquals(0, result3.head.comments.head.dislikes.size)							
	}
	
	@Test
	def void testACachedUserGetsQueriedFromTheCache(){
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		service.getProfile(user, visibility, "FRIENDS")
		var result = service.getProfile(user, visibility, "FRIENDS")
		assertEquals(true, result.cached)
	}
	
	@Test
	def void testANonCachedUserGetsQueriedFromTheRepo(){
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		var result = service.getProfile(user, visibility, "FRIENDS")
		assertEquals(false, result.cached)
	}
	
	@Test
	def void testACachedUserGetsInvalidatedWhenItsSaved(){
		var visibility = new ArrayList<Visibility>()
		visibility.add(Visibility.FRIENDS)
		service.getProfile(user, visibility, "FRIENDS")
		service.updateUser(user)
		var result = service.getProfile(user, visibility, "FRIENDS")
		assertEquals(false, result.cached)
	}
	
	@Test
	def void testAUserGetsTheApropiateProfileForAnotherUserThatIsAFriend(){
		var fullFriend = new User("Pepa", "Ramirez", "pepita", "pp@pp.com", new Date(0), "1234", true)
		var friend = toSocialUser(fullFriend)
		fService.addUser(fullFriend)
		fService.befriend(fullUser, fullFriend)
		var list = new ArrayList<Visibility>
		list.add(Visibility.FRIENDS)
		list.add(Visibility.PUBLIC)
		var profileAMano = service.getProfile(user, list, Visibility.FRIENDS.toString)
		var profileAutomatizado = service.getVisibleProfile(user, friend)
		assertEquals(profileAMano.username, profileAutomatizado.username)
		assertEquals(profileAMano.destinations.size, profileAutomatizado.destinations.size)
		for(var i = 0; i< profileAMano.destinations.size; i++){
			assertEquals(profileAMano.destinations.get(i).name, profileAutomatizado.destinations.get(i).name)
		}
	}
	
	@Test
	def void testAUserGetsTheApropiateProfileForAnotherUserThatIsNotAFriend(){
		var fullNotFriend = new User("Pepo", "Ramirez", "pepito", "pp@pp.com", new Date(0), "1234", true)
		var notFriend = toSocialUser(fullNotFriend)
		fService.addUser(fullNotFriend)
		var list = new ArrayList<Visibility>
		list.add(Visibility.PUBLIC)
		var profileAMano = service.getProfile(user, list, Visibility.PUBLIC.toString)
		var profileAutomatizado = service.getVisibleProfile(user, notFriend)
		assertEquals(profileAMano.username, profileAutomatizado.username)
		assertEquals(profileAMano.destinations.size, profileAutomatizado.destinations.size)
		for(var i = 0; i< profileAMano.destinations.size; i++){
			assertEquals(profileAMano.destinations.get(i).name, profileAutomatizado.destinations.get(i).name)
		}
	}
	
	@Test
	def void testAUserGetsTheApropiateProfileForAnotherUserThatIsHimself(){
		var list = new ArrayList<Visibility>
		list.add(Visibility.PRIVATE)
		list.add(Visibility.FRIENDS)
		list.add(Visibility.PUBLIC)
		var profileAMano = service.getProfile(user, list, Visibility.PRIVATE.toString)
		var profileAutomatizado = service.getVisibleProfile(user, user)
		assertEquals(profileAMano.username, profileAutomatizado.username)
		assertEquals(profileAMano.destinations.size, profileAutomatizado.destinations.size)	
		for(var i = 0; i< profileAMano.destinations.size; i++){
			assertEquals(profileAMano.destinations.get(i).name, profileAutomatizado.destinations.get(i).name)
		}
	}
			
	@After
	def void tearDown(){
		new CachingService().deleteAllUsers
	}
	
}