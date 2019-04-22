FROM node
ENV APP_DIR=/app

RUN mkdir $APP_DIR

WORKDIR $APP_DIR
RUN npm install -g ts-node
RUN npm install typeorm -g

RUN npm install typeorm --save

EXPOSE 3000

EXPOSE 35729