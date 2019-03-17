database
all
	| result |
	
	self includeDocs.
	result:= self adaptor get: (self 
											arrayWith:self name
											with: '_all_docs').

	^(result at: 'rows') collect: [:row | row at: 'doc']