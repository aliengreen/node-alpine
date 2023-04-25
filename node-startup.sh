#!/bin/sh

cd $HOME_DIR

npm install --no-package-lock  --legacy-peer-deps --no-fund

npm run start
