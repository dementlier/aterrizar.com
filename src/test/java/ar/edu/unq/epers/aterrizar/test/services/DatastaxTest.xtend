package ar.edu.unq.epers.aterrizar.test.services

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import org.junit.Before
import org.junit.Test
import org.junit.After
import static org.junit.Assert.*
import com.datastax.driver.mapping.MappingManager
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.FrozenValue
import java.util.List

@Accessors
@EqualsHashCode
@UDT(keyspace = "simplex", name = "cancion")
class Cancion {
	String titulo
	String artista
	String albun
}


@Accessors
@Table(keyspace = "simplex", name = "busquedaPorDia")
class BusquedaPorDia {
	@PartitionKey()
    String username
    @PartitionKey(1)
	String dia
	@FrozenValue
	List<Cancion> canciones
}

class DatastaxTest {
	Cluster cluster
	Session session
	Mapper<BusquedaPorDia> mapper
	BusquedaPorDia busqueda1
	BusquedaPorDia busqueda2
	Cancion cancion1
	Cancion cancion2
	Cancion cancion3
	Cancion cancion4
	Cancion cancion5

	@Before
	def void setup() {
		connect
		createSchema
		crearBusqueda
	}

	def createSchema() {
		session.execute("CREATE KEYSPACE IF NOT EXISTS  simplex WITH replication = {'class':'SimpleStrategy', 'replication_factor':3};")

		session.execute("CREATE TYPE IF NOT EXISTS simplex.cancion (" +
			"titulo text," + 
			"artista text," +
			"albun text);"
		)

		session.execute("CREATE TABLE IF NOT EXISTS simplex.BusquedaPorDia (" + 
				"username text, " + 
				"dia text, " +
				"canciones list< frozen<cancion>>," + 
				"PRIMARY KEY (username, dia));"
		)
		mapper = new MappingManager(session).mapper(BusquedaPorDia);
	}

	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build();
		session = cluster.connect();
	}

	def crearBusqueda() {
		cancion1 = new Cancion => [
			titulo = "cancion1"
			artista = "artista1"
			albun = "albun1"
		]

		cancion2 = new Cancion => [
			titulo = "cancion1"
			artista = "artista2"
			albun = "albun1"
		]

		cancion3 = new Cancion => [
			titulo = "cancion2"
			artista = "artista2"
			albun = "albun1"
		]

		cancion4 = new Cancion => [
			titulo = "artista2"
			artista = "cancion1"
			albun = "album2"
		]

		cancion5 = new Cancion => [
			titulo = "artista2"
			artista = "cancion1"
			albun = "album3"
		]


		busqueda1 = new BusquedaPorDia => [
			username = "tintin"
			dia = "10/05/2015"
			canciones = #[cancion1, cancion2, cancion5]
		]
		
		busqueda2 = new BusquedaPorDia => [
			username = "tintin"
			dia = "12/05/2015"
			canciones = #[cancion3, cancion4]
		]
		mapper.save(busqueda1)
		mapper.save(busqueda2)
	}

	@Test
	def obtenerBusqueda() {
		val busqueda = mapper.get("tintin", "10/05/2015")
		assertEquals(busqueda.username, "tintin")
		assertEquals(busqueda.dia, "10/05/2015")
		assertTrue(busqueda.canciones.containsAll(#[cancion1, cancion2, cancion5]))
	}
	
	
	@Test
	def obtenerBusqueda2() {
		val busqueda = mapper.get("tintin", "12/05/2015")
		assertEquals(busqueda.username, "tintin")
		assertEquals(busqueda.dia, "12/05/2015")
		assertTrue(busqueda.canciones.containsAll(#[cancion3, cancion4]))
	}
	
		
	@Test
	def busquedaVacia() {
		val busqueda = mapper.get("tonton", "10/05/2015")
		assertNull(busqueda)
	}
	

	@After
	def eliminarTablas() {
		session.execute("DROP KEYSPACE IF EXISTS simplex");
		cluster.close();
	}
}