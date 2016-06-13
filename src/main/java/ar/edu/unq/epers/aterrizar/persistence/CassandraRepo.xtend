package ar.edu.unq.epers.aterrizar.persistence
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import ar.edu.unq.epers.aterrizar.models.user.CachedUser
import com.datastax.driver.mapping.MappingManager
import com.datastax.driver.core.CodecRegistry
import com.datastax.driver.extras.codecs.enums.EnumNameCodec
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import ar.edu.unq.epers.aterrizar.models.user.SocialUser

class CassandraRepo {
	Cluster cluster
	Session session
	Mapper<CachedUser> mapper
	
	new(){
		connect()
		createSchema()	
	}
	
	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build();
		session = cluster.connect();
	}
	
	def createSchema() {
		
		CodecRegistry.DEFAULT_INSTANCE.register(new EnumNameCodec<Visibility>(typeof(Visibility)))
		
		session.execute("CREATE KEYSPACE IF NOT EXISTS cached_users WITH replication = {'class':'SimpleStrategy', 'replication_factor':3};")

		session.execute("CREATE TYPE IF NOT EXISTS cached_users.comment (" +
			"username text," + 
			"comment text," +
			"likes list <text>," +
			"dislikes list <text>," +
			"visibility text," +
			");"
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS cached_users.destination (" +
			"name text," + 
			"comments list <frozen <comment>>," +
			"likes list <text>," +
			"dislikes list <text>," +
			"visibility text," +
			");"
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS cached_users.social_user (" +
			"username text," + 
			"destinations list <frozen <destination>>);"
		)

		session.execute("CREATE TABLE IF NOT EXISTS cached_users.users (" + 
				"username text, " + 
				"visibility text, " +
				"user frozen<social_user>," + 
				"PRIMARY KEY (username, visibility));"
		)
		mapper = new MappingManager(session).mapper(CachedUser);
	}

	def save(CachedUser user){
		mapper.save(user)
	}
	
	def get(String username, Visibility visibility){
		mapper.get(username, visibility)
	}
	
	def deleteUser(SocialUser user){
		var query = String.format("DELETE FROM cached_users.users WHERE username = '?'", user.username)
		session.execute(query)
	}
	
	def drop_database(){
		session.execute("DROP KEYSPACE cached_users;")
	}
}