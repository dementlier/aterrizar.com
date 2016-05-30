package ar.edu.unq.epers.aterrizar.models.social

import java.util.List
import ar.edu.unq.epers.aterrizar.models.social.Visibility
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class DestinationList {
	List<String> destinations
	Visibility visibility

	new(Visibility vis){
		this.visibility = vis
	}
	
}