By default the changes feed emits all database documents changes. But if you’re waiting for some special changes, processing all documents is inefficient.

Filters are special design document functions that allow the changes feed to emit only specific documents that pass filter rules.

    Instance Variables
	serializer:		used to serialize to objects to JSON
	server:		SCViewServer processing this filter
	viewEmit:		true if a view calls emit:

View filters are the same as classic filters above, with one small difference: they use the map instead of the filter function of a view, to filter the changes feed. Each time a key-value pair is emitted from the map function, a change is returned. This allows avoiding filter functions that mostly do the same work as views.