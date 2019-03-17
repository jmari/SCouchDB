http api
znClient
	^ client ifNil:[
			SCAdaptor defaultAdaptor: self.
			client := (ZnClient new 		
											autoResetEntityMethods: #(HEAD DELETE GET);
											host:self host;
											port: self port)]
