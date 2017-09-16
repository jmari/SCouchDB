render-wrapper
redirectTo: anUrl
	| s |

	s := SCJsonObject new.
	s code:302.
	s body:'See other'.
	s headers: (SCJsonObject new Location:anUrl;yourself).
	^ s.
