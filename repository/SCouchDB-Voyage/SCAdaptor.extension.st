Extension { #name : #SCAdaptor }

{ #category : #'*SCouchDB-Voyage' }
SCAdaptor >> enableSingleton [
	self class defaultAdaptor: self
]
