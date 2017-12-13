FROM ubuntu
ARG NODE_VERSION=4.4.7
ENV NETWORK=livenet
ENV INTERNAL_SERVICE=bitcoin-service.bitcoin-service
EXPOSE 3001
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y libzmq3-dev curl python git build-essential
ENV NVM_DIR /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN npm i -g bitcore-node
RUN npm install -g grunt-cli
WORKDIR /root
RUN bitcore-node create bitcoin-node
COPY bitcore-node.json /root/bitcoin-node/
WORKDIR /root/bitcoin-node
RUN bitcore-node install insight-ui insight-api web
RUN echo "maxconnections=50" >> /root/bitcoin-node/data/bitcoin.conf
ENTRYPOINT sed -i -- "s/livenet/${NETWORK}/g" /root/bitcoin-node/bitcore-node.json && \
    cd /root/bitcoin-node && bitcore-node start
