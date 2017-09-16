error handling
couchDBError: jobject 
	^ SCError new 
		object:jobject;
		signal: 
		'Error: ', (jobject at: 'error') , ' reason: ', (jobject at: 'reason')