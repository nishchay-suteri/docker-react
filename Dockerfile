# Multi-step Docker build
# since we just need the build directory, there is no point of copying everything else(Eg. node_modules) to the intermediate containers.
# So, we'll use multi-step docker build

# Step-1. Build Phase

FROM node:alpine

WORKDIR /usr/app

COPY ./package.json ./
RUN npm install

COPY ./ ./
RUN npm run build

# /usr/app/build <---- all the stuff we care about

# Step-2. Run phase

FROM nginx

COPY --from=0 /usr/app/build /usr/share/nginx/html

# Only copy build directory from Build phase.
# --from=0 indicates the first phase. All phases are indexed starting from 0. Each phase starts with `FROM <baseimage>` command
# For serving static contents using nginx, we need to put these static contents inside /usr/share/nginx/html (as per the mginx docs, we can check this in dockerhub -> nginx)
# For nginx, no need for startup command. It automatically starts.
# docker run -p <local_computer_port>:80 <image_id>
# => Default port for nginx is 80
