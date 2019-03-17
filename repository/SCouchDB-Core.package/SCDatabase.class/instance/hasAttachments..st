documents
hasAttachments: anObject
	^ ((anObject isKindOf:SCDocument) and:[
	(anObject hasAttachments) ]) 
