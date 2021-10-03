Class {
	#name : #SCJSONBenchmark,
	#superclass : #Object,
	#instVars : [
		'objects',
		'json'
	],
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #'initialize-release' }
SCJSONBenchmark >> initialize [
	super initialize.
	objects := Array new: 1000.
	1 to: 1000 do: [ :each |
		| map |
		(map := Dictionary new)
			at: 'id' put: each;
			at: 'name' put: 'Name-', each asString;
			at: 'enabled' put: (#( true false) at: (each \\ 2) + 1);
			at: 'color' put: (#( 'red' 'green' 'blue' ) at: (each \\ 3) + 1);
			at: 'value' put: each + each / 1000.0.
		objects at: each put: map ].
	json := String streamContents: [ :stream |
		SCSerializer serialize: objects on:stream ]
		
]

{ #category : #public }
SCJSONBenchmark >> read [
	^ SCMaterializer readFrom: json readStream

]

{ #category : #public }
SCJSONBenchmark >> write [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream) nextPut: objects ]

]
