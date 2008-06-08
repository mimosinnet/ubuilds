# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

MY_P=${PN/gnu-/}-${PV}

DESCRIPTION="GNU JAXP, a free implementation of SAX parser API, DOM Level 2, Sun JAXP 1.1."
HOMEPAGE="http://www.gnu.org/software/classpathx/jaxp/"
SRC_URI="mirror://gnu/classpathx/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc source"

# Should work with 1.3 but did not test yet after migration to gen 2
RDEPEND="=virtual/jre-1.4*
		=dev-libs/libxml2-2*
		dev-libs/libxslt"
DEPEND="=virtual/jdk-1.4*
		${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf --disable-gcj || die "configure failed!"
	emake gnujaxp.jar $(use_doc) || die "compile failed!"
}

src_install() {
	java-pkg_newjar gnujaxp.jar jaxp.jar
	dodoc README
	use doc && java-pkg_dohtml -r apidoc/*
	use source && java-pkg_dosrc source/*
}
