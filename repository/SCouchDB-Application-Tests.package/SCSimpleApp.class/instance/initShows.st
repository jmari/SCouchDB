as yet unclassified
initShows
self showAt:'user' 
   put: [:doc :req| 
		(doc isKindOf:Dictionary) ifTrue:[
			doc at:'user' 
				ifPresent:[(doc at:'user') , (doc at:'nickname')]
				ifAbsent:['no-doc']. 
 		]
	]