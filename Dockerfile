FROM rust:1.62
RUN cargo install cargo-watch
RUN cargo install sqlx-cli
RUN rustup component add rustfmt
RUN apt-get update
RUN apt-get install -y build-essential git clang cmake libstdc++-10-dev libssl-dev libxxhash-dev zlib1g-dev pkg-config graphviz
RUN git clone https://github.com/rui314/mold.git && \
    cd mold && \
    git checkout v1.0.3 && \
    make -j$(nproc) CXX=clang++ && \
    make install && \
    cd .. && \
    rm -rf mold

RUN wget https://github.com/k0kubun/sqldef/releases/download/v0.11.35/mysqldef_linux_amd64.tar.gz -O - | tar xvzf - -C /usr/local/bin

RUN curl -sSL "https://raw.githubusercontent.com/CircleCI-Public/cimg-node/main/ALIASES" -o nodeAliases.txt && \
	NODE_VERSION=$(grep "lts" ./nodeAliases.txt | cut -d "=" -f 2-) && \
	curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
	tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
	rm node.tar.xz nodeAliases.txt && \
	ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV YARN_VERSION 1.22.18
RUN curl -L -o yarn.tar.gz "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" && \
	tar -xzf yarn.tar.gz -C /opt/ && \
	rm yarn.tar.gz && \
	ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
	ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg
