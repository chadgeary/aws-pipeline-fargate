FROM ubuntu:bionic
EXPOSE 53/tcp
EXPOSE 53/udp
RUN apt-get update && apt-get install -y wget && \
    wget https://github.com/cloudflare/cloudflared/releases/download/2021.2.1/cloudflared-linux-amd64 --directory-prefix=/usr/local/bin/ && \
    chmod 555 /usr/local/bin/cloudflared-linux-amd64
ENTRYPOINT ["/usr/local/bin/cloudflared-linux-amd64", "proxy-dns", "--address", "0.0.0.0", "--port", "53", "--upstream", "https://cloudflare-dns.com/dns-query"]
