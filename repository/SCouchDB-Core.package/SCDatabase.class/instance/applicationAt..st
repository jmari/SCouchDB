applications
applicationAt: appName
	^ (self documentAt: ( Array with:'_design' with:appName asLowercase )) asSCApp database: self
		