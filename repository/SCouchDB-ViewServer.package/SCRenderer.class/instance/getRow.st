public
getRow
	| json |
	lastRow ifTrue:[^nil].
	gotRow 
		ifFalse:[
			gotRow:=true.
			self sendStart]
		ifTrue:[	self blowChunks].	
	json:=server readJsonFromCommStream.

	json ifNil:[SCRenderException signal:'Unabled to read a row'].
	^ ((json at:1) = 'list_end')
		ifTrue:[
				lastRow:=true.
				nil]
		ifFalse:[
			((json at:1) = 'list_row') 
				ifFalse:[SCListException signal:'not a row "' , (json at:1) , '"' ]
				ifTrue:[json at:2]]
	