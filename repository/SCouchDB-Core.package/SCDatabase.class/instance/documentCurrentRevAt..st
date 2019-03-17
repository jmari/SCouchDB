documents
documentCurrentRevAt: id 

	| response etag |
	id ifNil:[ self adaptor couchDBError:( 
										SCJsonObject new 
											at:'reason' put: 'id is Nil';
											at:'error' put: '000';
											yourself)].

	response := self adaptor head:(self arrayWith:self name with: id).
				
	etag :=  response headers at:'Etag' ifAbsent:[nil].
	^ etag ifNotNil:[ etag withoutQuoting ]
		