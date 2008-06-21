# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Java API for XML Processing (JAXP)"
HOMEPAGE="https://jaxp.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cp -i "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"
}

EANT_DOC_TARGET=""

src_install() {

	java-pkg_newjar jaxp-ri.jar ${PN}.jar

	use source && java-pkg_dosrc jaxp-1_4-api/src/{javax,org}
	java-pkg_dohtml \
		docs/JAXP-Compatibility.html \
		docs/ReleaseNotes.html || die
	use doc && java-pkg_dojavadoc docs/api

}