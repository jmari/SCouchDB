protocol
groups: spec
	spec 
		group: 'default' with: #('SCouchDB-Core');
		group: 'voyage' with: #(default 'SCouchDB-Voyage');
		group: 'viewserver' with: #(default voyage 'SCouchDB-ViewServer' )