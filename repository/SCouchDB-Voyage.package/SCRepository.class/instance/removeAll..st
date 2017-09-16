persistence
removeAll: aClass
	
	| index objects |
	index := self indexForClassSortedBy:#().

	objects:= self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						fields:#(#_id #_rev);
						useIndex: index;
						limit: self maxObjectsInMem;
						execute.
	
	^ self database bulkRemoveDocs: objects.
	
