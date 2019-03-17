as yet unclassified
objectsForTestingMaterialization
^ { 
	(OrderedCollection  new add:Stack new; add:Stack new;yourself) -> '{"#instanceOf":"OrderedCollection","#values":[{"#instanceOf":"Stack","#values":[]},{"#instanceOf":"Stack","#values":[]}]}'.
	(Array
				with: 'error'
				with: 'Runtime error'
				with: 'message') -> '["error","Runtime error","message"]'.
	#(#()) -> '[[]]'. 
		(Stack new push:(Array with:SCJsonObject  new);push:'popo';yourself) -> '{"#instanceOf":"Stack","#values":["popo",[{}]]}'.
		
		nil -> 'null'.
		1 -> '1'.
		1.1 -> '1.1'.
		'hola'->'"hola"'.
		#(1 2 'hola') -> '[1,2,"hola"]'.
		#(1 2 'hola') asOrderedCollection   -> '{"#instanceOf":"OrderedCollection","#values":[1,2,"hola"]}'.
		#(1 2 'hola') asSet   ->'{"#instanceOf":"Set","#values":[1,2,"hola"]}'.
		{ 'hola'->'hello'.
			'bien'->'good' } asDictionary -> '{"#instanceOf":"Dictionary","bien":"good","hola":"hello"}'.
		1@1 ->	'{"#instanceOf":"Point","x":1,"y":1}'.	
		(Time new seconds:52801 nanoSeconds:732987000)  ->'{"#instanceOf":"Time","seconds":52801,"nanos":732987000}'	
	} asDictionary 
		