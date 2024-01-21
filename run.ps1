$env:LIB="${env:LIB};C:\Crystal\glades\dlls"
$env:PATH="${env:PATH};C:\Crystal\glades\dlls"
crystal tool format
shards run glades -- -m ./rsrc/testmap.dmap