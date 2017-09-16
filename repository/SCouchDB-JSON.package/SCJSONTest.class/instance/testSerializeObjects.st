as yet unclassified
testSerializeObjects
	| ser mat |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	
		ser :=	 self serializer serialize:k.
		mat := self materializer materialize:ser.
		
		self assert: mat  equals: k ].
