updates
updateFunctionAt: app named: updateFunction for:aDocumentId passing:aJsonDoc
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction with:aDocumentId. 
	^ self documentAt: path put:aJsonDoc.