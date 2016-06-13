package ar.edu.unq.epers.aterrizar.utils

import ar.edu.unq.epers.aterrizar.models.social.Visibility

class VisibilityTransformer {
	
	def static toString(Visibility vis){
		switch(vis){
			case(Visibility.PRIVATE): return "PRIVATE"
			case(Visibility.FRIENDS): return "FRIENDS"
			case(Visibility.PUBLIC): return "PUBLIC"
		}
	}
	
	def static toVisibility(String vis){
		switch(vis){
			case("PRIVATE"): return Visibility.PRIVATE
			case("FRIENDS"): return Visibility.FRIENDS
			case("PUBLIC"): return Visibility.PUBLIC
		}
	}
}