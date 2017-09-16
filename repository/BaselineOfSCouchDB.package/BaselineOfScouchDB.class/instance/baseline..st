baseline
baseline: spec
	<baseline>
	spec for: #common do: [ 
		self voyage: spec.
		spec

		package: 'SCouchDB-Core' with: [ spec requires: #('SCouchDB-JSON' 'Voyage-Core') ];

		group: 'default' with: #('SCouchDB-Core');
		group: 'voyage' with: #(default 'SCouchDB-Voyage');
		group: 'viewserver' with: #(default voyage 'SCouchDB-ViewServer' )
	]
