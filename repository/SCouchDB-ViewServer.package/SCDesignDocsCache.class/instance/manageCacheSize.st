as yet unclassified
manageCacheSize
	"removes the elements from 1 to cacheSize/2 if the size is greater than #cacheSize "
	mutex critical:[
		(self cache size > self class cacheSize) ifTrue:[
			self cache keys do:[:aKey|
				self cache removeKey: aKey.
				(self cache size < ((self class cacheSize / 2 ))) ifTrue:[
				 	^self]]]]