package ar.edu.unq.epers.aterrizar.test.services

import org.junit.Test
import org.junit.Before
import static org.junit.Assert.*
import ar.edu.unq.epers.aterrizar.services.DestinationService
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import java.util.ArrayList
import org.junit.After
import ar.edu.unq.epers.aterrizar.models.social.Comment
import ar.edu.unq.epers.aterrizar.services.CachingService

class DestinationServiceTest {
	DestinationService service
	SocialUser user
	Destination publicDestination
	Destination friendDestination
	Destination privateDestination
	
	@Before
	def void setUp(){
		service = new DestinationService
		service.dropDB()
		user = new SocialUser("pepe")
		publicDestination = new Destination("pompeya", Visibility.PUBLIC)
		friendDestination = new Destination("cancun", Visibility.FRIENDS)
		privateDestination = new Destination("mdq", Visibility.PRIVATE)
		service.saveUser(user)
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
		service.saveUser(user)
		var result = service.getProfile(user, visibility, "FRIENDS")
		assertEquals(false, result.cached)
	}
			
	@After
	def void tearDown(){
		new CachingService().deleteAllUsers
	}
	
}