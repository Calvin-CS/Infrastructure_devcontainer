#!/bin/bash

# Note: this relies on Docker secrets to build, but that secret is not stored in Git.  This build script looks up one directory and down into a secrets subdir
# For github actions, should rely on the Github secrets stuff, adding each one seperately

docker build -t devcontainer:latest .
docker build -t devcontainer-cs10x:latest cs10x/.
docker build -t devcontainer-cs112:latest cs112/.
docker build -t devcontainer-cs212:latest cs212/.
docker build -t devcontainer-cs214:latest cs214/.
docker build -t devcontainer-cs262:latest cs262/.
docker build -t devcontainer-cs262:latest cs300/.