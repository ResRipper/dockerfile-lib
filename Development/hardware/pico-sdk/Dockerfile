# ------------ picotool ------------

FROM ubuntu:24.04 AS picotool_builder

ARG SDK_VER="2.1.0"

# Install requirements
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    build-essential ca-certificates cmake git libusb-1.0-0-dev pkg-config \
    && apt clean

# Clone pico SDK repo
RUN mkdir -p /var/pico \
    && git clone --depth 1 -b ${SDK_VER} https://github.com/raspberrypi/pico-sdk.git /var/pico/pico-sdk \
    && cd /var/pico/pico-sdk \
    && git submodule update --init

# Clone picotool repo
RUN git clone --depth 1 -b ${SDK_VER} https://github.com/raspberrypi/picotool.git /var/pico/picotool

# Set environment variables
ENV PICO_SDK_PATH=/var/pico/pico-sdk

WORKDIR /var/pico/picotool

# Build
RUN mkdir build \
    && cd build \
    && cmake .. \
    && make install

# ------------ PICO SDK ------------

FROM ubuntu:24.04

# Install requirements
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    build-essential ca-certificates cmake g++ gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib \
    && apt clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/pico

# Copy pico SDK repo
COPY --from=picotool_builder /var/pico/pico-sdk /var/pico/pico-sdk

# Copy picotool binary
COPY --from=picotool_builder /usr/local/bin/picotool /usr/local/bin/picotool

# Set environment variables
ENV PICO_SDK_PATH=/var/pico/pico-sdk

WORKDIR /

ENTRYPOINT [ "/bin/bash" ]