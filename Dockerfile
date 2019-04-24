FROM node:10.15.3-alpine

WORKDIR /app

RUN apk update && \
  apk add git && \
  git clone https://github.com/Giveth/giveth-bot . && \
  rm constants.js && \
  apk del git

RUN npm i

ENTRYPOINT ["node", "index"]
