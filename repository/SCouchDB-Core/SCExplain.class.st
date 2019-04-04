Class {
	#name : #SCExplain,
	#superclass : #SCMangoQuery,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #accessing }
SCExplain >> command [
	^ '_explain'
]
