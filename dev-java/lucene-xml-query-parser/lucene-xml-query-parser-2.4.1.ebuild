# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
SLOT=2.4

LUCENE_MODULE_DEPS="queries"

inherit lucene-contrib

DESCRIPTION="XML Query Parser addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	lucene-contrib_src_install

	cd "${S}/contrib/${LUCENE_MODULE}"
	dohtml README.htm
}
