From: Zach Brown <zach.brown@oracle.com>
Date: Thu Oct  7 23:03:11 2004
Subject: [Ocfs2-devel] configure.in makes baby Zach cry
Message-ID: <4165C3EB.4060605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

if test "x$rhkernel" = "xyes"; then
  if test "$OCFS_PROCESSOR" = "i686"; then
    KVER=up
  else
    KVER=smp

What's that trying to do?  It gets in my way when building against the
running smp kernel on a dual athlon running FC1.
