as yet unclassified
largeObject
   | lo |
	lo := Array new:2000.
	1 to:2000 do:[:i | lo at:i put: self objectsForTestingSerialization ].
	^ lo