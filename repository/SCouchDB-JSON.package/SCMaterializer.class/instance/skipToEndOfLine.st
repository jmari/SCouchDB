private
skipToEndOfLine
	| cr lf |
	cr := Character cr. lf := Character lf.
	[ | c | (c := stream peek) == cr or: [ c == lf]] whileFalse: [stream next].
	self skipWhitespace