private
unescapeUnicode
	|string|
	string := (String with: stream next with: stream next with: stream next with: stream next) asUppercase.
	^ Unicode value: (Integer readFrom: string readStream base: 16)