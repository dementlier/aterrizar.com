package ar.edu.unq.epers.aterrizar.persistence

import com.mongodb.MongoClient
import com.mongodb.DB
import org.mongojack.JacksonDBCollection
import java.net.UnknownHostException

class MongoDB {
	static MongoDB INSTANCE;
	MongoClient mongoClient;
	DB db;

	synchronized def static MongoDB  instance() {
		if (INSTANCE == null) {
			INSTANCE = new MongoDB();
		}
		return INSTANCE;
	}

	private new() {
		try {
			mongoClient = new MongoClient("localhost", 27017);
		} catch (UnknownHostException e) {
			throw new RuntimeException(e);
		}
		db = mongoClient.getDB("admin");
	}
	
	
	def <T> ProfileRepo<T> collection(Class<T> entityType){
		val dbCollection = db.getCollection(entityType.getSimpleName());
		new ProfileRepo<T>(JacksonDBCollection.wrap(dbCollection, entityType, String));
	}
	
}