db api
createDatabase: aName

	aName do: [ :c | ('abcdefghijklmnopqrstuvwxyz0123456789_$()+-/`' includes: c)  
		ifFalse: [ ^ self error: 'Invalid database name' ]].

 	self put:aName.
	^ self database name: aName	
	