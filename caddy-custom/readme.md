# Caddy-custom

Caddy with plugins built-in:

- [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
- [mholt/caddy-l4](https://github.com/mholt/caddy-l4)
- [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)
- [fvbommel/caddy-combine-ip-ranges](https://github.com/fvbommel/caddy-combine-ip-ranges)
- [xcaddyplugins/caddy-trusted-gcp-cloudcdn](https://github.com/xcaddyplugins/caddy-trusted-gcp-cloudcdn)
- [xcaddyplugins/caddy-trusted-cloudfront](https://github.com/xcaddyplugins/caddy-trusted-cloudfront)
- [WeidiDeng/caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip)
- [monobilisim/caddy-ip-list](https://github.com/monobilisim/caddy-ip-list)

## Example

- `caddy.docker-compose.yml`

    ```yaml
    name: caddy
    services:
        caddy:
            image: resripper/caddy-custom:2.10.2
            restart: unless-stopped
            labels:
                # Trusted proxies
                caddy.servers.trusted_proxies: combine
                ## Private IPs
                caddy.servers.trusted_proxies.private_ranges:
                ## Traffic from Cloudflare
                caddy.servers.trusted_proxies.cloudflare.interval: 24h
                caddy.servers.trusted_proxies.cloudflare.timeout: 15s

                # Specify client IP header
                caddy.servers.trusted_proxies_strict:
                caddy.servers.client_ip_headers: CF-Connecting-IP X-Forwarded-For X-Real-IP
                
                # Specify DNS challenge provider 
                caddy.acme_dns: cloudflare {env.CF_API_TOKEN}
            environment:
                CADDY_INGRESS_NETWORKS: reverse_proxy
                CF_API_TOKEN: <Cloudflare API token>
            volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - caddy_data:/data

                # For Nextcloud FPM
                # Add labels below into Nextcloud's compose file:
                # caddy.file_server:
                # caddy.root: "* /var/www/html"
                - /.../nextcloud/data:/var/www/html:z,ro
                
            ports:
                - 80:80
                - 443:443/tcp
                - 443:443/udp
            networks:
                - reverse_proxy

    volumes:
        caddy_data:

    networks:
        reverse_proxy:
            name: reverse_proxy
            external: true
    ```

- `service.docker-compose.yml`

    ```yaml
    name: web
    services:
        web:
            image: ...
            labels:
                caddy: <Host name>
                caddy.encode: zstd gzip
                caddy.reverse_proxy: "{{upstreams <web service port>}}"
                ...
    ```