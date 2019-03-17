build-in-reduceFunctions
median: v from:a to:b 
	|median pos tmp |

	pos:=b - a.
	pos even
	ifTrue:[
		median:= v at:((pos / 2.0) + a)
	]
	ifFalse:[
		tmp:=a + ((pos + 1.0) / 2.0) - 1.0.
		pos:=tmp + 1.0.
		median:=(( v at: tmp)  + (v at: pos)) asFloat  / 2.0.
	].

	^ median

