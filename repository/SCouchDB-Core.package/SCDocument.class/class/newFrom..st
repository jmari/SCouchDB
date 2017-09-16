as yet unclassified
newFrom: anObject
	| scObj uuid rev|
	scObj := super newFrom:anObject.
	uuid := SCObjectsCache instance keyAtValue: anObject. 
	rev := SCObjectsCache instance revisionAt: uuid.
	uuid ifNotNil:[ scObj id: uuid].
	rev ifNotNil:[ scObj rev: rev].
	^ scObj