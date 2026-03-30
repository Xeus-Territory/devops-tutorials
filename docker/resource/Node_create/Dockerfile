FROM alpine:3.21

WORKDIR /app

# Get the require package
RUN apk add -U curl bash ca-certificates openssl ncurses coreutils python3 make gcc g++ libgcc linux-headers grep util-linux binutils findutils git zip

# Create a folder for storage nvm
RUN mkdir /usr/local/nvm

# Init version for pass through parameter by command
ARG version=${verison}

# Show what version is apply
RUN echo ${version}

# export env for install nvm
ENV NVM_DIR /usr/local/nvm

ENV NODE_VERSION ${version}

#### Runable but path for export have smt wrong !! ####
#======================================================================================
# Install nvm with node and npm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
#     && . $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default

# ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
# ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
#======================================================================================

# Check the version input and apply package for specically option 12 or 14
RUN if [[ ${version} == "12" ]]; then apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.12/main/ nodejs=12.22.12-r0 npm=12.22.12-r0; else apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.14/main/ nodejs=14.20.1-r0 npm; fi

# check the node and npm install into that one
RUN node --version
RUN npm --version