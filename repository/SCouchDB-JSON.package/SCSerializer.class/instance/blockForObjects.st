private
blockForObjects

^[ :obj :stream| 
	| instanceVariables |
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		instanceVariables := (obj respondsTo: #scInstanceVarsToSerialize)
										ifTrue:[obj scInstanceVarsToSerialize]
										ifFalse:[obj class allInstVarNames].

		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[instanceVariables ifNotEmpty:[stream nextPut:$,]].
		instanceVariables do:[:varName|
			stream 
				nextPut:$";
				nextPutAll: varName asString;
				nextPut:$";
				nextPut:$:.
				self serialize: ( obj instVarNamed:varName ) to: stream.
			stream 	nextPut:$,
			 ].
		instanceVariables ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}]
	ifTrue:[
		stream nextPut:${.		
		self writeIdRevInstanceOf: obj on:stream.
		stream nextPut:$}]]