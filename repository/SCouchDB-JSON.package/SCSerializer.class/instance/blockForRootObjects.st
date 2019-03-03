private
blockForRootObjects

^[ :obj :rootStream| 
	| instanceVariables nextObject stream|
	stream:= WriteStream on:String new.
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		
		instanceVariables := (obj respondsTo: #scInstanceVarsToSerialize)
										ifTrue:[obj scInstanceVarsToSerialize]
										ifFalse:[obj class allInstVarNames].
		stream nextPut:${.	
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[instanceVariables ifNotEmpty:[stream nextPut:$,]].
		instanceVariables do:[:varName|
			stream 
				nextPut:$";
				nextPutAll: varName asString;
				nextPut:$";
				nextPut:$:.
				nextObject := obj instVarNamed:varName.
				"serialize other root objects in a new Stream, we will join them later
				 once the object is serialized, we will only include its reference"
				nextObject class isVoyageRoot ifTrue:[
					self serialize: nextObject to: rootStream.
					rootStream nextPut:$,].
				self serialize: nextObject to: stream.
			stream 	nextPut:$,
			 ].
		instanceVariables ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}]
	ifTrue:[
		stream nextPut:${.		
		self writeIdRevInstanceOf: obj on:stream.
		stream nextPut:$}].
	rootStream nextPutAll: stream contents.
	]