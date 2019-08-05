#!/bin/sh
xdg-open http://localhost:18080/
docker run --rm -it -p 18080:80 jhipster/jdl-studio
