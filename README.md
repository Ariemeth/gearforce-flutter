# gearforce

This is a project to learn flutter.  The goal is to produce an application to build army lists for the Heavy Gear miniature game.


This project is a starting point for a Flutter application.

More info about Heavy gear can be found at [Dream Pod 9's](www.dp9.com) website.

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
