#!/bin/bash
set -e

docker build -t inkscape-build .
docker run -it --rm --mount type=bind,source="$(pwd)"/Inkscape/Inkscape,target=/dest inkscape-build