# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaxb-tools/jaxb-tools-2.1.2.ebuild,v 1.4 2007/08/19 18:40:18 wltjr Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification."
HOMEPAGE="http://jaxb.dev.java.net/"
DATE="20070711"
MY_P="JAXB2_src_${DATE}"
SRC_URI="https://jaxb.dev.java.net/${PV}/${MY_P}.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="=dev-java/codemodel-2*
	dev-java/iso-relax
	>=dev-java/istack-commons-runtime-20070711
	>=dev-java/istack-commons-tools-20070711
	=dev-java/jaxb-${PV}
	dev-java/jsr173
	dev-java/msv
	dev-java/relaxng-datatype
	dev-java/rngom
	dev-java/sun-dtdparser
	dev-java/sun-jaf
	dev-java/txw2-runtime
	dev-java/xml-commons-resolver
	dev-java/xsdlib
	dev-java/xsom"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri-${DATE}"

src_unpack() {

	cd "${WORKDIR}"
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom --build-only ant-core
	java-pkg_jarfrom codemodel-2
	java-pkg_jarfrom iso-relax
	java-pkg_jarfrom istack-commons-runtime
	java-pkg_jarfrom istack-commons-tools
	java-pkg_jarfrom jaxb-2
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom msv
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom rngom
	java-pkg_jarfrom sun-dtdparser
	java-pkg_jarfrom sun-jaf
	java-pkg_jarfrom txw2-runtime
	java-pkg_jarfrom xml-commons-resolver
	java-pkg_jarfrom xsdlib
	java-pkg_jarfrom xsom
	ln -s $(java-config --tools) || die

	cd "${S}/src/com/sun/"
	rm -rf codemodel # in dev-java/codemodel
	rm -rf xml # in dev-java/jaxb

	cd "${S}"
	# Their build.xml does not do everything we want
	cp -v "${FILESDIR}/build.xml-${PV}" build.xml || die "cp failed"

	find src -name '*.java' -exec \
		sed -i \
			-e 's,com.sun.org.apache.xml.internal.resolver,org.apache.xml.resolver,g' \
			{} \;

}

src_install() {
	java-pkg_dojar jaxb-tools.jar
	java-pkg_dolauncher "xjc-${SLOT}" \
		--main com.sun.tools.xjc.Driver

	use source && java-pkg_dosrc src/*

}
