protected
listeningAt:anEventlyNode
	|la at en |

	"get triggers"
	en :=Set new.
	at:=(self at:anEventlyNode) triggering. 
	self keys do:[:aNode|
		la:= Set new.
		la addAll: (at select:[:aE| aNode~=anEventlyNode and:[(self at:aNode) listeningTo includes: aE]]).
		la size>0 ifTrue:[en add:(Array with:aNode with:la asArray)]].
	^en asArray