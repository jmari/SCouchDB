as yet unclassified
objectsForTestingSerialization
^ { 
	(OrderedCollection  new add:Stack new; add:Stack new;yourself) -> '[[],[]]'.
	(Array
				with: 'error'
				with: 'Runtime error'
				with: 'message') -> '["error","Runtime error","message"]'.
	#(#()) -> '[[]]'. 
		(Stack new push:(Array with:SCJsonObject  new);push:'popo';yourself) -> '["popo",[{}]]'.
		
		nil -> 'null'.
		1 -> '1'.
		1.1 -> '1.1'.
		'hola'->'"hola"'.
		#(1 2 'hola') -> '[1,2,"hola"]'.
		#(1 2 'hola') asOrderedCollection   -> '[1,2,"hola"]'.
		#(1 2 'hola') asSet   ->'[1,2,"hola"]'.
		{ 'hola'->'hello'.
			'bien'->'good' } asDictionary -> '{"bien":"good","hola":"hello"}'.
		1@1 ->	'{"x":1,"y":1}'.		
	} asDictionary 
		