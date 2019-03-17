public
field:aField shouldBe:value
	"checks if a field is  'value' "
	| ex aNewDoc|
	aNewDoc:=args at:1.
	
	((aNewDoc at:aField) = value) ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( 'Field ',aField,' must be: ',value).
			ex signal]


