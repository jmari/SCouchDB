as yet unclassified
defaultAdaptor
	^ defaultAdaptor ifNil:[ SCError signal:'No adaptor in singleton mode']