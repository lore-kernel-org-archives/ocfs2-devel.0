From: Sonic Zhang <sonic.zhang@intel.com>
Date: Thu Mar 18 21:15:39 2004
Subject: [Ocfs2-devel] 
 mark_buffer_dirty() reports buffer_head is not uptodate in JBDroutine
 journal_create() in kernel 2.6.
Message-ID: <405A65E8.3010904@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Stephen,

I found a bug in JBD routine journal_create() in kernel 2.6, when I debug
the OCFS v2 driver.  mark_buffer_dirty() reports buffer_head is not
uptodate. See following bug description.

-------------------------------------------------------

OS: Linux Kernel 2.6.1
Plarform: IA32

Steps:
1. Build the ocfs v2 driver under kernel 2.6.
2. insert ocfs2.ko into kernel 2.6.
3. mkfs.ocfs2 -F -b 4 -l testocfs -m /mnt/ocfs2 /dev/hdb2
4. mount -t ocfs2 /dev/hdb2 /mnt/ocfs2

Results:
buffer layer error at fs/buffer.c:1266
Call Trace:
[<>] mark_buffer_dirty
[<>] journal_create
[<>] ocfs_journal_create
[<>] ocfs_check_volume
[<>] ocfs_mount_volume
......

-------------------------------------------------------

I think I found the root cause of the bug reported in mark_buffer_dirty().

It is caused in the Linux journaling routine(JBD) journal_create(). In 
kernel 2.6.x, buffer_head state BH_Uptodate is checked in mark_buffer_dirty(), 
while kernel 2.4.x doesn't do. If this state doesn't exist in the buffer_head, 
buffer error information is reported. But, in routine journal_create(), the state
BH_Uptodate is set after the call to mark_buffer_dirty(). This works well in
kernel 2.4.x, but fails in kernel 2.6.x.

I attach a patch to fix this bug in kernel 2.6.x. Please check if it works well in
kernel 2.6.x.

-------------------------------------------------------

--- linux-2.6.4a/fs/jbd/journal.c	2004-03-19 10:40:49.264613984 +0800
+++ linux-2.6.4/fs/jbd/journal.c	2004-03-19 10:41:12.091143824 +0800
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



--Sonic Zhang
