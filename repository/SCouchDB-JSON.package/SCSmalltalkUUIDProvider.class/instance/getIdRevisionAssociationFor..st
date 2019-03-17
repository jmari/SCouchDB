as yet unclassified
getIdRevisionAssociationFor: anObject
	| id rev |
	id := self getUUIDFor: anObject .
	rev := nil.
	^ ( id -> rev)
	