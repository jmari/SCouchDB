Class {
	#name : #SCouchQueryGenerator,
	#superclass : #SCVisitor,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #visiting }
SCouchQueryGenerator >> visitConditionOperator: aCondition [
	^ Dictionary new 
		at: (self visit: aCondition left) 
		put: (Dictionary new
			at: aCondition label
			put: (self visit: aCondition right);
			yourself);
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitEqualCondition: aCondition [
	^ Dictionary new 
		at: (self visit: aCondition left) 
		put: (self visit: aCondition right);
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitExistsCondition: anExistsCondition [ 
	^ Dictionary new
		at: anExistsCondition label
		put: anExistsCondition right;
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitField: aField [
	^ aField label
]

{ #category : #visiting }
SCouchQueryGenerator >> visitInCondition: aCondition [
	^ Dictionary new
		at: aCondition label
		put: (Dictionary new
			at: (self visit: aCondition left) 
			put: (self visit: aCondition right);
			yourself);
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitLogicalCondition: aLogicalCondition [
	^ Dictionary new
		at: aLogicalCondition label
		put: (aLogicalCondition conditions collect: [ :each |
			self visit: each ]);
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitNotCondition: aCondition [ 
	^ Dictionary new
		at: (self visit: aCondition condition left)
		put: (Dictionary new
			at: aCondition label
			put: (self visit: aCondition condition right);
			yourself);
		yourself
]

{ #category : #visiting }
SCouchQueryGenerator >> visitObject: anObject [
	^ anObject
]

{ #category : #visiting }
SCouchQueryGenerator >> visitWhereCondition: aWhereCondition [ 
	^ Dictionary new
		at: aWhereCondition label
		put: aWhereCondition javascript;
		yourself
]
