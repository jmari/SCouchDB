http api
copy: path to:aDest


	| response result |
	response:=	self znClient
							addPath:path;
							method:#COPY;
							headerAt:'Destination' put:aDest;
							execute;
							response.
	result := 	self materializer materialize: response contents.
	^ self znClient isSuccess 
						ifTrue:[result]
						ifFalse: [ self couchDBError:result ]
						
	