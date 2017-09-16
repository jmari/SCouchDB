nodes
mustacheAt: templateName put: aTemplateInAString partials: dictionaryOfPartials
	"imports a Mustache  template "

	self templates at: templateName put: aTemplateInAString.
	self partials addAll: dictionaryOfPartials.
