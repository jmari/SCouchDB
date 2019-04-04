Extension { #name : #BlockClosure }

{ #category : #'*SCouchDB-Core-MangoQueries' }
BlockClosure >> asMangoQuery [ 
	^ SCQueryBuilder queryFor: self
]
