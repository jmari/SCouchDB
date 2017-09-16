persistence
selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: limit offset: offset
	| index mq|
	

	mq := self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						limit: limit;
						skip: offset.
	aWhereBlock ifNotNil:[ mq selector: aWhereBlock].
	^ (sortBlockOrArray isKindOf: BlockClosure ) 
					ifTrue:  [ mq execute sort: sortBlockOrArray]
					ifFalse: [
							index := self indexForClassSortedBy: sortBlockOrArray.
						 	mq	
								useIndex: index;
								sort: (Array with:'#instanceOf' withAll:sortBlockOrArray);
								execute]
				
			