package ar.edu.unq.epers.aterrizar.models;

import org.neo4j.graphdb.RelationshipType;

public enum MessageTransferType implements RelationshipType {
	SENT, RECEIVED
}