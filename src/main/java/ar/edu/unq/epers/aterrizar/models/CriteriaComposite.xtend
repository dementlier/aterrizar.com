package ar.edu.unq.epers.aterrizar.models

import ar.edu.unq.epers.aterrizar.models.Criteria
import java.util.List
import java.util.ArrayList

class CriteriaComposite extends Criteria {
	
	List<Criteria> criterias
	
	new(){
		
	}
	
	def addCriteria(Criteria criteria){
		criterias.add(criteria)
	}
	
	override search(Airline airline){
		var list = new ArrayList<Flight>()
		if(!criterias.isEmpty()){
			list.addAll(criterias.get(0).search(airline))
			for(criteria : criterias){
				list.retainAll(criteria.search(airline))
			}
			list
		} else {
			list
		}
	}
}