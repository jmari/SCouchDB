tests
testRootSerialization
	| ser mat k |

		k := self objectsToTestRootSerialization .
		ser :=	 self serializer serialize: k.
		ser inspect.
		mat := self materializer materialize:ser.
		self assert: mat size equals:3.
		self assert: (mat at:3)  equals: k.
