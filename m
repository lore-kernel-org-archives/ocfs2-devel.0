From: Sonic Zhang <sonic.zhang@intel.com>
Date: Thu Mar 18 20:52:02 2004
Subject: [Ocfs2-devel] 
	I regenerate the patch for bug 45 against kernel 2.6.4
Message-ID: <405A605D.4080504@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

See bellow.
Please check if it works.

---------------------------------------------------------------------------

--- linux-2.6.4a/fs/jbd/journal.c    2004-03-19 10:40:49.264613984 +0800
+++ linux-2.6.4/fs/jbd/journal.c    2004-03-19 10:41:12.091143824 +0800
@@ -832,10 +832,10 @@
         bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
         lock_buffer(bh);
         memset (bh->b_data, 0, journal->j_blocksize);
-        BUFFER_TRACE(bh, "marking dirty");
-        mark_buffer_dirty(bh);
         BUFFER_TRACE(bh, "marking uptodate");
         set_buffer_uptodate(bh);
+        BUFFER_TRACE(bh, "marking dirty");
+        mark_buffer_dirty(bh);
         unlock_buffer(bh);
         __brelse(bh);
     }
