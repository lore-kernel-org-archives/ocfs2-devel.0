From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Tue Feb 10 18:14:13 2004
Subject: [Ocfs2-devel] RE: Revision 30 fails to insmod
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E01A382A0@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yea, that would be my fault.  Let me get a fix together

>-----Original Message-----
>From: Villalovos, John L
>Sent: Tuesday, February 10, 2004 4:07 PM
>To: ocfs2-devel@oss.oracle.com
>Cc: Lynch, Rusty
>Subject: Revision 30 fails to insmod
>
>Just did a sync with revision 30 from the repository.
>
>It fails to insmod.
>
>/lib/modules/2.4.22-1.2149.nptl/unsupported/fs/ocfs2.o: unresolved
symbol
>OCFS_SB_GET_KDEV
>
>It looks like the latest revision removed the definition of
>OCFS_SB_GET_KDEV in src/inc/ocfs.h but is still using the macro :(
>
>John
