as yet unclassified
serializeTest

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|
		self assert: (self serializer serialize:k) equals:v] 