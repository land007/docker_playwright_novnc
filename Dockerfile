FROM land007/ubuntu-unity-novnc:22.04

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

# 更新包列表并安装必要软件
RUN apt-get update -y && apt-get install -y build-essential python3 python3-pip libxtst-dev libpng++-dev make g++ libenchant-2-2 ffmpeg psmisc && \
	apt-get clean

# 安装 Node.js 使用 NVM
ENV NVM_DIR=/home/.nvm
RUN mkdir /home/.nvm &&  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
#ADD install.sh /home
#RUN cd /home && chmod +x install.sh && ./install.sh
ENV SHIPPABLE_NODE_VERSION=v16.9.1
RUN echo 'export SHIPPABLE_NODE_VERSION=v16.9.1' >> /etc/profile && \
        . $NVM_DIR/nvm.sh && nvm ls-remote && \
        nvm install $SHIPPABLE_NODE_VERSION && \
        nvm alias default $SHIPPABLE_NODE_VERSION && \
        nvm use default &&  which node

# 配置环境变量
ENV PATH $PATH:/home/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin
RUN echo 'export PATH=$PATH:/home/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin' >> /etc/profile && \
    mkdir /home/.catche && ln -s /home/.catche /home/ubuntu/.catche && npm config set cache /home/.cache && \
    . $NVM_DIR/nvm.sh && cd /home && npm init -y && npm install -g node-gyp && \
    npm install socket.io socket.io-client ws express http-proxy bagpipe eventproxy \
    chokidar request nodemailer await-signal log4js moment cron playwright robotjs playwright-video
#RUN . $NVM_DIR/nvm.sh && cd /home && rm -rf node_modules && npm cache clean --force

# 安装 Playwright
RUN npx playwright install

# 复制文件到容器
ADD node /home/ubuntu
ENV FFMPEG_PATH /usr/bin/ffmpeg

#RUN pip3 install playwright
#RUN python3 -m playwright install

# 设置镜像元数据
RUN echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/playwright-novnc" >> /.image_names && \
	echo "land007/playwright-novnc" > /.image_name

#RUN apt-get install -y gawk bison
#RUN strings  /lib/aarch64-linux-gnu/libc.so.6 | grep GLIBC_
#ADD glibc-2.29.tar.gz /opt
#RUN cd /opt/glibc-2.29 && mkdir build && cd build && ../configure --prefix=/usr/local --disable-sanity-checks && make && make install
#RUN cp /usr/local/lib/libc-2.29.so /lib/aarch64-linux-gnu/ && cp /usr/local/lib/libm-2.29.so /lib/aarch64-linux-gnu/ && ln -sf /usr/local/lib/libc-2.29.so /lib/aarch64-linux-gnu/libc.so.6 && ln -sf /usr/local/lib/libm-2.29.so /lib/aarch64-linux-gnu/libm.so.6
#RUN strings  /lib/aarch64-linux-gnu/libc.so.6 | grep GLIBC_


#docker build -t land007/playwright-novnc:22.04 .
#> docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v7 -t land007/playwright-novnc:22.04 --push .
#> docker buildx build --platform linux/amd64,linux/arm64/v8 -t land007/playwright-novnc:20.04 --push .
#> docker pull --platform=arm64 land007/playwright-novnc:20.04
#sudo docker exec $CONTAINER_ID cat /home/ubuntu/password.txt
#docker rm -f playwright-novnc ; docker run -it -p 5901:5901 -p 6080:6080 -p 4040:4040 --privileged --name playwright-novnc land007/playwright-novnc:20.04
#docker rm -f playwright-novnc ; docker run -it -p 5901:5901 -p 6080:6080 -p 4040:4040 --privileged --name playwright-novnc docx.msa.gov.cn:5000/playwright-novnc:20.04
