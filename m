From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Tue Feb  3 19:03:29 2004
Subject: [Ocfs2-devel] invalidate: busy buffer
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E01A3827E@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-
>bounces@oss.oracle.com] On Behalf Of Villalovos, John L
>Sent: Tuesday, February 03, 2004 4:39 PM
>To: ocfs2-users@oss.oracle.com; ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] invalidate: busy buffer
>
>Playing with revision 19 from Subversion of OCFS2.
>
>It appears that when I create and then delete directories I will get
the
>following error message when I unmount the partition:
>
>invalidate: busy buffer
>...
>invalidate: busy buffer
>
>
>Has anyone else seen this?
>
>John

Yes, I am also seeing this on a 2.4.22 kernel.  The warning is coming
from fs/buffer.c:invalidate_bdev().  Looks like we are not putting all
of the bh's before cleanup.

    --rusty
