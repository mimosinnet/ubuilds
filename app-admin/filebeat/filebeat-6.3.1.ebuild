# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/go-1.9.2"
RDEPEND="!app-admin/filebeat-bin"

S="${WORKDIR}/src/github.com/elastic/beats"

src_unpack() {
	mkdir -p "${S%/*}" || die
	default
	mv beats-${PV} "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}" emake -C "${S}/filebeat"
}

src_install() {
	keepdir /var/{lib,log}/${PN}
	keepdir /etc/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd.1" ${PN}

	docinto examples
	dodoc ${PN}/{filebeat.yml,filebeat.reference.yml}

	dobin ${PN}/${PN}
	insinto /etc/${PN}
	doins -r ${PN}/modules.d
	doins ${PN}/{${PN}.yml,${PN}.reference.yml}
	
	find ${PN}/module -type d -name test -exec rm -r {} ';'
	insinto /usr/share/${PN}
	doins -r ${PN}/module
	dosym /usr/share/${PN}/module /etc/${PN}/module
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "Please read the migration guide at:"
		elog "https://www.elastic.co/guide/en/beats/libbeat/$(ver_cut 1-2)/upgrading.html"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT%/}/usr/share/doc/${PF}/examples"
}