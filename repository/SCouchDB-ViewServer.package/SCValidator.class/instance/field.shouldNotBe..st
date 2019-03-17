public
field:aField shouldNotBe:value
	"checks if a field is not 'value' "
	| ex aNewDoc|
	aNewDoc:=args at:1.
	
	((aNewDoc at:aField) = value) ifTrue:[ 
			ex:=SCForbiddenException new.
			ex messageText:( 'Field ',aField,' must be: ',value).
			ex signal]


