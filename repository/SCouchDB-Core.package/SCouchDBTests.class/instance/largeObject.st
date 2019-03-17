as yet unclassified
largeObject
   | lo |
	lo := Array new:1000.
	1 to:1000 do:[:i | lo at:i put: self objects ].
	^ lo