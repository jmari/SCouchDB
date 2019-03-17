as yet unclassified
removeAll
	mutex critical: [
		[self cache removeAll]  on:Error do:["nothing"]]


