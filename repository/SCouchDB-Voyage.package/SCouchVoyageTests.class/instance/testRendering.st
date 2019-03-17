as yet unclassified
testRendering

	| cosa |
	cosa:= [ :each|( each name = 'john') & (each orders > 10) ] asMangoQuery.
	
	cosa inspect