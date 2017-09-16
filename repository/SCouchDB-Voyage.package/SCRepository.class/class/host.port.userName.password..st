as yet unclassified
host: aHost port: aPort userName:aUserName password:aPassword
	| repo |
	repo := self new.
	repo adaptor: (SCAdaptor new host: aHost port: aPort userName:aUserName password:aPassword).
	^ repo