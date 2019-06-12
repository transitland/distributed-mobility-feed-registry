#!/usr/bin/env bash

(cd ui && yarn install && yarn run generate)
cp examples ui/dist/
cp json-schema ui/dist/
