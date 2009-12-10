# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Multi-format schema converter based on RELAX NG"
HOMEPAGE="http://thaiopensource.com/relaxng/trang.html"
SRC_URI="http://jing-trang.googlecode.com/files/${P}.zip"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="
	dev-java/xerces:2
	dev-java/xml-commons-resolver:0"

RDEPEND="
	>=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.5
	${COMMON_DEP}"

java_prepare() {
	# need resource files in jar archive so can't remove, see build.xml
	# rm -v *.jar || die "Failed to remove jar archives"

	cp "${FILESDIR}/build.xml" "${S}/build.xml"
}

src_compile() {
	eant jar $(use_doc) \
		-Dclasspath="$(java-pkg_getjars xerces-2,xml-commons-resolver)"
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	java-pkg_dolauncher trang \
		--main com.thaiopensource.relaxng.translate.Driver
	dohtml *.html
	dodoc *.txt

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/{org,com}
}
