# Shadowsocks-rust + V2Ray-plugin

[Shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust) with V2ray plugin maintained by [Teddy SUN](https://github.com/teddysun/v2ray-plugin)

- Base: `ghcr.io/shadowsocks/ssserver-rust`

## Usage

```
docker run \
    --name ss-server \
    -e LISTEN=0.0.0.0:80
    -e ENCRYPT=chacha20-ietf-poly1305 \
    -e PASSWD=password \
    -e PLUGIN=v2ray-plugin \
    -e PLUGIN_OPT=server \
    -p 80:80 \
    resripper/shadowsocks-rust:latest
```