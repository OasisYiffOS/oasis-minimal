docker run --rm -it \
    -v .:/workspace \
    --workdir /workspace \
    debian:latest \
    bash -c "apt-get update && apt-get install -y wget xz-utils libcurl4-openssl-dev && chmod +x make-root-inner.sh && ./make-root-inner.sh"
