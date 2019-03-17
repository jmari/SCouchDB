as yet unclassified
server
a ifNil:[a:=SCViewServer new.
		a commStream: (ReadWriteStream on:'').
		a commStream nextPutAll: '["list_end"]'.
		a commStream position: 0
		].
^a. 