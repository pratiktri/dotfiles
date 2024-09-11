#!/bin/sh

# Prune, build and run docker
main() {
    cd .. # change docker build context to 1 directory up
    docker container prune -f && echo "Removed old Docker containers"
    docker build -t dotfile-install-test:latest -f test/Dockerfile . && echo "Docker build success"
    docker run -it dotfile-install-test:latest
}

main "$@"
