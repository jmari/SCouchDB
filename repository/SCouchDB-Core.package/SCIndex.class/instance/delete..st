operations
delete: index
	| path result |


	path :=  Array with:self database name with: '_index' with: index ddoc with:'json' with:index name.
		
	result := self adaptor delete:	path.
	^ result 