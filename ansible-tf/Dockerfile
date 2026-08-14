FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    iproute2 \
    iputils-ping \
    vim \
    nano \
    screen \
    tcpdump \
    curl \
    python3 \
    python3-pip \
    less \
    sudo \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:alta3' | chpasswd

RUN useradd --create-home --shell /bin/bash student \
 && echo 'student:alta3' | chpasswd \
 && install -d -o student -g student /home/student/.ssh

RUN useradd --create-home --shell /bin/bash ubuntu \
 && echo 'ubuntu:alta3' | chpasswd \
 && adduser ubuntu sudo \
 && install -d -o ubuntu -g ubuntu /home/ubuntu/.ssh

RUN sed -i 's/#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
