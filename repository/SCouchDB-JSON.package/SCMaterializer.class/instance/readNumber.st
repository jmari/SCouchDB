private
readNumber
	| acc c |
	acc := WriteStream on: ''.
	[
		c := stream peek.
		(c isNil not and: [self numbersMayContain: c]) ifFalse: [
			[^ acc contents asNumber] on: Error do: [SCJsonSyntaxError signal: 'Invalid number']].
		acc nextPut: c.
		stream next.
	] repeat.