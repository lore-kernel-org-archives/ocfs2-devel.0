From: Sonic Zhang <sonic.zhang@intel.com>
Date: Thu Mar 18 03:29:03 2004
Subject: [Ocfs2-devel] A patch to fix bug 45 in bugzilla
Message-ID: <40596BF0.8020807@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I think I found the root cause of the bug 45 in the bugzilla.

Actually, it is not an OCFS bug. It is caused in the Linux journaling
routine(JBD) journal_create(). In kernel 2.6.x, buffer_head state
BH_Uptodate is checked in mark_buffer_dirty(), while kernel 2.4.x
doesn't do. If this state doesn't exist in the buffer_head, buffer error
information is reported. But, in routine journal_create(), the state
BH_Uptodate is set after the call to mark_buffer_dirty(). This works 
well in kernel 2.4.x, but fails in kernel 2.6.x.

I attach a patch to fix this bug in kernel 2.6.x. Could you please put it 
into the subfolder "patches" in ocfs2 source tree?

Thank you.

---------------------------------------
--- linux-2.6.1.old/fs/jbd/journal.c	2004-03-18 15:55:47.591428104 +0800
+++ linux-2.6.1/fs/jbd/journal.c	2004-03-18 15:56:25.609648456 +0800
@@ -832,10 +832,10 @@
 		bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
 		lock_buffer(bh);
 		memset (bh->b_data, 0, journal->j_blocksize);
-		BUFFER_TRACE(bh, "marking dirty");
-		mark_buffer_dirty(bh);
 		BUFFER_TRACE(bh, "marking uptodate");
 		set_buffer_uptodate(bh);
+		BUFFER_TRACE(bh, "marking dirty");
+		mark_buffer_dirty(bh);

 		unlock_buffer(bh);
 		__brelse(bh);
 	}
