FROM debian:experimental
COPY qemu-aarch64-static /usr/bin/
RUN [ "/usr/bin/qemu-aarch64-static", "/bin/sh", "-c", "mv /bin/sh /bin/sh.real" ]
COPY sh /bin/sh
COPY sh /bin/sh-shim
RUN apt update && yes | apt install g++ make
ADD install.tar /usr/local
COPY gcc_wrap /usr/bin/gcc
COPY g++_wrap /usr/bin/g++
COPY aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc
COPY aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++
