as yet unclassified
initialize: size
	super initialize:size.
	events := OrderedCollection new.
	triggers:= OrderedCollection new.