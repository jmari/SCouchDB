private
addTriggersFromJSCode:eV
	| i j k eventName eventlyEvent|
	eventlyEvent:=eV asString.
	i:=1.j:=1.k:=1.
	eventName := ''.
	[i = 0] whileFalse:[
		i:= eventlyEvent findString:'.trigger' startingAt:i. 
		(i>0) ifTrue:[
			i:= eventlyEvent findString: '(' startingAt: i.
			j:= eventlyEvent findString: ')' startingAt: i.
	
			eventName:=(eventlyEvent copyFrom:i to: j) trimBoth.
			eventName:=eventName copyFrom:2 to:(eventName size -1). 
			k:= eventName findString:','.
			(k=0 and:[(i ~= 0 and:[j~=0])]) ifTrue: [eventName:= (eventName copyFrom:2 to:(eventName size -1))].
			(k>0 and:[(i ~= 0 and:[j~=0])]) ifTrue: [eventName:= (eventName copyFrom:2 to:(k -2))]].
			(eventName notNil and:[eventName size>1 and:[(eventName at:1) ~=$_]]) 				ifTrue:[self triggers add:eventName]]
