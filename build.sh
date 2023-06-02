#!/bin/bash
set -e

docker build -t inkscape-build .
docker run --rm --mount type=bind,source="$(pwd)"/Inkscape/Inkscape/runtime,target=/dest inkscape-build
