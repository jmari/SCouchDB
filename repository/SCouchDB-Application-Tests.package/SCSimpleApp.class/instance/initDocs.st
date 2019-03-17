as yet unclassified
initDocs
	| arr |
	arr :=Array with:(SCDocument new 
							at: 'user' put:'jma';
							at: 'nickname' put:'Jesús';
							at: 'age' put:35;
							yourself)
				with:(SCDocument new 
							at: 'user' put:'lgl';
							at: 'nickname' put:'Lucía';
							at: 'age' put:16;
							yourself)
				with:(SCDocument new 
							at: 'date' put: DateAndTime now;
							at: 'price' put:1000;
							at: 'client' put:'jma';
							yourself)
				with:(SCDocument new 
							at: 'date' put: DateAndTime now;
							at: 'price' put:3000;
							at: 'client' put:'jma';
							yourself).
					
	self database bulkDocs: arr.
	