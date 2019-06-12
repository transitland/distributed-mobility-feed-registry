#!/usr/bin/env bash

npm install -g yarn
(cd ui && yarn install && yarn run generate)
cp examples ui/dist/
cp json-schema ui/dist/
