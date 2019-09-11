# Openvpn with LDAP in docker

based on kylemanna/docker-openvpn.

#### Links
* Docker Registry @ [imperfection/openvpn](https://hub.docker.com/r/imperfection/openvpn/)

## Usage

* Initialize docker volume for configuration files and certificates
  	docker volume create --name OVPN_DATA
* Create config and certs. -L param creates config with ldap support
	docker run -v OVPN_DATA:/etc/openvpn --log-driver=none --rm imperfection/openvpn ovpn_genconfig -L -u udp://VPN.EXAMPLE.LOCAL
	docker run -v OVPN_DATA:/etc/openvpn --log-driver=none --rm -it imperfection/openvpn ovpn_initpki
* Create ldap config
	docker run -v OVPN_DATA:/etc/openvpn --log-driver=none --rm imperfection/openvpn ovpn_genldapconfig -u ipa.example.local -b uid=ldapuser,cn=users,cn=accounts,dc=example,dc=local -p ldappassword -d "dc=example,dc=local"
* Start openvpn container
	docker run -v OVPN_DATA:/etc/openvpn -v /etc/hosts:/etc/hosts -d -p 1196:1194/udp --cap-add=NET_ADMIN --name openvpn_ldap imperfection/openvpn
* Generate client certificates
	docker run -v OVPN_DATA:/etc/openvpn --log-driver=none --rm -it imperfection/openvpn easyrsa build-client-full aaksenov nopass
	docker run -v OVPN_DATA:/etc/openvpn --log-driver=none --rm imperfection/openvpn ovpn_getclient aaksenov > aaksenov.ovpn

