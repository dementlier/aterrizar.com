package ar.edu.unq.epers.aterrizar.models.relationships;

import org.neo4j.graphdb.RelationshipType;

public enum MessageTransferType implements RelationshipType {
	SENT, RECEIVED
}