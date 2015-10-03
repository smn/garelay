docker build -t garelay:0.1.3 . && docker run -it --rm=true -p 8000:8000 -e GARELAY_VERSION=0.1.3 -e GARELAY_SERVER=http://localhost:8000/server --name garelay garelay:0.1.3 $@
