#!/bin/sh

# Prune, build and run docker
main() {
  docker container prune -f && echo "Removed old Docker containers"
  docker build -f ../Dockerfile -t dotfile-install-test:latest .. && echo "Docker build success"
  docker run -it dotfile-install-test:latest
}

main "$@"
