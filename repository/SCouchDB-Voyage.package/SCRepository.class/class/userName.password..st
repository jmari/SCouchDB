as yet unclassified
userName:aUserName password:aPassword
	| repo |
	repo := self new.
	repo adaptor: (SCAdaptor new host: self defaultHost  port: self defaultPort  userName:aUserName password:aPassword).
	^ repo