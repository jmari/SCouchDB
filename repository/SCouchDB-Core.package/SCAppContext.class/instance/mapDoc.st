views
mapDoc
	| arr|
	^ buf 
		ifNil:[Stack new]
		ifNotNil: [ 	
					arr := buf.
					buf := Stack new.
					arr ]


	
