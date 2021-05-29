ARG COMPILER_VERSION="1.16.4"

FROM golang:${COMPILER_VERSION} AS builder

WORKDIR /build

COPY . .

RUN  CGO_ENABLED=0 \
     go build \
       -a \
       -installsuffix cgo \
       -ldflags '-extldflags "-static"' \
       -o gearforce-web


FROM scratch AS release

LABEL author="Edward Carmack"

WORKDIR /srv

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder build/gearforce-web .

EXPOSE 80 443

ENTRYPOINT ["./gearforce-web"]

FROM release
