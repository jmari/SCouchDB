as yet unclassified
testSerializeObjectsPlain
	| ser |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	

		ser :=	 self serializer 
							serializeAllCollectionsAsArrays;
			 				serialize:k.
	
		self assert: ser  equals: v ]