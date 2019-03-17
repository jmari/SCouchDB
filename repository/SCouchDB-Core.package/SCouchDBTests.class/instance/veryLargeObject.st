as yet unclassified
veryLargeObject
   | lo |
	lo := Array new:100000.
	1 to:100000 do:[:i | lo at:i put: self objects ].
	^ lo