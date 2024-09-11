#FROM kdeneon/plasma
#FROM debian:11-slim
#FROM debian:12-slim
#FROM ubuntu:20.04
#FROM ubuntu:22.04
#FROM ubuntu:22.10
#FROM ubuntu:23.04
FROM fedora:40
#TODO: Arch
WORKDIR /scripts
#RUN apt-get update -y && apt-get install sudo -y  # for debian distros
RUN dnf install sudo -y                           # for fedora and its derivatives
COPY . .
CMD [ "sh", "install.sh" ]
