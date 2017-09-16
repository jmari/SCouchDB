# SCouchDB
Pharo driver for CouchDB database using Zinc client. Supports Mango queries and implements Voyage API

Install
-------


You can install it executing scripts:

### SCouchDB-Core
```Smalltalk
Metacello new 
	baseline: 'SCouchDB';
	repository: 'github://jmari/SCouchDB/repository';
	load
```

### SCouchDB-Voyage
```Smalltalk
Metacello new 
	baseline: 'SCouchDB';
	repository: 'github://jmari/SCouchDB/repository';
	load:'voyage'
```

### SCouchDB-ViewServer
```Smalltalk
Metacello new 
	baseline: 'SCouchDB';
	repository: 'github://jmari/SCouchDB/repository';
	load:'viewserver'
```
You have to change couchdb configuration in order to use the smalltalk viewserver, add a new input in query_servers section for "smalltalk" "/Path_to_Pharo_executable/Pharo --headless /Path_to_Pharo_image/Pharo6.1.image viewserver --debug"

