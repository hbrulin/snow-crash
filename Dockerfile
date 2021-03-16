FROM alpine:latest


RUN apk update \
&& apk add --no-cache --upgrade bash \
&& apk add --no-cache openssl openssh \
&& apk add --no-cache make \
&& apk add --no-cache linux-headers \
&& apk add --no-cache texinfo \
&& apk add --no-cache gcc \
&& apk add --no-cache g++ \
&& apk add --no-cache tar \
&& apk add --no-cache xz \
&& apk add --no-cache gzip

RUN apk add --no-cache gdb
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache git
RUN apk add --no-cache wireshark

WORKDIR /root

#john
#RUN wget https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz
#RUN tar -xvf john-1.9.0-jumbo-1.tar.xz
#RUN rm john-1.9.0-jumbo-1.tar.xz
#RUN ./john-1.9.0-jumbo-1/src/configure 
#RUN mv john_build_rule.h john-1.9.0-jumbo-1/src/
#RUN cd john-1.9.0-jumbo-1/src/yescrypt && make -s
RUN git clone https://github.com/magnumripper/JohnTheRipper.git
WORKDIR JohnTheRipper/src
RUN ./configure && make clean && make -s

WORKDIR /root
RUN echo 'alias john="./JohnTheRipper/run/john"' >> ~/.bashrc

EXPOSE 8080:8080
EXPOSE 2200:22

#RUN ssh-keygen 

CMD ["/bin/bash"]