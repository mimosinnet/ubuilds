# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-5.5-r4.ebuild,v 1.1 2007/01/28 19:40:16 fordfrog Exp $

EAPI=1
WANT_SPLIT_ANT="true"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="NetBeans IDE for Java"
HOMEPAGE="http://www.netbeans.org"

SLOT="6.5"
MY_PV=${PV}
SRC_URI="http://download.netbeans.org/netbeans/6.5/beta/zip/netbeans-6.5beta-200808111757-src.zip"

LICENSE="CDDL"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE_NETBEANS="apisupport cnd groovy gsf harness ide identity j2ee java mobility nb php profiler ruby soa uml visualweb webcommon websvccommon xml"
IUSE="+apisupport cnd debug doc groovy gsf +harness +ide identity j2ee +java mobility +nb php profiler ruby soa uml visualweb webcommon websvccommon xml linguas_ja linguas_pt_BR linguas_zh_CN"

RDEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.7.1_beta2"

DEPEND="=virtual/jdk-1.5*
	app-arch/unzip
	>=dev-java/ant-core-1.7.1_beta2
	>=dev-java/ant-nodeps-1.7.1
	>=dev-java/javahelp-2:0
	>=dev-java/jna-3:0
	dev-java/jsr223:0
	>=dev-java/junit-4:4
	>=dev-java/swing-layout-1:1
	ide? (
		>=dev-java/commons-logging-1.1:0
		>=dev-java/commons-net-1.4:0
		>=dev-java/flyingsaucer-7:0
		>=dev-java/freemarker-2.3.8:2.3
		>=dev-java/ini4j-0.2.6:0
		>=dev-java/jakarta-oro-2:2.0
		>=dev-java/javacc-3.2:0
		>=dev-java/jaxb-2:2
		>=dev-java/jaxb-tools-2:2
		>=dev-java/jdbc-mysql-5.1:0
		>=dev-java/jdbc-postgresql-8.3_p603:0
		>=dev-java/jsch-0.1.24:0
		dev-java/jsr173:0
		>=dev-java/lucene-2.2:2
		dev-java/sun-jaf:0
		~dev-java/tomcat-servlet-api-3:2.2
		>=dev-java/xerces-2.8.1:2
	)"

S="${WORKDIR}"
BUILDDESTINATION="${S}/nbbuild/netbeans"
ENTERPRISE="5"
IDE_VERSION="10"
PLATFORM="9"
MY_FDIR="${FILESDIR}/${SLOT}"
DESTINATION="/usr/share/netbeans-${SLOT}"
JAVA_PKG_BSFIX="off"

pkg_setup() {
	if use doc ; then
		ewarn "Currently building with 'doc' USE flag fails, see bugs http://www.netbeans.org/issues/show_bug.cgi?id=109722 http://www.netbeans.org/issues/show_bug.cgi?id=107510"
	fi

	if use apisupport && ! ( use harness && use ide && use java ) ; then
		eerror "'apisupport' USE flag requires 'harness', 'ide' and 'java' USE flags"
		exit 1
	fi

	if use cnd && ! use ide ; then
		eerror "'cnd' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use groovy && ! (use gsf && use ide && use java) ; then
		eerror "'groovy' USE flag requires 'gsf', 'ide' and 'java'"
		exit 1
	fi

	if use gsf && ! use ide ; then
		eerror "'gsf' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use identity && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'identity' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use j2ee && ! ( use groovy && use gsf && use ide && use java ) ; then
		eerror "'j2ee' USE flag requires 'groovy', 'gsf', 'ide' and 'java' USE flags"
		exit 1
	fi

	if use java && ! ( use ide && use websvccommon ) ; then
		eerror "'java' USE flag requires 'ide' and 'websvccommon' USE flag"
		exit 1
	fi

	if use mobility && ! ( use ide && use java ) ; then
		eerror "'mobility' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use nb && ! use ide ; then
		eerror "'nb' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use php && ! ( use gsf && use ide && use websvccommon ) ; then
		eerror "'php' USE flag requires 'gsf', 'ide' and 'websvccommon' USE flags"
		exit 1
	fi

	if use profiler && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'profiler' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use ruby && ! ( use gsf && use ide ) ; then
		eerror "'ruby' USE flag requires 'gsf' and 'ide' USE flag"
		exit 1
	fi

	if use soa && ! ( use gsf && use ide && use j2ee && use java && use xml ) ; then
		eerror "'soa' USE flag requires 'gsf', 'ide', 'j2ee', 'java' and 'xml' USE flags"
		exit 1
	fi

	if use uml && ! ( use ide && use java ) ; then
		eerror "'uml' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use visualweb && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'visualweb' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use webcommon && ! ( use gsf && use ide ) ; then
		eerror "'webcommon' USE flag requires 'gsf' and 'ide' USE flags"
		exit 1
	fi

	if use websvccommon && ! use ide ; then
		eerror "'websvccommon' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use xml && ! use ide ; then
		eerror "'xml' USE flag requires 'ide' USE flag"
		exit 1
	fi

	java-pkg-2_pkg_setup
}

