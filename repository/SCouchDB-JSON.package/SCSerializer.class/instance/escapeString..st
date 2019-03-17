private
escapeString: aString
	
	| c oldStream newStream code |

	oldStream := ReadStream on:aString.
	newStream := WriteStream on:String new.
	[oldStream atEnd] whileFalse:[
		c := oldStream next.
		c == $/ ifTrue: [newStream nextPut:$\;nextPut:$/] ifFalse:[
		c == $\ ifTrue: [newStream nextPut:$\;nextPut:$\] ifFalse:[
		c == $" ifTrue: [newStream nextPut:$\;nextPut:$"] ifFalse:[
		c == Character backspace ifTrue: [newStream nextPut:$\;nextPut:$b] ifFalse:[
		c == Character lf ifTrue:[newStream nextPut:$\;nextPut:$n]ifFalse:[
		c == Character newPage ifTrue:[newStream nextPut:$\;nextPut:$f]ifFalse:[
		c == Character cr ifTrue:[newStream nextPut:$\;nextPut:$r]ifFalse:[
		c == Character tab ifTrue:[newStream nextPut:$\;nextPut:$t]ifFalse:[
		c codePoint > 255 ifTrue:[
			code :=(c asUnicode printStringBase:16). 
			[code size<4] whileTrue:[code:= '0', code].
			newStream nextPutAll: '\u';nextPutAll:code ]ifFalse:[newStream nextPut:c]]]]]]]]].

	].
	^ newStream contents.