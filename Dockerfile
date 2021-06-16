# stage1 as builder
FROM node:10-alpine as builder

# copy the package.json to install dependencies
COPY package.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /app-ui && mv ./node_modules ./app-ui

WORKDIR /app-ui

COPY . .

# Build the project and copy the files
RUN npm run ng build -- --deploy-url=/angular2-demo/ --prod


FROM nginx:alpine

#!/bin/sh

COPY ./nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /app-ui/dist /usr/share/nginx/html

EXPOSE 8080

# ENTRYPOINT ["nginx", "-g", "daemon off;"]