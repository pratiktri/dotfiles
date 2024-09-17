#FROM kdeneon/plasma
FROM debian:11-slim
#FROM debian:12-slim
#FROM ubuntu:20.04
#FROM ubuntu:22.04
#FROM ubuntu:23.04
#FROM fedora:40
WORKDIR /dotfiles
RUN apt-get update && apt-get install sudo -y     # for debian distros
#RUN dnf install sudo -y                           # for fedora and its derivatives
COPY . .
CMD [ "sh", "setup.sh", "-i" ]
