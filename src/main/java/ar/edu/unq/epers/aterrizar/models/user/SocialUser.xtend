package ar.edu.unq.epers.aterrizar.models.user

import java.util.List
import java.util.HashMap
import ar.edu.unq.epers.aterrizar.models.social.Visibility

class SocialUser {
	String username
	HashMap<Visibility, List<String>> destinations
}