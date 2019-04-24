FROM node:11-alpine
COPY ./app/.ssh ./
ENV APP_DIR=/app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR
RUN npm update -g npm 
COPY ./app/src ./src
COPY ./app/ormconfig.json ./
COPY ./app/package.json ./
COPY ./app/README.md ./
COPY ./app/tsconfig.json ./
RUN npm install && npm i express
EXPOSE 3000
EXPOSE 35729