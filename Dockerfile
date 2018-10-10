FROM ubuntu
ARG NODE_VERSION=8.12.0
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
RUN ln -s $(which node) /usr/bin/nodejs
RUN npm install -g grunt-cli
RUN npm install -g yarn
RUN mkdir /bitcore/ && groupadd -r bitcore && useradd --no-log-init -r -g bitcore bitcore && chown -R bitcore:bitcore /bitcore && chown -R bitcore:bitcore /home/ 
USER bitcore
WORKDIR /bitcore
RUN git clone https://github.com/michailbrynard/bitcore.git
WORKDIR /bitcore/bitcore/
RUN yarn
WORKDIR /bitcore
COPY bitcore-node.json /bitcore/bitcoin-node/
COPY bitcoin.conf /bitcore/bitcoin-node/data/bitcoin.conf
WORKDIR /bitcore/bitcoin


ENTRYPOINT sed -i -- "s/livenet/${NETWORK}/g" /bitcore/bitcoin-node/bitcore-node.json && \
    cd /bitcore/bitcoin-node && /bitcore/bitcore/bin/bitcore start