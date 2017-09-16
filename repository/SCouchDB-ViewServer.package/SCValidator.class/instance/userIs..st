public
userIs:aRol
	"checks if you are a Rol "
	| roles |

	roles:= (args at:3) at:'roles'.
	^ roles
		ifNil:[false] 
		ifNotNil:[  roles contains:[:element| element = aRol ]]


