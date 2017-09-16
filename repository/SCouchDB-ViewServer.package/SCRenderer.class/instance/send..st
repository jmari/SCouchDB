public
send: chunk
	"pushes a chunk, it will be sended each time you get a row with getRow or al the end of the List blok execution in #runList"
	chunks push: chunk asString