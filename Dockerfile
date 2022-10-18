FROM arm64v8/debian:bookworm

RUN echo 'deb-src http://deb.debian.org/debian bookworm main' >> /etc/apt/sources.list
RUN echo 'deb-src http://deb.debian.org/debian-security bookworm-security main' >> /etc/apt/sources.list
RUN echo 'deb-src http://deb.debian.org/debian bookworm-updates main' >> /etc/apt/sources.list
RUN apt update

RUN apt -y upgrade
RUN apt -y install vim-nox git

RUN apt -y build-dep mesa

RUN mkdir /root/mesa
COPY rockchip_ebc.patch /root/mesa/
COPY compile.sh /root/mesa/

# WORKDIR /root/mesa
# CMD /root/mesa/compile.sh

ENTRYPOINT /root/mesa/compile.sh
