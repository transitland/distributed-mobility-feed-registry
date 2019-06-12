#!/usr/bin/env bash

npm install -g yarn
yarn install
rm -rf dist/
mkdir -p dist/
yarn run generate
cp -r ../examples dist/
cp -r ../json-schema dist/
