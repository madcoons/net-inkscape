#!/bin/bash
set -e

docker build -t inkscape-prepare inkscape-prepare
docker run --rm --mount type=bind,source="$(pwd)"/Inkscape/Inkscape/runtime,target=/dest inkscape-prepare
