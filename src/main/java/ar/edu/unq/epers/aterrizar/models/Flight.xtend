package ar.edu.unq.epers.aterrizar.models

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Flight {
	private List<Section> sections
	
	new(){}
	
	new(List<Section> someSections){
		this.sections = someSections
	}
	
	def search(Criteria criteria){
		//TODO...
	}
	
}