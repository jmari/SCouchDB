serialization
serializer
	"Serializer uses the adaptor to obtain the UUID"
	^ serializer ifNil:[serializer := SCSerializer on:self]