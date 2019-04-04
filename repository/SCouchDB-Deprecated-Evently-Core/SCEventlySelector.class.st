Class {
	#name : #SCEventlySelector,
	#superclass : #SCJsonObject,
	#category : 'SCouchDB-Deprecated-Evently-Core'
}

{ #category : #accessing }
SCEventlySelector >> onEvent:event  do:jscriptFunction [

	self at:event put: jscriptFunction.
		
]
