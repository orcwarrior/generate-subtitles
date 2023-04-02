FROM debian:bullseye

RUN apt update && apt install nginx git ffmpeg software-properties-common python curl python3 python3.9 python3-pip python3.9-distutils python3.9-dev pkg-config libicu-dev lsof nano -y
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1000
RUN pip3 install setuptools-rust
RUN pip3 install --upgrade setuptools
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN alias pip=pip3
RUN alias python=python3.9
RUN pip3 install --upgrade setuptools
RUN pip3 install git+https://github.com/openai/whisper.git
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 16.19.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN . $HOME/.nvm/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION && nvm use default && npm install -g http-server pm2
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp  # Make executable
RUN git clone https://github.com/mayeaux/generate-subtitles
ENV LIBRETRANSLATE http://127.0.0.1:3000
ENV CONCURRENT_AMOUNT 2
ENV NODE_ENV production
ENV UPLOAD_FILE_SIZE_LIMIT_IN_MB 10000
WORKDIR 'generate-subtitles'
RUN npm install
EXPOSE 3000
CMD npm start
