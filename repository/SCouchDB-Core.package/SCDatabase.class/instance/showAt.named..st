shows
showAt: app named: nameOfShow
	| path |
	path := Array with:'_design' with:app with:'_show' with:nameOfShow.
	^ self plainDocumentAt: path