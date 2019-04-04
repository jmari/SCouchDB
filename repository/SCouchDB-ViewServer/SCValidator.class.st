"
Executes validation function. Deploy the context for the validate_doc_update function

Command:	 ddoc
SubCommand:	validate_doc_update



    Instance Variables
	args:			Document object that will be stored
					Document object that will be replaced
					User Context Object
					Security Object
	indexers:		I just try to add fts to couchdb
	serializer:		Used to serialize 


"
Class {
	#name : #SCValidator,
	#superclass : #Object,
	#instVars : [
		'args',
		'indexers',
		'serializer'
	],
	#category : 'SCouchDB-ViewServer'
}

{ #category : #accessing }
SCValidator >> args [
	^ args
]

{ #category : #accessing }
SCValidator >> args: anObject [
	args := anObject
]

{ #category : #public }
SCValidator >> enforce:aBlock [
	| ex |
	( aBlock value) ifFalse:[ 
		ex:=SCForbiddenException new.
		ex messageText:( aBlock asString , ' is not true').
		ex signal]
]

{ #category : #public }
SCValidator >> field:aField shouldBe:value [
	"checks if a field is  'value' "
	| ex aNewDoc|
	aNewDoc:=args at:1.
	
	((aNewDoc at:aField) = value) ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( 'Field ',aField,' must be: ',value).
			ex signal]



]

{ #category : #public }
SCValidator >> field:aField shouldNotBe:value [
	"checks if a field is not 'value' "
	| ex aNewDoc|
	aNewDoc:=args at:1.
	
	((aNewDoc at:aField) = value) ifTrue:[ 
			ex:=SCForbiddenException new.
			ex messageText:( 'Field ',aField,' must be: ',value).
			ex signal]



]

{ #category : #accessing }
SCValidator >> indexers [
	^ indexers ifNil:[indexers:= SCJsonObject new ]
]

{ #category : #public }
SCValidator >> isAdmin [
	"checks if you are admin "
	| roles |

	roles:= (args at:3) at:'roles'.
	^ roles
		ifNil:[false] 
		ifNotNil:[  roles contains:[:element| element = '_admin'] ]



]

{ #category : #public }
SCValidator >> required:aField [
"checks if a field exists and is not nil"
	| ex aDoc|
	aDoc:=args at:1.
	( aDoc includesKey: aField) 
		ifTrue:[ 
			(aDoc at:aField) ifNil:[
				ex:=SCForbiddenException new.
				ex messageText:( aDoc asString , ' requires the field: ', aField asString).
				ex signal]]
		ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( aDoc asString , ' requires the field: ', aField asString).
			ex signal]

]

{ #category : #runner }
SCValidator >> runValidate:fun ddoc:ddoc args:vargs [

	fun valueWithEnoughArguments:vargs. 
 	^'1'.	

]

{ #category : #'as yet unclassified' }
SCValidator >> serializer [
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]
]

{ #category : #public }
SCValidator >> unchanged:aField [
	"aField can not change if it changes an Exception will be rised"
	| ex aDoc anOldDoc |

	aDoc:=args at:1.
	anOldDoc:=args at:2.
	anOldDoc ifNotNil:[
		(( aDoc at: aField) = (anOldDoc at:aField)) ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( aDoc asString , ' Field can not be changed: ', aField asString).
			ex signal]]
]

{ #category : #public }
SCValidator >> userIs:aRol [
	"checks if you are a Rol "
	| roles |

	roles:= (args at:3) at:'roles'.
	^ roles
		ifNil:[false] 
		ifNotNil:[  roles contains:[:element| element = aRol ]]



]
