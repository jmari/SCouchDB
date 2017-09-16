public
isAdmin
	"checks if you are admin "
	| roles |

	roles:= (args at:3) at:'roles'.
	^ roles
		ifNil:[false] 
		ifNotNil:[  roles contains:[:element| element = '_admin'] ]


