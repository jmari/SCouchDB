private
interpretStringEscape
	| c |
	c := stream next.
	c == $b ifTrue: [^ Character backspace].
	c == $n ifTrue: [^ Character lf].
	c == $f ifTrue: [^ Character newPage].
	c == $r ifTrue: [^ Character cr].
	c == $t ifTrue: [^ Character tab].
	c == $u ifTrue: [^ self unescapeUnicode].
	^ c.