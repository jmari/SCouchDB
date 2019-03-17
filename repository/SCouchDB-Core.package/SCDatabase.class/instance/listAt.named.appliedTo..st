lists
listAt: app named: nameOfList appliedTo: aView
	| path |
	path := Array with:'_design' with:app with:'_list' with:nameOfList with:aView.
	^ self plainDocumentAt: path