public
unchanged:aField
	"aField can not change if it changes an Exception will be rised"
	| ex aDoc anOldDoc |

	aDoc:=args at:1.
	anOldDoc:=args at:2.
	anOldDoc ifNotNil:[
		(( aDoc at: aField) = (anOldDoc at:aField)) ifFalse:[ 
			ex:=SCForbiddenException new.
			ex messageText:( aDoc asString , ' Field can not be changed: ', aField asString).
			ex signal]]