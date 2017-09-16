as yet unclassified
testMaterializeObjects
	| mat |

	self objectsForTestingMaterialization keysAndValuesDo:[:k :v|	
		mat := self materializer materialize:v.
		self assert: mat  equals: k ]  