# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source doc"

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
HOMEPAGE="http://maven.apache.org/"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEP="
dev-java/maven-artifact
dev-java/maven-build-context
dev-java/maven-profile
dev-java/maven-settings
dev-java/plexus-container-default
dev-java/plexus-component-api
>=dev-java/plexus-utils-1.4.7_pre20071021
dev-java/maven-model
dev-java/wagon-provider-api
dev-java/plexus-classworlds
"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
JAVA_MAVEN_CLASSPATH="
maven-model
maven-artifact
maven-build-context
maven-profile
maven-settings
plexus-component-api
plexus-classworlds
plexus-container-default
plexus-utils-1.4.7
wagon-provider-api
"

JAVA_PKG_SRC_DIRS="src/main/java/*"
#JAVA_MAVEN_PATCHES="${FILESDIR}/cp.patch"


