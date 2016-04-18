package ar.edu.unq.epers.aterrizar.models

import org.eclipse.xtend.lib.annotations.Accessors


@Accessors
abstract class Criteria {
	private int id
	
	def abstract String getHQL()
}