FROM centos:6.9
LABEL maintainer="jamesl.lin@paymark.co.nz"

ADD squid.repo /etc/yum.repos.d/squid.repo
RUN yum install -y epel-release perl-Crypt-OpenSSL-X509 && yum install -y squid squid-helpers && mkdir -p /etc/squid/ssl_cert && chown squid:squid /etc/squid/ssl_cert
#RUN openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 -extensions v3_ca -keyout /etc/squid/ssl_cert/proxyCA.key -out /etc/squid/ssl_cert/proxyCA.crt -subj "/C=NZ/L=AKL/O=Paymark/OU=IT/CN=proxyCA"
ADD proxyCA* /etc/squid/ssl_cert/
ADD proxyCA.crt /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust enable && update-ca-trust extract
RUN /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db
ADD squid.conf /etc/squid/squid.conf
EXPOSE 3128/tcp
CMD ["squid", "-NsY"]
