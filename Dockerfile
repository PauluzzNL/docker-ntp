FROM centos:latest

# install openntp
COPY assets/ntpdate-4.2.6p5-28.el7.centos.x86_64.rpm /tmp/ntpd.rpm
COPY assets/ntp-4.2.6p5-28.el7.centos.x86_64.rpm /tmp/ntp.rpm
RUN yum -y install libedit autogen-libopts

# TODO: Import Centos6 keys so the packages can still be verified
RUN rpm --install /tmp/ntpd.rpm
RUN rpm --install /tmp/ntp.rpm

# use custom ntpd config file
COPY assets/ntpd.conf /etc/ntp.conf

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD ntpctl -s status || exit 1

# start ntpd in the foreground
ENTRYPOINT [ "/usr/sbin/ntpd", "-d" ]
