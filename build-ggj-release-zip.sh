#!/bin/bash

./build.sh

rm hack-to-the-root-ggj2023.zip

mkdir -p ggj-release/src
cp -r -- * ggj-release/src/

(
	cd ggj-release/ || exit

	mv src/dist/ release

	mkdir press
	cp src/assets/screenshots/*.png press/

	zip -r ../hack-to-the-root-ggj2022.zip .
)

rm -r ggj-release/
