private
blockForCollections
	
	^ [ :obj :json |
		| nObj nArray|
		(obj isKindOf: Array) 
				ifTrue:[
					
					nObj := (json isKindOf:Dictionary)
									ifTrue:[ json at:'#values' ]
									ifFalse:[ json ].
					nArray := Array new: nObj size.
					nObj doWithIndex:[:each :index|
						nArray at:index put: (self imaterialize:each)].
					nArray]
				ifFalse:[
					obj removeAll.
					(json at:'#values') do:[:each| obj add: (self imaterialize:each)].
					obj]]
	
	