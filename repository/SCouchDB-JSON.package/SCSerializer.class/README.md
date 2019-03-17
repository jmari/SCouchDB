Serializes any Smalltalk Object to a json representation. 
This class assigns an ID to each object in order to support circular references
This ID is supplied by a SCUUIDProvider that uses the SCObjectCache couchCache to save these references. 

-Public API and Key Messages
areAllCollectionsSerializedAsArrays. Return true if the instance is setted to serialize all kind of collections as Arrays.
serialize: anObject. Serializes an object to a string.
serializeAllCollectionsAsArrays. Set the instance to serialice all the collections (Set, OrderedCollection, Stack...) as Json Arrays.

-On class side:
serialize: anObject. Serializes an object.

- How to create instances.
on: anAdaptor. Creates and return an Instance, this instance has a SCCouchUUIDProvider connected to the supplied adaptor. It uses the SCAdaptor to ask CouchDB for new uuids. 

- Instance Variables
	allColectionSerializedAsArray:		<Bool>
	pool:		<WeakIdentityKeyDictionary> used to keep in mind the objects already serialized.
	schemes:		<Dictionary> stores the {class -> Block} associations. Each block is responsible of the serialization of a class.
	uuidProvider:		<SCUUIDProvider> used to discover or get a new one uuid for an object 
