private
indexForClassSortedBy: arrayInSortSyntax
	| oc |
	oc := Array with:'#instanceOf'withAll: arrayInSortSyntax.
		
	^ self sortingIndexes 
			at: oc asString 
			ifAbsentPut:[ self database index 
													name: oc asString;
													fields:  oc;
													new]