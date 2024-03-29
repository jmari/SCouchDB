Class {
	#name : #SCJSONTest,
	#superclass : #TestCase,
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #'as yet unclassified' }
SCJSONTest >> deepObject [
   | di do |
	di := Dictionary new.
	do := di.
	1 to:1000 do:[:i | 
		di := (di at: ('i',i asString) put: {'depth'->i} asDictionary) ].
	^ do
]

{ #category : #'as yet unclassified' }
SCJSONTest >> largeObject [
   | lo |
	lo := Array new:5000.
	1 to:5000 do:[:i | lo at:i put: self objectsForTestingSerialization ].
	^ lo
]

{ #category : #'as yet unclassified' }
SCJSONTest >> materializer [
	^ SCMaterializer new
]

{ #category : #'as yet unclassified' }
SCJSONTest >> objectsForTestingMaterialization [
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
SCJSONTest >> objectsForTestingSerialization [
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
SCJSONTest >> objectsToTestRootSerialization [
	^  42@1 corner:10@11
]

{ #category : #'as yet unclassified' }
SCJSONTest >> serializeTest [

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|
		self assert: (self serializer serialize:k) equals:v] 
]

{ #category : #'as yet unclassified' }
SCJSONTest >> serializer [
	^ SCSerializer new
]

{ #category : #'as yet unclassified' }
SCJSONTest >> testMaterializeObjects [
	| mat |

	self objectsForTestingMaterialization keysAndValuesDo:[:k :v|	
		mat := self materializer materialize:v.
		self assert: mat  equals: k ]  
]

{ #category : #tests }
SCJSONTest >> testRootSerialization [
	| ser mat k |

		k := self objectsToTestRootSerialization .
		ser :=	 self serializer serialize: k.
		ser inspect.
		mat := self materializer materialize:ser.
		self assert: mat  equals:self objectsToTestRootSerialization .
	

]

{ #category : #tests }
SCJSONTest >> testSerializeDeepObjects [
	| ser mat dict i maxdepth|
		maxdepth := 82 "put only even values".
		ser :=	 self serializer maxDepth: maxdepth; serialize: self deepObject. 	
		SCObjectsCache instance flush.	
		mat := self materializer materialize:ser.
		dict := mat.
		i := 0.
		[ dict='max_depth' ] whileFalse:[
			i := i + 1.
			dict := (dict at: ('i',i asString) ifAbsent:['max_depth']).
		
		 ].
		"Dictionaries has two levels, associations inside dictionaries"
		self assert: i * 2 equals: maxdepth 
]

{ #category : #tests }
SCJSONTest >> testSerializeLargeObjects [
	| ser time mat|


		time := [ser :=	 self serializer serialize: self largeObject] timeToRun. 
		self assert: time < (Duration  milliSeconds: 5000). 
		Transcript show:time asString.
		time := [mat :=	 self materializer materialize: ser] timeToRun. 
		Transcript show:time asString.
		self assert: time < (Duration  milliSeconds: 5000) 
]

{ #category : #'as yet unclassified' }
SCJSONTest >> testSerializeObjectCircularReferences [
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
	mobj := self materializer materialize: sobj.
	self assert:  mobj b a equals:mobj a .
	mobj a:22.
		self assert:  mobj b a equals:mobj a .

]

{ #category : #'as yet unclassified' }
SCJSONTest >> testSerializeObjects [
	| ser mat |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	
		ser :=	 self serializer serialize:k.
		mat := self materializer materialize:ser.
		
		self assert: mat  equals: k ].

]

{ #category : #'as yet unclassified' }
SCJSONTest >> testSerializeObjectsPlain [
	| ser |

	self objectsForTestingSerialization keysAndValuesDo:[:k :v|	

		ser :=	 self serializer 
							serializeAllCollectionsAsArrays;
			 				serialize:k.
	
		self assert: ser  equals: v ]
]
