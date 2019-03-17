as yet unclassified
host: aHost port: aPort 
	| repo |
	repo := self new.
	repo adaptor: (SCAdaptor new host: aHost port: aPort ).
	^ repo