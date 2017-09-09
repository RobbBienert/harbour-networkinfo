/*
 * Host information
 *
 * Copyright (C) 2017 Robert Bienert <robertbienert@gmx.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "hostinfo.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <QVariantMap>

typedef unsigned char uchar;

// This function converts an unsigned integer number (hex system, d < 16)
// into its character representation.
char d2c(uchar d) {
	if (d < 10)
		return '0' + d;
	if (d < 16)
		return 'a' + d - 10;
	else return 'X';
}

// converts the family int into a QString description
QString afFamily(const int fam) {
	switch (fam) {
	case AF_INET:
		return "IPv4";
	case AF_INET6:
		return "IPv6";
	default:
		return "(unknown)";
	}
}

// converts the socket type int into a QString description
QString afSocketType(const int st) {
	switch (st) {
	case SOCK_DGRAM:
		return "UDP";
	case SOCK_STREAM:
		return "TCP";
	case SOCK_RAW:
		return "RAW";
	default:
		return QString::number(st);
	}
}

// The hostname and domainname are initialized in the constructor
// as we assume that they do not change during the apps lifetime.
HostInfo::HostInfo(QObject *parent) : QObject(parent)
{
	const size_t NameLen = 1024;
	char name[NameLen];	// should be enough for gethostname(2) and getdomainame(2)

	(void)gethostname(name, NameLen);
	_host = name;

	_domain = getdomainname(name, NameLen) == 0 ? name : "";
}

const QString HostInfo::hostname() const {
	return _host;
}

const QString HostInfo::domainname() const {
	return _domain;
}

// The principal idea to retrieve data using the getaddrinfo(3) function
// is taken from its manual page.
// The code to format the IPv4 and IPv6 addresses was developed by hex
// dumping the retrieved values in the ai_addr->sa_data field of the
// result structure.
QVariantList HostInfo::gethostbyname(const QString &name) {
	struct addrinfo *results, *r;
	QVariantList ips;
	QVariantMap ip;
	char ipv4[16];
	char *ipv6 = NULL;
	size_t sa_d_l, i, j = 0, k = 0, shift = 0;
	struct sockaddr_in6 *sin6;
	uchar digit;

	if (getaddrinfo(name.toUtf8().data(), NULL, NULL, &results) != 0)
		return ips;

	for (r = results; r != NULL; r = r->ai_next) {
		ip.insert("family", afFamily(r->ai_family));
		ip.insert("cn", r->ai_canonname);
		ip.insert("socktype", afSocketType(r->ai_socktype));

		if (r->ai_family == AF_INET) {
			snprintf(ipv4, sizeof(ipv4), "%i.%i.%i.%i",
					 (uchar)r->ai_addr->sa_data[2], (uchar)r->ai_addr->sa_data[3],
					 (uchar)r->ai_addr->sa_data[4], (uchar)r->ai_addr->sa_data[5]);
			ip.insert("addr", ipv4);
		}
		else if (r->ai_family == AF_INET6){
			sin6 = (struct sockaddr_in6*)r->ai_addr;

			sa_d_l = sizeof(sin6->sin6_addr.__in6_u);
			ipv6 = new char[2 * sa_d_l + 8];	// 7 ':' + 1 NULL
			ipv6[2*sa_d_l + 7] = '\0';

			for (i = 0; i < sa_d_l; ++i) {
				digit = (uchar)sin6->sin6_addr.__in6_u.__u6_addr8[i];

				if (i > 1 && i % 2 == 0) {
					ipv6[k+1] = ':';
					++shift;
				}
				if (j > 2*sa_d_l+7) break;	// TODO
				j = i * 2 + shift;
				k = j + 1;
				ipv6[j] = d2c(digit / 16);
				ipv6[k] = d2c(digit % 16);
			}

			ip.insert("addr", ipv6);
			delete[] ipv6;
		}
		ips.append(ip);
		ip.clear();
	}

	freeaddrinfo(results);

	return ips;
}
