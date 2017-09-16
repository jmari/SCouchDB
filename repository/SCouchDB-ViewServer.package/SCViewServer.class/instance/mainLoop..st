parsing
mainLoop:jsonArray
	|command argument finalArray keyArray valArray tmpArray tmp2Array reduceFunctions |

	(jsonArray isKindOf:Array) 
		ifFalse:[
			(jsonArray path at:2) = '_fts' ifTrue:[	self ftsCommand:jsonArray].
			^nil].

	command:= jsonArray at:1.
	(command='ddoc')  ifTrue:[ ^ self ddoc:jsonArray].
	(command='reset') ifTrue:[ ^ self reset ].
	(command='map_doc') 
		ifTrue:[		
			2 to:(jsonArray size ) do:[:arg|
				finalArray := self mapDoc:(jsonArray at:arg)].			
			^ self serializer serialize:finalArray].

	(command='add_fun') 
		ifTrue:[
			argument:=jsonArray at:2.
			^ self compileMapFunction: (argument trimSpaces)].

	((command='reduce') or:[command='rereduce']) 
		ifTrue:[	
			reduceFunctions:=jsonArray at:2.
			keyArray:=OrderedCollection new.
			valArray:=OrderedCollection new.
			finalArray:=OrderedCollection new.
			tmpArray:=(jsonArray at:3).	
			tmpArray do:[:aKeyDoc|
				tmp2Array:=aKeyDoc.
				(command='reduce') 
					ifTrue:[
						keyArray add:(tmp2Array at:1).
						valArray add:(tmp2Array at:2)]
					ifFalse:[ 	valArray add:aKeyDoc ]].
					
			(command='reduce') ifTrue:[self log:keyArray asString].
		
			reduceFunctions do:[:arFunc|
				finalArray add: (self reduce:arFunc  
												keys:keyArray 
												values:valArray 
												rereduce:(command='rereduce'))].

			^ self serializer serialize:(Array with:true with: finalArray).
		].
	^ nil