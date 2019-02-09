# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:11-alpine as build-stage

# Setup work directory 
WORKDIR /app

# Copy over package.json for libraries 
COPY package*.json /app/

# install dependencies 
RUN npm install

# Copy src code 
COPY ./ /app/

# Build src code 
RUN npm run build

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15

# Copy webpack static build into nginx
COPY --from=build-stage /app/public /usr/share/nginx/html
COPY --from=build-stage /app/build /usr/share/nginx/html/build

# Expose port on docker
EXPOSE 80
