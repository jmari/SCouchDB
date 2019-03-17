shows
showAt: app named: nameOfShow appliedTo:aDocId
	| path |
	path := Array with:'_design' with:app with:'_show' with: nameOfShow with:aDocId.
	^ self plainDocumentAt: path