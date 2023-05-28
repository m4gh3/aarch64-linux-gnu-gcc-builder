FROM debian:experimental
RUN apt update && yes | apt install g++ make
ADD install.tar /usr/local
COPY gcc_wrap /usr/bin/gcc
COPY g++_wrap /usr/bin/g++
COPY aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc
COPY aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++
