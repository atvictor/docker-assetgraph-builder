FROM debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl make g++ libcairo2-dev libgif-dev optipng pngcrush pngquant libpango1.0-dev graphicsmagick libjpeg-progs inkscape libvips-dev libgsf-1-dev && rm -rf /var/lib/apt/lists/*

RUN set -ex && for key in 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D ; do gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; done

ENV NODE_VERSION 0.12.7
ENV NPM_VERSION 2.13.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && gpg --verify SHASUMS256.txt.asc && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc && npm install -g npm@"$NPM_VERSION" && npm cache clear

RUN npm install -g assetgraph-builder

RUN npm install -g less

ENTRYPOINT ["/usr/local/bin/buildProduction"]
