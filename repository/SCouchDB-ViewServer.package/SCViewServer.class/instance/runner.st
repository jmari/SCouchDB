accessing
runner
	"runner provide us a basic Application context where we can execute all the methods related to a View, Show, List... "
	^ runner ifNil:[ runner := SCAppContext on:self ]
	
	