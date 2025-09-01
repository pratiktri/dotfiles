#FROM debian:12-slim
#FROM debian:13-slim
#FROM ubuntu:23.04
FROM ubuntu:24.04
#FROM fedora:42
WORKDIR /dotfiles
RUN apt-get update && apt-get --no-install-recommends install sudo -y
#RUN dnf install sudo -y                           # for fedora and its derivatives
COPY . .
CMD [ "sh", "setup.sh", "-i" ]
