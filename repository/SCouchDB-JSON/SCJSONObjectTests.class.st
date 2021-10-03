Class {
	#name : #SCJSONObjectTests,
	#superclass : #TestCase,
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #testing }
SCJSONObjectTests >> testCRUD [
	| object |
	object := SCJsonObject new.
	self assert: object isEmpty.
	self assert: object foo equals: nil.
	object foo: 123.
	self assert: object foo equals: 123.
	self assert: object printString equals: '{"foo":123}'.
	object name: 'test'.
	object value: Float pi.
	self assert: object name equals: 'test'.
	self assert: (object value closeTo: Float pi).
	self assert: object keys asSet equals: #(foo name value) asSet.
	object removeKey: #foo.
	self assert: object foo equals: nil.
	object removeAll.
	self assert: object isEmpty
]

{ #category : #testing }
SCJSONObjectTests >> testJSON [
	| data  json object |
	data := SCJsonObject newFrom: (Array with: #foo->1 with: #bar->2 with: #str->'Str!' with: #bool->true with: #flt->1.5).
	json := SCSerializer serialize: data .
	object := SCMaterializer readFromString: json.
	self assert: object class equals: SCJsonObject.
	self assert: object equals: data.
	json := (SCSerializer serialize: object).
	self assert: (SCMaterializer readFromString: json) equals: object
]
