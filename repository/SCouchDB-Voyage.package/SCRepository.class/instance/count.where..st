persistence
count: aClass where: aWhereBlock
	| index mq|
	"@todo we need to convert the where block to query parameters in order to call the view like count"
	mq := self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						fields: #(#_id);
						limit: self maxObjectsInMem.
	aWhereBlock ifNotNil:[ mq selector: aWhereBlock].
	index := self indexForClassSortedBy: #().

	^ (mq	
		useIndex: index;
		execute) size
				
			