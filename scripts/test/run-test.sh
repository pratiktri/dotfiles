#!/bin/sh

# Prune, build and run docker
main() {
    cd ../.. # change docker context to dotfile repo
    podman container prune -f && echo "Removed old Docker containers"
    podman build -t dotfile-setup:latest -f scripts/test/Dockerfile . && echo "Docker build success"
    podman run -it dotfile-setup:latest
}

main "$@"
