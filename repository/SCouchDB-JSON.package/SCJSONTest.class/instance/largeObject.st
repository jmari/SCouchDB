as yet unclassified
largeObject
   | lo |
	lo := Array new:5000.
	1 to:5000 do:[:i | lo at:i put: self objectsForTestingSerialization ].
	^ lo