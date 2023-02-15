# syntax=docker/dockerfile:1-labs
FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ResRipper/Dockerfile-LIB"
LABEL org.opencontainers.image.description='RP2040 DEV'
LABEL org.opencontainers.image.licenses='MIT'

# Install requirements
RUN apt update && apt upgrade -y && \
    apt install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential python3 python3-pip wget git
RUN wget https://github.com/ResRipper/picotool/releases/download/v1.1.1/picotool-linux-x64 && chmod +x picotool-linux-x64 && \
    mv picotool-linux-x64 /usr/bin/picotool

# Get pico SDK & examples
RUN mkdir -p /var/pico /root/projects
ADD --keep-git-dir=true https://github.com/raspberrypi/pico-sdk.git#master /var/pico/pico-sdk
WORKDIR /var/pico/pico-sdk
RUN git submodule update --init
ADD --keep-git-dir=true https://github.com/raspberrypi/pico-examples.git#master /var/pico/pico-examples

# Get pico project generator
ADD --keep-git-dir=true https://github.com/raspberrypi/pico-project-generator.git#master /root/pico-project-generator

ENV PICO_SDK_PATH=/var/pico/pico-sdk

WORKDIR /root/projects
ENTRYPOINT [ "/bin/bash" ]