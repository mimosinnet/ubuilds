# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit base versionator

DESCRIPTION="a high-speed network authentication cracking tool"
HOMEPAGE="http://nmap.org/ncrack/"
SRC_URI="http://nmap.org/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssh ssl"

RDEPEND="ssl? ( dev-libs/openssl )
	ssh? ( net-misc/openssh )"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG docs/{AUTHORS,TODO,{devguide,mirror_pool,ncrack\.usage,openssh-library}.txt} )


src_prepare() {
	sed -i -e '/STRIP =/s:= .*:= echo:' Makefile.in || die
}

src_configure() {
	econf --with-openssl=$(use ssl && echo yes || echo no) \
		--with-openssh=$(use ssh && echo yes || echo no)
}

src_install() {
	base_src_install
	doman docs/${PN}.1 || die "doman failed"
}
