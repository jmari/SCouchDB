updates
updateFunctionAt: app named: updateFunction passing:aJsonDoc
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction. 
	^ self documentAt: path put:aJsonDoc forcePost:true.