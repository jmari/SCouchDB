as yet unclassified
instance
	^ couchCache ifNil:[ 
			couchCache := self basicNew.
			couchCache initialize]