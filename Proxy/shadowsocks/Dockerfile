FROM ubuntu:latest AS middle

RUN apt update && apt install -y wget xz-utils

ARG V2RAY_VER=5.17.0

RUN if [ "$(uname -p)" = "aarch64" ]; \
    then \
        wget -O v2ray-plugin.tar.gz https://github.com/teddysun/v2ray-plugin/releases/download/v"$V2RAY_VER"/v2ray-plugin-linux-arm64-v"$V2RAY_VER".tar.gz; \
        tar -xf v2ray-plugin.tar.gz && rm v2ray-plugin.tar.gz; \
        mv v2ray-plugin_linux_arm64 /usr/local/bin/v2ray-plugin; \
    fi

RUN if [ "$(uname -p)" = "x86_64" ]; \
    then \
        wget -O v2ray-plugin.tar.gz https://github.com/teddysun/v2ray-plugin/releases/download/v"$V2RAY_VER"/v2ray-plugin-linux-amd64-v"$V2RAY_VER".tar.gz; \
        tar -xf v2ray-plugin.tar.gz && rm v2ray-plugin.tar.gz; \
        mv v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin; \
    fi

FROM ghcr.io/shadowsocks/ssserver-rust:v1.21.2 AS server

LABEL org.opencontainers.image.source="https://github.com/ResRipper/Dockerfile-LIB"
LABEL org.opencontainers.image.description='shadowsocks-rust + v2ray'

COPY --from=middle /usr/local/bin/v2ray-plugin /usr/local/bin/v2ray-plugin

ENTRYPOINT ssserver -s ${LISTEN} -m ${ENCRYPT} -k ${PASSWD} --plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPT}
