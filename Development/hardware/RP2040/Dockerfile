FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ResRipper/Dockerfile-LIB"
LABEL org.opencontainers.image.description='RP2040 DEV'
LABEL org.opencontainers.image.licenses='MIT'

# Install requirements
RUN apt update; \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    make cmake gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib gcc g++ python3 python3-tk wget git libusb-1.0-0 xz-utils; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /var/pico /root/projects
RUN if [ "$(uname -p)" = "aarch64" ]; then wget -O /usr/bin/picotool https://github.com/ResRipper/picotool/releases/latest/download/picotool-linux-arm64 && chmod +x /usr/bin/picotool; fi; \
    if [ "$(uname -p)" =  "x86_64" ]; then wget -O /usr/bin/picotool https://github.com/ResRipper/picotool/releases/latest/download/picotool-linux-x64   && chmod +x /usr/bin/picotool; fi

# Get pico SDK & examples
RUN git clone -b master https://github.com/raspberrypi/pico-sdk.git /var/pico/pico-sdk && cd /var/pico/pico-sdk && git submodule update --init; \
    git clone -b master https://github.com/raspberrypi/pico-examples.git /var/pico/pico-examples; \
    git clone -b master https://github.com/raspberrypi/pico-project-generator.git /root/pico-project-generator

ENV PICO_SDK_PATH=/var/pico/pico-sdk

WORKDIR /root/projects
ENTRYPOINT [ "/bin/bash" ]