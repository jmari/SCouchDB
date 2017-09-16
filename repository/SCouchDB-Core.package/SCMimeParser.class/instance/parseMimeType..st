public
parseMimeType: mimeType
	"Caves up a mime-type and return an array of the type [type,subtype,{params}]"
	|fullType typeParts params parts p|
	params:= SCJsonObject new.
	parts:= mimeType subStrings:$;.
	parts do:[:aPart|
		p:=aPart subStrings:$=.
		((p size )= 2) ifTrue:[
			params at:(self strip: (p at:1)) put:(self strip: (p at:2)).
			]
		].
	fullType:= (self strip: (parts at:1)).
	fullType='*' ifTrue:[fullType:='*/*'].
	typeParts := fullType subStrings:$/.
	^ (Array with: (typeParts at:1) with: (typeParts at:2) with:params)