FROM alpine:latest
RUN apk update
RUN apk add hugo yarn make git

RUN mkdir -p /home/builder/build
WORKDIR /home/builder/build
COPY package.json /home/builder/build
COPY yarn.lock /home/builder/build
RUN yarn

COPY . /home/builder/build
CMD /bin/sh -c "git config --global --add safe.directory /home/builder/build && yarn && make serve-production"
EXPOSE 1313
