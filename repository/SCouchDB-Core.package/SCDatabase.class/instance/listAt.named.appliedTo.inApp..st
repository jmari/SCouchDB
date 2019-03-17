lists
listAt: app named: nameOfList appliedTo: aView inApp:anotherApp
	| path |
	path := Array with:'_design' with:app with:'_list' with:nameOfList with: anotherApp with:aView.
	^ self plainDocumentAt: path 