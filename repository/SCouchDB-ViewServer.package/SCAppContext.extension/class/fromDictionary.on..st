*SCouchDB-ViewServer
fromDictionary:aDic on:aViewServer
	| a |
	a:=self fromDictionary:aDic.
	a server:aViewServer.
	^ a