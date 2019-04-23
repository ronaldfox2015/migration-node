FROM node
ENV APP_DIR=/app

RUN mkdir $APP_DIR

WORKDIR $APP_DIR
COPY ./app/src ./src
COPY ./app/ormconfig.json ./
COPY ./app/package.json ./
COPY ./app/README.md ./
COPY ./app/tsconfig.json ./
RUN npm i express
RUN npm install

EXPOSE 3000

EXPOSE 35729