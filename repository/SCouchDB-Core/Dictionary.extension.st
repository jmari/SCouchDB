Extension { #name : #Dictionary }

{ #category : #'*SCouchDB-Core' }
Dictionary >> markAsDeleted [
	self at:'_deleted' put:true
]
