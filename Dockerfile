FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    libssl-dev \
    libkrb5-dev \
    libpam0g-dev \
    libcppunit-dev \
    libldap2-dev \
    libdb-dev \
    libnetfilter-conntrack-dev \
    libexpat1-dev \
    libcap2-dev \
    libgnutls28-dev \
    libmariadb-dev \
    libxml2-dev \
    libcppunit-dev \
    perl \
    libltdl-dev \
    git \
    pkg-config \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Download and compile Squid
WORKDIR /tmp
RUN wget http://www.squid-cache.org/Versions/v6/squid-6.10.tar.gz && \
    tar -xzf squid-6.10.tar.gz && \
    cd squid-6.10 && \
    ./configure --prefix=/usr --libexecdir=/usr/lib/squid --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc/squid --with-openssl --enable-ssl-crtd --enable-ssl --enable-ssl-bump && \
    make && \
    make install

# Create necessary directories for Squid
RUN mkdir -p /var/spool/squid /var/log/squid /etc/squid/ssl_cert && \
    chown -R nobody:nogroup /var/spool/squid /var/log/squid /etc/squid/ssl_cert


# Expose Squid port
EXPOSE 3128

# Run Squid
CMD ["squid", "-N", "-d", "1"]
