# FROM node:20-alpine3.17
FROM node:20-alpine3.17
MAINTAINER Alien Green LLC

ENV REFRESHED_AT 2023-04-26_1257
ENV HOME_DIR=/opt/app  
ENV BIN_DIR=/opt/bin

RUN mkdir -p $BIN_DIR && mkdir -p $HOME_DIR && cd $HOME_DIR
ADD node-startup.sh $BIN_DIR
RUN chmod +x $BIN_DIR/node-startup.sh

RUN npm install -g npm 
RUN npm install -g nodemon

ENTRYPOINT $BIN_DIR/node-startup.sh 
