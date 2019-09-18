FROM alpine:latest
RUN apk add hugo yarn make

RUN adduser builder -D
USER builder

RUN mkdir -p /home/builder/build
WORKDIR /home/builder/build
COPY package.json /home/builder/build
RUN yarn

COPY . /home/builder/build
CMD /bin/sh -c "yarn && make serve-production"
EXPOSE 1313