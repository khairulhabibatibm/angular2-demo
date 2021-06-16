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


FROM nginxinc/nginx-unprivileged 

USER root

#!/bin/sh

COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy from the stahg 1
COPY --from=builder /app-ui/dist /usr/share/nginx/html

## add permissions
RUN chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d

## switch to non-root user
USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]