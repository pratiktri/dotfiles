#!/bin/sh

# Prune, build and run docker
main() {
    cd ../.. # change docker context to dotfile repo
    docker container prune -f && echo "Removed old Docker containers"
    docker build -t dotfile-setup:latest -f scripts/test/Dockerfile . && echo "Docker build success"
    docker run -it dotfile-setup:latest
}

main "$@"
