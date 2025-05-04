FROM golang:latest AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o ollama-proxy


FROM scratch
LABEL author="Joseph Glanville"
LABEL org.opencontainers.image.source="https://github.com/josephglanville/ollama-groq-proxy"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/ollama-proxy /ollama-proxy

EXPOSE 8080
ENTRYPOINT ["/ollama-proxy"]
