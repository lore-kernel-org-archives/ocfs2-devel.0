From: Jeff Mahoney <jeffm@suse.com>
Date: Mon Apr 16 11:08:01 2007
Subject: [Ocfs2-devel] [PATCH] enable building as SUSE KMP
Message-ID: <4623BB1C.30101@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Starting with SLE 10 and openSUSE 10.2, the "right" way of building kernel
modules for SUSE Linux systems is via the kernel module package (KMP) mechanism.

This automates much of what the scripts and specfiles do now in a standard manner,
building kernel modules for every installed kernel for which source can be found.

The attached patch changes the definition of "sles9" to mean "any release starting
with sles9 that doesn't support building KMPs. The only difference between the sles9
and suse-kmp vendor.guess is the logic on what to do if the suse_kernel_module_package
macro is found or not. SLES10 systems included the macro with the rpm package. Later
versions include the macro as part of the kernel-source package.

With the KMP infrastructure, if allowed, 'make packages' should work without even
running configure since it runs configure for each kernel it builds against.

This patch applies after the previous ones.

- -Jeff

diff -ruNp ocfs2-1.2.5.staging/configure.in ocfs2-1.2.5.devel/configure.in
- --- ocfs2-1.2.5.staging/configure.in	2007-04-16 13:10:02.715354028 -0400
+++ ocfs2-1.2.5.devel/configure.in	2007-04-16 12:56:51.301364243 -0400
@@ -292,4 +292,5 @@ vendor/ax2/ocfs2.spec-generic
 vendor/rhel4/ocfs2.spec-generic
 vendor/sles9/ocfs2.spec-generic
 vendor/rhel5/ocfs2.spec-generic
+vendor/suse-kmp/ocfs2.spec-generic
 ])
diff -ruNp ocfs2-1.2.5.staging/vendor/Makefile ocfs2-1.2.5.devel/vendor/Makefile
- --- ocfs2-1.2.5.staging/vendor/Makefile	2007-03-27 15:54:15.000000000 -0400
+++ ocfs2-1.2.5.devel/vendor/Makefile	2007-04-15 19:20:08.000000000 -0400
@@ -2,6 +2,6 @@ TOPDIR = ..
 
 include $(TOPDIR)/Preamble.make
 
- -SUBDIRS = ax2 rhel4 sles9 rhel5
+SUBDIRS = ax2 rhel4 sles9 rhel5 suse-kmp
 
 include $(TOPDIR)/Postamble.make
diff -ruNp ocfs2-1.2.5.staging/vendor/sles9/vendor.guess ocfs2-1.2.5.devel/vendor/sles9/vendor.guess
- --- ocfs2-1.2.5.staging/vendor/sles9/vendor.guess	2007-03-27 15:54:15.000000000 -0400
+++ ocfs2-1.2.5.devel/vendor/sles9/vendor.guess	2007-04-15 19:19:35.000000000 -0400
@@ -1,13 +1,22 @@
 #!/bin/sh
 
+# Test whether we can use kernel module packages or not
+
 if [ ! -f /etc/SuSE-release ]
 then
     exit 1
 fi
 
- -if [ "`rpm -qf /etc/SuSE-release --qf '%{VERSION}' 2>/dev/null`" != "9" ]
+SUSE_RELEASE="`rpm -qf /etc/SuSE-release --qf "%{VERSION}" 2> /dev/null`"
+
+if [ "$SUSE_RELEASE" -lt 9 ]; then
+	exit 1
+fi
+
+HAS_KMP="`rpm --showrc | grep suse_kernel_module_package 2> /dev/null`"
+if [ -n "$HAS_KMP" ]
 then
- -    exit 1
+   exit 1
 fi
 
 exit 0
