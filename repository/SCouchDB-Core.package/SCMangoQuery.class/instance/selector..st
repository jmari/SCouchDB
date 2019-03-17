options
selector: aBlock
	| selector |
	selector := self at:'selector'  
				ifPresent: [(self at:'selector') ]
				ifAbsent: [self at:'selector' put: (Dictionary new at:'$and' put:OrderedCollection new ;yourself)].
	(selector at:'$and') add: (SCQueryBuilder queryFor:aBlock);yourself			
	 