private
parseRanges:ranges
	|rangeParts|

	rangeParts := ranges subStrings:$,.
	^ rangeParts collect:[:part| self parseMediaRange:part ].
	
