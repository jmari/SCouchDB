Class {
	#name : #BaselineOfSCouchDB,
	#superclass : #BaselineOf,
	#category : 'BaselineOfSCouchDB'
}

{ #category : #baseline }
BaselineOfSCouchDB >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		self voyage: spec.
		
		spec

		package: 'SCouchDB-JSON';
		package: 'SCouchDB-Core' with: [ spec requires: #('SCouchDB-JSON' ) ];
		package: 'SCouchDB-Voyage' with: [ spec requires: #('SCouchDB-Core' 'Voyage-Model-Core') ];
		package: 'SCouchDB-ViewServer' with: [ spec requires: #('SCouchDB-Voyage') ].
		
		self groups: spec
	]

]

{ #category : #protocol }
BaselineOfSCouchDB >> groups: spec [
	spec 
		group: 'default' with: #('SCouchDB-Core');
		group: 'json' with: #('SCouchDB-JSON');
		group: 'voyage' with: #(default 'SCouchDB-Voyage');
		group: 'viewserver' with: #(default voyage 'SCouchDB-ViewServer' )
]

{ #category : #script }
BaselineOfSCouchDB >> voyage: spec [
	spec 
		baseline: 'Voyage' with: [ spec repository: 'github://pharo-nosql/voyage/mc' ];
		import: 'Voyage'
]
