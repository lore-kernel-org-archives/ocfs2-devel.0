From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Feb 10 18:07:37 2004
Subject: [Ocfs2-devel] Revision 30 fails to insmod
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A617802E@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Just did a sync with revision 30 from the repository.

It fails to insmod.

/lib/modules/2.4.22-1.2149.nptl/unsupported/fs/ocfs2.o: unresolved
symbol OCFS_SB_GET_KDEV

It looks like the latest revision removed the definition of
OCFS_SB_GET_KDEV in src/inc/ocfs.h but is still using the macro :(

John
