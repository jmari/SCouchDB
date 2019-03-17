public
enforce:aBlock
	| ex |
	( aBlock value) ifFalse:[ 
		ex:=SCForbiddenException new.
		ex messageText:( aBlock asString , ' is not true').
		ex signal]