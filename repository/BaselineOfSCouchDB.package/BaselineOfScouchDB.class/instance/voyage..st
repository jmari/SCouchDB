script
voyage: spec
	spec 
		baseline: 'Voyage' with: [ spec repository: 'github://pharo-nosql/voyage/mc' ];
		loads: #( 'Core' )