as yet unclassified
getIdRevisionAssociationFor: anObject
	| id rev |

	id := self getUUIDFor: anObject.
	rev := self getRevFor: id.
	^ ( id -> rev)
	