src_unpack () {
	unpack ${A}

	# Clean up nbbuild
	einfo "Removing prebuilt *.class files from nbbuild"
	find "${S}" -name "*.class" -delete

	place_unpack_symlinks

	# We do not remove jars that we are not able to replace atm
	if [ -n "${JAVA_PKG_NB_REMOVE_BUNDLED}" ] ; then
		einfo "Removing rest of the bundled jars..."
		find "${S}" -type f -name "*.jar" | grep -v "tomcat-webserver-3.2.jar" | \
			grep -v "svnClientAdapter-1.4.0.jar" | grep -v "resolver-1.2.jar" | \
			grep -v "svnjavahl-1.5.0.jar" | grep -v "jaxb-xjc.jar" | \
			grep -v "jaxb-impl.jar" | grep -v "javac-api-nb-7.0-b07.jar" | xargs rm -v
	fi
}

src_compile() {
	local antflags="-Dstop.when.broken.modules=true"

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	local clusters="-Dnb.clusters.list=nb.cluster.platform"
	use apisupport && clusters="${clusters},nb.cluster.apisupport"
	use cnd && clusters="${clusters},nb.cluster.cnd"
	use groovy && clusters="${clusters},nb.cluster.groovy"
	use gsf && clusters="${clusters},nb.cluster.gsf"
	use harness && clusters="${clusters},nb.cluster.harness"
	use ide && clusters="${clusters},nb.cluster.ide"
	use identity && clusters="${clusters},nb.cluster.identity"
	use j2ee && clusters="${clusters},nb.cluster.j2ee"
	use java && clusters="${clusters},nb.cluster.java"
	use mobility && clusters="${clusters},nb.cluster.mobility"
	use nb && clusters="${clusters},nb.cluster.nb"
	use php && clusters="${clusters},nb.cluster.php"
	use profiler && clusters="${clusters},nb.cluster.profiler"
	use ruby && clusters="${clusters},nb.cluster.ruby"
	use soa && clusters="${clusters},nb.cluster.soa"
	use uml && clusters="${clusters},nb.cluster.uml"
	use webcommon && clusters="${clusters},nb.cluster.webcommon"
	use websvccommon && clusters="${clusters},nb.cluster.websvccommon"
	use xml && clusters="${clusters},nb.cluster.xml"

	# Fails to compile
	java-pkg_filter-compiler ecj-3.1 ecj-3.2

	# Build the clusters
	use ruby && addpredict /root/.jruby
	ANT_TASKS="ant-nodeps"
	#use cnd && ANT_TASKS="${ANT_TASKS} antlr-netbeans-cnd"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${antflags} ${clusters} -f nbbuild/build.xml build-nozip

	use linguas_de && compile_locale_support "${antflags}" "${clusters}" de
	use linguas_es && compile_locale_support "${antflags}" "${clusters}" es
	use linguas_ja && compile_locale_support "${antflags}" "${clusters}" ja
	use linguas_pt_BR && compile_locale_support "${antflags}" "${clusters}" pt_BR
	use linguas_sq && compile_locale_support "${antflags}" "${clusters}" sq
	use linguas_zh_CN && compile_locale_support "${antflags}" "${clusters}" zh_CN

	# Running build-javadoc from the same command line as build-nozip doesn't work
	# so we must run it separately
	if use doc ; then
		#! use testtools && ANT_TASKS="${ANT_TASKS} ant-trax"
		ANT_OPTS="-Xmx1g" eant ${antflags} ${clusters} build-javadoc
	fi

	# Remove non-Linux binaries
	find ${BUILDDESTINATION} -type f \
		-name "*.exe" -o \
		-name "*.cmd" -o \
		-name "*.bat" -o \
		-name "*.dll"	  \
		| xargs rm -f

	# Removing external stuff. They are api docs from external libs.
	rm -f ${BUILDDESTINATION}/ide${IDE_VERSION}/docs/*.zip

	# Remove zip files from generated javadocs.
	rm -f ${BUILDDESTINATION}/javadoc/*.zip

	# Use the system ant
	if use ide ; then
		cd ${BUILDDESTINATION}/java2/ant || die "Cannot cd to ${BUILDDESTINATION}/ide${IDE_VERSION}/ant"
		rm -fr lib
		rm -fr bin
	fi

	# Set initial default jdk
	if [[ -e ${BUILDDESTINATION}/etc/netbeans.conf ]]; then
		echo "netbeans_jdkhome=\"\$(java-config -O)\"" >> ${BUILDDESTINATION}/etc/netbeans.conf
	fi

	# Install Gentoo Netbeans ID
	echo "NBGNT" > ${BUILDDESTINATION}/nb${SLOT}/config/productid || die "Could not set Gentoo Netbeans ID"

	# fix paths per bug# 163483
	if [[ -e ${BUILDDESTINATION}/bin/netbeans ]]; then
		sed -i -e 's:"$progdir"/../etc/:/etc/netbeans-6.5/:' ${BUILDDESTINATION}/bin/netbeans
		sed -i -e 's:"${userdir}"/etc/:/etc/netbeans-6.5/:' ${BUILDDESTINATION}/bin/netbeans
	fi
}

src_install() {
	insinto ${DESTINATION}

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	# Remove the build helper files
	rm -f "${D}"/${DESTINATION}/nb.cluster.*
	rm -f "${D}"/${DESTINATION}/*.built
	rm -f "${D}"/${DESTINATION}/moduleCluster.properties
	rm -f "${D}"/${DESTINATION}/module_tracking.xml
	rm -f "${D}"/${DESTINATION}/build_info

	# Change location of etc files
	if [[ -e ${BUILDDESTINATION}/etc ]]; then
		insinto /etc/${PN}-${SLOT}
		doins ${BUILDDESTINATION}/etc/*
		rm -fr "${D}"/${DESTINATION}/etc
		dosym /etc/${PN}-${SLOT} ${DESTINATION}/etc
	fi

	# Replace bundled jars with system jars - currently commented out
	symlink_extjars

	# Correct permissions on executables
	local nbexec_exe="${DESTINATION}/platform${PLATFORM}/lib/nbexec"
	fperms 775 ${nbexec_exe} || die "Cannot update perms on ${nbexec_exe}"
	if [[ -e "${D}"/${DESTINATION}/bin/netbeans ]] ; then
		local netbeans_exe="${DESTINATION}/bin/netbeans"
		fperms 755 ${netbeans_exe} || die "Cannot update perms on ${netbeans_exe}"
	fi
	if use ruby ; then
		local ruby_path="${DESTINATION}/ruby2/jruby-1.1/bin"
		cd "${D}"/${ruby_path} || die "Cannot cd to ${D}/${ruby_path}"
		for file in * ; do
			fperms 755 ${ruby_path}/${file} || die "Cannot update perms on ${ruby_path}/${file}"
		done
	fi

	# Link netbeans executable from bin
	if [[ -f "${D}"/${DESTINATION}/bin/netbeans ]]; then
		dosym ${DESTINATION}/bin/netbeans /usr/bin/${PN}-${SLOT}
	else
		dosym ${DESTINATION}/platform7/lib/nbexec /usr/bin/${PN}-${SLOT}
	fi

	# Ant installation
	if use java ; then
		local ANTDIR="${DESTINATION}/java2/ant"
		dosym /usr/share/ant/lib ${ANTDIR}/lib
		dosym /usr/share/ant-core/bin ${ANTDIR}/bin
	fi

	# Documentation
	einfo "Installing Documentation..."

	cd "${D}"/${DESTINATION}
	dohtml CREDITS.html README.html netbeans.css
	rm -f build_info CREDITS.html README.html netbeans.css

	use doc && java-pkg_dojavadoc "${S}"/nbbuild/build/javadoc

	# Icons and shortcuts
	if use nb ; then
		einfo "Installing icon..."
		dodir /usr/share/icons/hicolor/32x32/apps
		dosym ${DESTINATION}/nb${SLOT}/netbeans.png /usr/share/icons/hicolor/32x32/apps/netbeans-${SLOT}.png

	fi

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans-${SLOT}.png Development
}

pkg_postinst() {
	einfo "If you want to use specific locale of netbeans, use --locale argument, for example:"
	einfo "${PN}-${SLOT} --locale de"
	einfo "${PN}-${SLOT} --locale pt:BR"
}

pkg_postrm() {
	if ! test -e /usr/bin/netbeans-${SLOT}; then
		elog "Because of the way Portage works at the moment"
		elog "symlinks to the system jars are left to:"
		elog "${DESTINATION}"
		elog "If you are uninstalling Netbeans you can safely"
		elog "remove everything in this directory"
	fi
}

# Supporting functions for this ebuild

place_unpack_symlinks() {
	local target=""

	einfo "Symlinking compilation-time jars"

	dosymcompilejar "javahelp/external" javahelp jh.jar jh-2.0_05.jar
	dosymcompilejar "o.jdesktop.layout/external" swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar
	dosymcompilejar "libs.jna/external" jna jna.jar jna-3.0.2.jar
	dosymcompilejar "libs.jsr223/external" jsr223 script-api.jar jsr223-api.jar
	dosymcompilejar "libs.junit4/external" junit-4 junit.jar junit-4.1.jar

	if use ide ; then
		dosymcompilejar "apisupport.harness/external" javahelp jhall.jar jsearch-2.0_05.jar
		dosymcompilejar "db.drivers/external" jdbc-postgresql jdbc-postgresql.jar postgresql-8.3-603.jdbc3.jar
		dosymcompilejar "db.drivers/external" jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.5-bin.jar
		dosymcompilejar "db.sql.visualeditor/external" javacc javacc.jar javacc-3.2.jar
		dosymcompilejar "servletapi/external" tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
		dosymcompilejar "libs.commons_logging/external" commons-logging commons-logging.jar commons-logging-1.1.jar
		dosymcompilejar "libs.jakarta_oro/external" jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
		dosymcompilejar "libs.commons_net/external" commons-net commons-net.jar commons-net-1.4.1.jar
		dosymcompilejar "libs.freemarker/external" freemarker-2.3 freemarker.jar freemarker-2.3.8.jar
		dosymcompilejar "libs.ini4j/external" ini4j ini4j.jar ini4j-0.2.6.jar
		dosymcompilejar "libs.jaxb/external" jsr173 jsr173.jar jsr173_api.jar
		dosymcompilejar "libs.jaxb/external" jaxb-2 jaxb-api.jar jaxb-api.jar
		dosymcompilejar "libs.jaxb/external" sun-jaf activation.jar activation.jar
		#dosymcompilejar "libs.jaxb/external" jaxb-2 jaxb-impl.jar jaxb-impl.jar
		#dosymcompilejar "libs.jaxb/external" jaxb-tools-2 jaxb-tools.jar jaxb-xjc.jar
		#dosymcompilejar "o.apache.xml.resolver/external" xml-commons resolver.jar resolver-1.2.jar
		dosymcompilejar "libs.jsch/external" jsch jsch.jar jsch-0.1.24.jar
		dosymcompilejar "libs.lucene/external" lucene-2 lucene-core.jar lucene-core-2.2.0.jar
		# svnClientAdapter
		# svnjavahl
		dosymcompilejar "libs.xerces/external" xerces-2 xercesImpl.jar xerces-2.8.0.jar
		dosymcompilejar "web.flyingsaucer/external" flyingsaucer core-renderer.jar core-renderer-R7final.jar
	fi

	if [ -n "${NB_DOSYMCOMPILEJARFAILED}" ] ; then
		die "Some compilation-time jars could not be symlinked"
	fi
}

symlink_extjars() {
	local targetdir=""

	einfo "Symlinking runtime jars"

	targetdir="platform${PLATFORM}/modules/ext"
	dosyminstjar ${targetdir} javahelp jh.jar jh-2.0_05.jar
	dosyminstjar ${targetdir} jna jna.jar jna-3.0.2.jar
	dosyminstjar ${targetdir} jsr223 script-api.jar script-api.jar
	dosyminstjar ${targetdir} junit-4 junit.jar junit-4.1.jar
	dosyminstjar ${targetdir} swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar

	#if use ide ; then
	#fi

	if [ -n "${NB_DOSYMINSTJARFAILED}" ] ; then
		die "Some runtime jars could not be symlinked"
	fi
}

dosymcompilejar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file="${4}"

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${S}/${dest}/${target_file}"
		if [ -e "${target}" ] ; then
			java-pkg_jar-from --build-only --into "${S}"/${dest} ${package} ${jar_file} ${target_file}
		else
			ewarn "Target jar does not exist so will not create link: ${target}"
			NB_DOSYMCOMPILEJARFAILED="1"
		fi
	fi
}

dosyminstjar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file=""
		if [ -z "${4}" ]; then
			target_file="${3}"
		else
			target_file="${4}"
		fi

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${DESTINATION}/${dest}/${target_file}"
		if [ -e "${D}/${target}" ] ; then
			dosym /usr/share/${package}/lib/${jar_file} ${target}
		else
			ewarn "Target jar does not exist so will not create link: ${D}/${target}"
			NB_DOSYMINSTJARFAILED="1"
		fi
	fi
}

# Compiles locale support
# Arguments
# 1 - ant flags
# 2 - clusters
# 3 - locale
compile_locale_support() {
	einfo "Compiling support for '${3}' locale"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${1} ${2} -Dlocales=${3} build-nozip-ml
}
