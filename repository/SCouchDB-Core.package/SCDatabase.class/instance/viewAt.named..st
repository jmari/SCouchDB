views
viewAt: app named: nameOfView
	| path result response |

	path := Array with: self name with:'_design' with:app with:'_view' with:nameOfView.

	result := self adaptor get: path.
	
	^  	result at: 'rows'
