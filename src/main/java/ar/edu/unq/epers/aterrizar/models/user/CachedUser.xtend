package ar.edu.unq.epers.aterrizar.models.user

import java.util.List
import ar.edu.unq.epers.aterrizar.models.social.Destination
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.Frozen

@Accessors
@Table(keyspace = "cached_users", name = "users")
class CachedUser {
	@PartitionKey()
	String username
	@PartitionKey(1)
	Visibility visibility
	@Frozen
	SocialUser user
	
	new(){
		
	}
	
	new(SocialUser user, Visibility visibility){
		username = user.username
		this.user = user
		this.visibility = visibility
	}
}