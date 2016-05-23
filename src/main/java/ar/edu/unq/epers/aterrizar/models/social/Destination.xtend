package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import ar.edu.unq.epers.aterrizar.models.user.SocialUser
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Destination {
	String name
	List<SocialUser> users
	List<Comment> comments
	List<SocialUser> likes
	List<SocialUser> dislikes
	
}
