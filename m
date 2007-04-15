From: Jeff Mahoney <jeffm@suse.com>
Date: Sun Apr 15 14:33:57 2007
Subject: [Ocfs2-devel] [PATCH] Fix configure script to allow split
	build/source directories
Message-ID: <462299BC.2040003@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi all -

The SUSE kernel module packages allow you to generate RPMs for all
installed kernels with one run of rpmbuild. This involves the use
of one shared source tree at /usr/src/linux and a group of build
trees rooted at /usr/src/linux-obj. The build trees contain the bare
minimum needed for a kernel tree to be considered "configured."

With the current configure script, it's looking in the
- --with-kernel-source directory for a configured kernel when it should
be looking in the directory provided by --with-kernel. When I specify 

./configure --with-kernel=/usr/src/linux-obj/x86_64/smp \
            --with-kernel-source=/usr/src/linux

it fails, since /usr/src/linux doesn't contain a configured kernel. I
used KERNELBUILD, rather than just switching KERNELINC, because other
tests (like the one for generic_drop_inode being exported) actually
need to look at the full includes for the kernel.

- -Jeff

diff -ruNpX dontdiff scratch/trees/ocfs2-1.2/configure.in ocfs2-1.2.5.devel/configure.in
- --- scratch/trees/ocfs2-1.2/configure.in	2007-03-27 16:22:52.000000000 -0400
+++ ocfs2-1.2.5.devel/configure.in	2007-04-15 17:13:49.000000000 -0400
@@ -108,13 +108,14 @@ AC_ARG_WITH(kernel-source, [  --with-ker
 AC_MSG_RESULT($kernelsourcedir)
 
 KERNELSRC="$kernelsourcedir"
+KERNELBUILD="$kerneldir"
 KERNELINC="$KERNELSRC/include"
 
- -if test ! -f "$KERNELINC/linux/autoconf.h"; then
+if test ! -f "$KERNELBUILD/include/linux/autoconf.h"; then
   AC_MSG_ERROR(No configured kernel include tree found)
 fi
 
- -OCFS2_CHECK_KVER($KERNELINC, ksourceversion, "source")
+OCFS2_CHECK_KVER("$KERNELBUILD/include", ksourceversion, "source")
 
 
 if test "$kversion" != "$ksourceversion"; then

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGIpm8LPWxlyuTD7IRAiREAJsFwIFRQSjHJpMXvLwgJscY4P4YLgCgk2WO
RShRPt128+gS/2rQXmIRVv8=
=Kdxy
-----END PGP SIGNATURE-----
