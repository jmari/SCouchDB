as yet unclassified
initLists
"using provider"
self listAt:'users' 
   put: [:head :req |
	|row  doc|

	self provides:'html' with:[
   [ row := self getRow] whileNotNil:[
		doc := row at:'value'.
		(doc  isKindOf:Dictionary) ifTrue:[
   			doc at:'user' ifPresent:[self send: (SCSerializer serialize:doc) , '<br/>']
					]]]].
"without provider"	
self listAt:'users2' 
   put: [:head :req |
	|row  doc response|
	response := OrderedCollection new.
   [ row := self getRow] whileNotNil:[
		doc := row at:'value'.
		(doc  isKindOf:Dictionary) ifTrue:[
   			doc at:'user' ifPresent:[ response add: (doc at:'user' ), '<br/>']
					]].
	response	]

