# gearforce

Gearforce is a program to help build unit rosters for the game Heavy Gear Blitz.

More info about Heavy gear can be found at [Dream Pod 9's](www.dp9.com) website.

## Building

To build the web server
```bash
DOCKER_BUILDKIT=1 \
  docker buildx build \
    --load \
    --platform linux/amd64 \
    -f Dockerfile \
    --target "release" \
    -t edwardcarmack/gearforce-web:0.0.1 \
    .

```
