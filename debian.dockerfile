FROM debian:buster-slim
ENV DIRPATH /tmp/installdir

# Install basic packages and add user "admin" with password "lyzeng+521"
RUN useradd -m -s /bin/bash admin \
    && echo 'admin:lyzeng+521' | chpasswd

# Update package sources and install required packages
RUN echo 'deb http://mirrors.aliyun.com/debian/ buster main non-free contrib\n\
    deb http://mirrors.aliyun.com/debian-security buster/updates main\n\
    deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\n\
    deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian-security buster/updates main\n\
    deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\n\
    deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\n\
    ' > /etc/apt/sources.list \
    && apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install sudo bash nano procps tini python3-pip openssh-server \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/* \
    && echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
