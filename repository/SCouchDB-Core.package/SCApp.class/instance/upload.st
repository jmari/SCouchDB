initialization
upload
	|db|
	"Upload the application and put the compiled block inside the application cache"
	adaptor ifNil:[SCError signal:'No adaptor. Send connect before upload'].

	(self language = 'smalltalk') ifTrue:[
		"include the app in the CouchViewServer cache (only for smalltalk language)"
		SCViewServer servers do:[:aServer| 
			(aServer designDocs at: (self at:'_id'))  ifNotNil:[
				(aServer designDocs at:(self at:'_id')) 
					indexers do:[:anIndexer|anIndexer stop]].
			"aServer designDocs at:('/_design/', self appName) put:self "]
		].	
	db:=adaptor ensureDatabase: self appName.
	db documentPut:self.	
	self database:db