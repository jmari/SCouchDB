Class {
	#name : #SCComplexObjectsTest,
	#superclass : #TestCase,
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> largeObject [
   | lo |
	lo := Array new:5000.
	1 to:5000 do:[:i | lo at:i put: self objectsForTestingSerialization ].
	^ lo
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> materializer [
	^ SCMaterializer new
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> objectsForTestingMaterialization [
^ { 
	(OrderedCollection  new add:Stack new; add:Stack new;yourself) -> '{"#instanceOf":"OrderedCollection","#values":[{"#instanceOf":"Stack","#values":[]},{"#instanceOf":"Stack","#values":[]}]}'.
	(Array
				with: 'error'
				with: 'Runtime error'
				with: 'message') -> '["error","Runtime error","message"]'.
	#(#()) -> '[[]]'. 
		(Stack new push:(Array with:SCJsonObject  new);push:'popo';yourself) -> '{"#instanceOf":"Stack","#values":["popo",[{}]]}'.
		
		nil -> 'null'.
		1 -> '1'.
		1.1 -> '1.1'.
		'hola'->'"hola"'.
		#(1 2 'hola') -> '[1,2,"hola"]'.
		#(1 2 'hola') asOrderedCollection   -> '{"#instanceOf":"OrderedCollection","#values":[1,2,"hola"]}'.
		#(1 2 'hola') asSet   ->'{"#instanceOf":"Set","#values":[1,2,"hola"]}'.
		{ 'hola'->'hello'.
			'bien'->'good' } asDictionary -> '{"#instanceOf":"Dictionary","bien":"good","hola":"hello"}'.
		1@1 ->	'{"#instanceOf":"Point","x":1,"y":1}'.	
		(Time new seconds:52801 nanoSeconds:732987000)  ->'{"#instanceOf":"Time","seconds":52801,"nanos":732987000}'	
	} asDictionary 
		
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> objectsForTestingSerialization [
^ { 
	(OrderedCollection  new add:Stack new; add:Stack new;yourself) -> '[[],[]]'.
	(Array
				with: 'error'
				with: 'Runtime error'
				with: 'message') -> '["error","Runtime error","message"]'.
	#(#()) -> '[[]]'. 
		(Stack new push:(Array with:SCJsonObject  new);push:'popo';yourself) -> '["popo",[{}]]'.
		
		nil -> 'null'.
		1 -> '1'.
		1.1 -> '1.1'.
		1/2 -> '0.5'.
		'hola'->'"hola"'.
		#(1 2 'hola') -> '[1,2,"hola"]'.
		#(1 2 'hola') asOrderedCollection   -> '[1,2,"hola"]'.
		#(1 2 'hola') asSet   ->'[1,2,"hola"]'.
		{ 'hola'->'hello'.
			'bien'->'good' } asDictionary -> '{"bien":"good","hola":"hello"}'.
		1@1 ->	'{"x":1,"y":1}'.		
	} asDictionary 
		
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> objectsToTestRootSerialization [
	^  42@1 corner:10@11
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> serializeTest [

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|
		self assert: (self serializer serialize:k) equals:v] 
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> serializer [
	^ SCSerializer new
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> testMaterializeObjects [
	| mat |

	self objectsForTestingMaterialization keysAndValuesDo:[:k :v|	
		mat := self materializer materialize:v.
		self assert: mat  equals: k ]  
]

{ #category : #tests }
SCComplexObjectsTest >> testRootSerialization [
	| ser mat k |

		k := self objectsToTestRootSerialization .
		ser :=	 self serializer serialize: k.
	
		mat := self materializer materialize:ser.
		self assert: mat  equals:self objectsToTestRootSerialization .
	

]

{ #category : #tests }
SCComplexObjectsTest >> testSerializeLargeObjects [
	| ser time mat|


		time := [ser :=	 self serializer serialize: self largeObject] timeToRun. 
		self assert: time < (Duration  milliSeconds: 5000). 
		Transcript show:time asString.
		time := [mat :=	 self materializer materialize: ser] timeToRun. 
		Transcript show:time asString.
		self assert: time < (Duration  milliSeconds: 5000) 
]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> testSerializeObjectCircularReferences [
	| obj sobj mobj|

	'{
		"_id":"68bo431p0vk4jdkwbn8hz5s2v",
		"#instanceOf":"SCDomainClassForTest",
		"a":1,
		"b":{"_id":"68bo431p0vk4jdkwbn8hz5s2v","#instanceOf":"SCDomainClassForTest"},
		"c":{	
				"_id":"dzo98pj9j4d4sxs2a79bsnlzs",
				"#instanceOf":"Dictionary",
				"me":{
							"_id":"68bo431p0vk4jdkwbn8hz5s2v",
							"#instanceOf":"SCDomainClassForTest"},
				"hola":"hello"}
	}'.

	obj := SCDomainClassForTest new.
	sobj := self serializer serialize: obj.
	SCObjectsCache instance flush.
	mobj := self materializer materialize: sobj.
	self assert:  mobj b a equals:mobj a .
	mobj a:22.
		self assert:  mobj b a equals:mobj a .

]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> testSerializeObjects [
	| ser mat |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	
		ser :=	 self serializer serialize:k.
		mat := self materializer materialize:ser.
		
		self assert: mat  equals: k ].

]

{ #category : #'as yet unclassified' }
SCComplexObjectsTest >> testSerializeObjectsPlain [
	| ser |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	

		ser :=	 self serializer 
							serializeAllCollectionsAsArrays;
			 				serialize:k.
	
		self assert: ser  equals: v ]
]
