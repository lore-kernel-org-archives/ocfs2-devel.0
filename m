From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Apr 15 05:04:02 2004
Subject: [Ocfs2-devel] 
	Patches to fix the OCFS2 bug 54, which cause crash in the second
	mount under kernel 2.6.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E64@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	After digging into the JBD source code, I think I am able to fix
the OCFS2 bug 54, which cause crash in the second mount under kernel
2.6.

	Actually, it is a bug in Linux journal functions of kernel 2.6.
In routine journal_update_superblock(), one special case is dealt with
to skip actually writing the super block into the disk. 

	If(sb->s_start == 0 && journal->j_tail_sequence == 
	
journal->j_transaction_sequence) {
		goto out;
	}

	When a new journal is created, this condition is met and the
journal super block is not written into the disk.

	I give out 2 solutions. Both work fine by now. One is to break
the condition in routine journal_create() and write the journal super
block immediately. The other is to force updating the journal super
block in routine journal_destroy(), when the volume is unmounted.

	Please refer to the attachments.


-------------------------------------------------
--- linux-2.6.1-old/fs/jbd/journal.c	2004-04-14 10:15:24.000000000
+0800
+++ linux-2.6.1/fs/jbd/journal.c	2004-04-14 10:41:05.000000000
+0800
@@ -852,6 +852,7 @@
 	sb->s_blocksize	= htonl(journal->j_blocksize);
 	sb->s_maxlen	= htonl(journal->j_maxlen);
 	sb->s_first	= htonl(1);
+	sb->s_start	= sb->s_first;
 
 	journal->j_transaction_sequence = 1;


-------------------------------------------------
--- linux-2.6.1-old/fs/jbd/journal.c	2004-04-14 10:15:24.000000000
+0800
+++ linux-2.6.1/fs/jbd/journal.c	2004-04-14 11:27:23.269457592
+0800
@@ -1090,11 +1090,12 @@
 
 	/* We can now mark the journal as empty. */
 	journal->j_tail = 0;
-	journal->j_tail_sequence = ++journal->j_transaction_sequence;
+	++journal->j_transaction_sequence;
 	if (journal->j_sb_buffer) {
 		journal_update_superblock(journal, 1);
 		brelse(journal->j_sb_buffer);
 	}
+	journal->j_tail_sequence = journal->j_transaction_sequence;
 
 	if (journal->j_inode)
 		iput(journal->j_inode);


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-------------- next part --------------
A non-text attachment was scrubbed...
Name: journal-update-superblock-fix1.patch
Type: application/octet-stream
Size: 351 bytes
Desc: journal-update-superblock-fix1.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040415/bd780328/journal-update-superblock-fix1.obj
-------------- next part --------------
A non-text attachment was scrubbed...
Name: journal-update-superblock-fix2.patch
Type: application/octet-stream
Size: 562 bytes
Desc: journal-update-superblock-fix2.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040415/bd780328/journal-update-superblock-fix2.obj
