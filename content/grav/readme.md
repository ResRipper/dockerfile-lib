<!--
 Copyright 2025 ResRipper.
 SPDX-License-Identifier: MIT
-->

# Grav + caddy

Grav is a Fast, Simple, and Flexible file-based Web-platform.

Make sure you created volumes for:

- /var/www/html/user
- /var/www/html/backup
- /var/www/html/logs

## Example docker-compose.yml

```yaml
services:
    grav:
        image: resripper/grav:latest
        restart: unless-stopped
        port:
            - 80:80
        volumes:
            - /.../user:/var/www/html/user
            - /.../backup:/var/www/html/backup
            - /.../logs:/var/www/html/logs
```