diff -ruNp ocfs2-1.2.5.staging/vendor/suse-kmp/Makefile ocfs2-1.2.5.devel/vendor/suse-kmp/Makefile
- --- ocfs2-1.2.5.staging/vendor/suse-kmp/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ ocfs2-1.2.5.devel/vendor/suse-kmp/Makefile	2007-04-15 18:26:44.000000000 -0400
@@ -0,0 +1,11 @@
+TOPDIR = ../..
+
+include $(TOPDIR)/Preamble.make
+
+DIST_FILES = 			\
+	ocfs2.spec-generic.in	\
+	rpmarch.guess		\
+	Vendor.make		\
+	vendor.guess
+
+include $(TOPDIR)/Postamble.make
diff -ruNp ocfs2-1.2.5.staging/vendor/suse-kmp/ocfs2.spec-generic.in ocfs2-1.2.5.devel/vendor/suse-kmp/ocfs2.spec-generic.in
- --- ocfs2-1.2.5.staging/vendor/suse-kmp/ocfs2.spec-generic.in	1969-12-31 19:00:00.000000000 -0500
+++ ocfs2-1.2.5.devel/vendor/suse-kmp/ocfs2.spec-generic.in	2007-04-15 18:31:07.000000000 -0400
@@ -0,0 +1,57 @@
+Summary: The Oracle Cluster Filesystem 2 (ocfs2)
+Name: ocfs2
+Version: @DIST_VERSION@
+Release: @@PKG_VERSION@@
+License: GPL
+Group: System/Kernel
+Source: ocfs2-%{version}.tar.gz
+URL: http://oss.oracle.com/projects/ocfs2/
+Distribution: Oracle
+Vendor: Oracle
+Packager: Joel Becker <joel.becker@oracle.com>
+Provides: ocfs2 = %{version}
+AutoReqProv: no
+Requires: ocfs2-tools >= %{tools_ver}
+BuildRoot:      %{_tmppath}/%{name}-%{version}-build
+%suse_kernel_module_package -n ocfs2
+
+%description
+The Oracle Cluster Filesystem 2 (ocfs2) kernel modules.
+
+%package KMP
+Summary: The Oracle Cluster Filesystem 2 (ocfs2)
+Group: System/Kernel
+
+%description KMP
+The Oracle Cluster Filesystem 2 (ocfs2) kernel modules.
+
+%prep
+%setup
+set -- *
+mkdir source
+mv "$@" source/
+mkdir obj
+
+%build
+for flavor in %flavors_to_build; do
+	rm -rf obj/$flavor
+	cp -r source obj/$flavor
+	cd obj/$flavor
+	./configure --with-kernel-source=/usr/src/linux --with-kernel=/usr/src/linux-obj/%_target_cpu/$flavor
+	make
+	cd ../..
+done
+
+%install
+export INSTALL_MOD_PATH=$RPM_BUILD_ROOT
+export INSTALL_MOD_DIR=updates
+for flavor in %flavors_to_build; do
+	(cd obj/$flavor ; make install)
+done
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%changelog
+* Fri Apr 13 2007 - jeffm@suse.com
+- Initial version to use SUSE KMP infrastructure
diff -ruNp ocfs2-1.2.5.staging/vendor/suse-kmp/rpmarch.guess ocfs2-1.2.5.devel/vendor/suse-kmp/rpmarch.guess
- --- ocfs2-1.2.5.staging/vendor/suse-kmp/rpmarch.guess	1969-12-31 19:00:00.000000000 -0500
+++ ocfs2-1.2.5.devel/vendor/suse-kmp/rpmarch.guess	2007-04-13 13:05:42.000000000 -0400
@@ -0,0 +1,70 @@
+#! /bin/sh
+
+mode="$1"
+srcdir="$2"
+
+host_cpu=
+
+QUERYFILE=/etc/SuSE-release
+
+if test -n "$QUERYFILE"; then
+  host_cpu="`rpm -qf $QUERYFILE --queryformat \"%{ARCH}\"`"
+fi
+
+if test -z "$host_cpu" -o "$host_cpu" = "noarch" ; then
+  host_alias=`$srcdir/config.guess`
+  host=`$srcdir/config.sub $host_alias`
+  host_cpu=`echo $host | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\1/'`
+fi
+
+case "$host_cpu" in
+  x86_64|ia64|s390x)
+    TOOLSARCH="$host_cpu"
+    ;;
+  i386|i486|i586|i686|i786|k6|k7)
+    TOOLSARCH="i386"
+    ;;
+  ppc|ppc64|ppciseries|ppcpseries|ppc64iseries|ppc64pseries|powerpc|powerpc64)
+    TOOLSARCH="ppc64"
+    ;;
+  *)
+    echo "rpmarch.guess: Warning: unknown RPM CPU architecture: $host_cpu" >&2
+    TOOLSARCH=""
+    ;;
+esac
+
+# Only a few of these need to be overwritten from RPM's default
+case "$host_cpu" in
+  i586)
+    MODULEARCH="$host_cpu"
+    ;;
+  i386|i686)
+    MODULEARCH="i586"
+    ;;
+  ppc|ppc64|ppciseries|ppcpseries|ppc64iseries|ppc64pseries|powerpc|powerpc64)
+    MODULEARCH="ppc64"
+    ;;
+  *)
+    MODULEARCH=""
+    ;;
+esac
+
+case "$mode" in
+  module)
+    if [ -n "$MODULEARCH" ] ; then
+      echo "--target $MODULEARCH"
+    fi
+    ;;
+  tools)
+    if [ -n "$TOOLSARCH" ] ; then
+      echo "--target $TOOLSARCH"
+    fi
+    ;;
+  *)
+    echo "rpmarch.guess: Invalid mode: $mode" >&2
+    echo "error"
+    exit 1
+    ;;
+esac
+
+exit 0
diff -ruNp ocfs2-1.2.5.staging/vendor/suse-kmp/vendor.guess ocfs2-1.2.5.devel/vendor/suse-kmp/vendor.guess
- --- ocfs2-1.2.5.staging/vendor/suse-kmp/vendor.guess	1969-12-31 19:00:00.000000000 -0500
+++ ocfs2-1.2.5.devel/vendor/suse-kmp/vendor.guess	2007-04-15 19:19:46.000000000 -0400
@@ -0,0 +1,22 @@
+#!/bin/sh
+
+# Test whether we can use kernel module packages or not
+
+if [ ! -f /etc/SuSE-release ]
+then
+    exit 1
+fi
+
+SUSE_RELEASE="`rpm -qf /etc/SuSE-release --qf "%{VERSION}" 2> /dev/null`"
+
+if [ "$SUSE_RELEASE" -lt 9 ]; then
+	exit 1
+fi
+
+HAS_KMP="`rpm --showrc | grep suse_kernel_module_package 2> /dev/null`"
+if [ -z "$HAS_KMP" ]
+then
+   exit 1
+fi
+
+exit 0
diff -ruNp ocfs2-1.2.5.staging/vendor/suse-kmp/Vendor.make ocfs2-1.2.5.devel/vendor/suse-kmp/Vendor.make
- --- ocfs2-1.2.5.staging/vendor/suse-kmp/Vendor.make	1969-12-31 19:00:00.000000000 -0500
+++ ocfs2-1.2.5.devel/vendor/suse-kmp/Vendor.make	2007-04-15 18:32:06.000000000 -0400
@@ -0,0 +1,21 @@
+#
+# SUSE KMPs (SLE10+, 10.2+)
+#
+
+TOOLSARCH = $(shell $(TOPDIR)/vendor/suse-kmp/rpmarch.guess tools $(TOPDIR))
+MODULEARCH = $(shell $(TOPDIR)/vendor/suse-kmp/rpmarch.guess module $(TOPDIR))
+
+
+$(TOPDIR)/vendor/suse-kmp/ocfs2.spec: $(TOPDIR)/vendor/suse-kmp/ocfs2.spec-generic
+	SPECVER="$@"; \
+		SPECVER="$${SPECVER#*ocfs2-}"; \
+		SPECVER="$${SPECVER%.spec}"; \
+		sed -e 's/@DIST_VERSION@/'$(DIST_VERSION)'/' -e 's/@@PKG_VERSION@@/'$(PKG_VERSION)'/' < $< > $@
+
+srpm: dist $(TOPDIR)/vendor/suse-kmp/ocfs2.spec
+	rpmbuild -bs --define "_sourcedir $(TOPDIR)" --define "_srcrpmdir $(TOPDIR)" $(TOPDIR)/vendor/suse-kmp/ocfs2.spec
+
+rpms: srpm
+	rpmbuild --rebuild $(MODULEARCH) ocfs2-$(DIST_VERSION)-$(PKG_VERSION).src.rpm
+
+packages: rpms


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGI7sbLPWxlyuTD7IRAhkpAKCThFUYdddY/14hK0pOeWJmQ1xA8QCfYJUC
WMfXXc/bzpIEK+t2jvPVX/k=
=zT06
-----END PGP SIGNATURE-----
