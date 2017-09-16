http api
znClient
	^ client ifNil:[
			SCAdaptor defaultAdaptor: self.
			client := (ZnClient new 		
											host:self host;
											port: self port)]
