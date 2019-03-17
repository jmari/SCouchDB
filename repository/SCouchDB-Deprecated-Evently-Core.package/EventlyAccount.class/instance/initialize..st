as yet unclassified
initialize:size
	super initialize:size.

	self renderAccountEventOn:self.
	self renderLoggedinEventOn: self.
	self renderLoggedoutEventOn: self.
	self renderLoginFormEventOn:self.
	self renderSignUnFormEventOn:self.
	self renderItemsEventOn:self.
	self renderProfileEventOn:self
