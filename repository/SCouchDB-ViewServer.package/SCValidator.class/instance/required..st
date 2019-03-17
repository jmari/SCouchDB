public
required:aField
"checks if a field exists and is not nil"
	| ex aDoc|
	aDoc:=args at:1.
	( aDoc includesKey: aField) 
		ifTrue:[ 
			(aDoc at:aField) ifNil:[
				ex:=SCForbiddenException new.
				ex messageText:( aDoc asString , ' requires the field: ', aField asString).
				ex signal]]
		ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( aDoc asString , ' requires the field: ', aField asString).
			ex signal]
