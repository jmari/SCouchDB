tests
testSerializeLargeObjects
	| ser time mat|


		time := [ser :=	 self serializer serialize: self largeObject] timeToRun. 
		self assert: time < (Duration  milliSeconds: 5000). 
		Transcript show:time asString.
		time := [mat :=	 self materializer materialize: ser] timeToRun. 
		Transcript show:time asString.
		self assert: time < (Duration  milliSeconds: 5000) 