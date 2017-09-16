as yet unclassified
largeObject
   | lo |
	lo := Array new:500.
	1 to:500 do:[:i | lo at:i put: self objects ].
	^ lo