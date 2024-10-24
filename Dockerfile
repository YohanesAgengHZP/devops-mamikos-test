##Create a base image for production
## here we use alpine for lightweight image
FROM node:18.20-bullseye AS build-stage

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# production stage, using nginx to serve the application
FROM nginx:stable-alpine AS production-stage

COPY --from=build-stage /app/docs /usr/share/nginx/html/vue-snake-game

COPY ./nginx/default-prod.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]