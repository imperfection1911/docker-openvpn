FROM debian:jessie
RUN apt-get update && \
    apt-get install -y openvpn iptables curl bash openvpn-auth-ldap && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
RUN mkdir -p /usr/local/share/easy-rsa && \
    curl -L https://github.com/OpenVPN/easy-rsa/archive/v3.0.0.tar.gz | tar xzf - --strip=1 -C /usr/local/share/easy-rsa easy-rsa-3.0.0/easyrsa3 && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

# Prevents refused client connection because of an expired CRL
ENV EASYRSA_CRL_DAYS 3650
VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
