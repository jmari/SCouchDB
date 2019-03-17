as yet unclassified
initViews
self viewAt:'users' put: [ :doc | 
	(doc isKindOf:Dictionary )ifTrue:[
	doc at:'user' ifPresent: [ 
			self	
				emit:doc 
				key: (doc at:'_id') ]]].
	
self viewAt:'ages' put: [ :doc | 
	(doc isKindOf:Dictionary )ifTrue:[
	doc at:'age' ifPresent: [ 
			self	
				emit:(doc at:'age')
				key: (Array with:1 with: (doc at:'age'))]]]
	reduce:#stats.

	
self viewAt:'minages' put: [ :doc | 
	(doc isKindOf:Dictionary )ifTrue:[
	doc at:'age' ifPresent: [ 
			self	
				emit:(doc at:'age')
				key: (Array with:1 with: (doc at:'age'))]]]
	reduce:#min.
	

	
self viewAt:'sales' put: [ :doc | 
	(doc isKindOf:Dictionary )ifTrue:[
	doc at:'age' ifPresent: [ 
			self	
				emit:(doc at:'age')
				key: (Array with:1 with: (doc at:'age'))]]]
	reduce:#stats.