updates
updateFunctionAt: app named: updateFunction
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction. 
	^ self documentAt: path put:Dictionary new forcePost:true.