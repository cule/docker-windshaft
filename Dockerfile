FROM ubuntu:precise
MAINTAINER TerraSeer

# stop apt-get from complaining
ENV DEBIAN_FRONTEND noninteractive

# update packages
RUN apt-get update

# install system dependencies
RUN apt-get install -qq \
  curl \
  g++ \
  git \
  libpq-dev \
  make

# install windshaft dependencies
RUN apt-get install -qq \
  libcairo2-dev \
  libcairo2-dev \
  libgif-dev \
  libgif-dev \
  libjpeg8-dev \
  libjpeg8-dev \
  libpango1.0-dev \
  pkg-config

# install postgresql
RUN curl https://alioth.debian.org/scm/loggerhead/pkg-postgresql/postgresql-common/trunk/download/head:/apt.postgresql.org.s-20130224224205-px3qyst90b3xp8zj-1/apt.postgresql.org.sh | bash
RUN apt-get install -qq \
  postgis \
  postgresql-9.3 \
  postgresql-server-dev-9.3

# install redis
RUN apt-get install -qq redis-server

# install node
RUN curl -sL https://deb.nodesource.com/setup | bash
RUN apt-get install -qq nodejs

# create directory for docker
RUN mkdir /docker
WORKDIR /docker

# install windshaft
RUN npm install windshaft@0.42.2

# install testing dependencies
RUN apt-get install -qq imagemagick
WORKDIR /docker/node_modules/windshaft
# install devDependencies without installing each dependency's devDependencies
RUN npm install $(node -e "var d = require('./package.json').devDependencies; for (var key in d)  { console.log(key + '@' + d[key]) }")

# test windshaft
CMD npm test
