public
parseMediaRange:aRange
	|q parsedType nq |

	parsedType:= self parseMimeType:aRange.
	q:= (parsedType at:3) at:'q' ifAbsent:['1'].
	[nq:= q asFloat] on:Error do:[ 
			(parsedType at:3) at:'q' put:'1'.	
			nq := 1].
	(nq <0 or:[nq>1]) ifTrue:[
			(parsedType at:3) at:'q' put:'1'].
	^ parsedType


