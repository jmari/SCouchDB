tests
objects
	| dict  |
	dict := Dictionary new.
	dict at: '1' put: 10;
		at: 'foo' put: 'bar';
		at: 'table' put: #(4 5 6);
		at: 'bool' put: true.		
	^ dict