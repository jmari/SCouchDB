SCObjectsCache  
a singleton class variable accessible at "instance" class method. 
It maintains a key value  index  for uuid-->Instance and another index instance-->uuid, it also keeps the revision of an object. Each time an object is saved/readed from couchdb this revision field is updated.


    Instance Variables
	compactLimit:		anInteger, when this value is overflooded the compact method is called
	mutex:		Mutex for mutual exclusion.
	objects:		<uuid --> Object>  WeakValueDictionary
	reversedObjects:		<object --> uuid>  WeakIdentityKeyDictionary
	versions:		<uuid --> version>  Dictionary

