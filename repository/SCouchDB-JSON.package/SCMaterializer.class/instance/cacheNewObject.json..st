private
cacheNewObject: anObject json:json
"insert it in the cache"
	| id rev |
	id :=json at:'_id'.
	rev := json at:'_rev'. 
	id ifNotNil:[SCObjectsCache instance at:id put: anObject].
	rev ifNotNil:[SCObjectsCache instance at:id putRevision: rev].	
			