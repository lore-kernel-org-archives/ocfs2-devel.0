From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 10 18:28:29 2004
Subject: [Ocfs2-devel] Revision 30 fails to insmod
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A617802E@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A617802E@orsmsx403.jf.intel.com>
Message-ID: <20040211002621.GA16362@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2004 at 04:07:26PM -0800, Villalovos, John L wrote:
> Just did a sync with revision 30 from the repository.
> 
> It fails to insmod.
> 
> /lib/modules/2.4.22-1.2149.nptl/unsupported/fs/ocfs2.o: unresolved
> symbol OCFS_SB_GET_KDEV
> 
> It looks like the latest revision removed the definition of
> OCFS_SB_GET_KDEV in src/inc/ocfs.h but is still using the macro :(

Here is a fix

    --rusty

Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 30)
+++ src/inc/ocfs.h	(working copy)
@@ -1107,7 +1107,7 @@
 typedef long sector_t;
 #define map_bh(bh, sb, blk)   \
 	({ \
-	 	bh->b_dev = OCFS_SB_GET_KDEV(sb); \
+	 	bh->b_dev = sb->s_dev; \
 		bh->b_blocknr = blk; \
 		bh->b_state |= (1UL << BH_Mapped); \
 	})
