From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Apr 16 02:41:19 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause crash
	in the second mount under kernel 2.6.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E68@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	I attach a new patch for ocfs based on your suggestion to walk around the bug in JBD before it is fixed in kernel.


------------------------------------------------
--- journal.c.old	2004-04-15 09:21:00.000000000 +0800
+++ journal.c	2004-04-15 09:23:57.000000000 +0800
@@ -1085,6 +1085,9 @@
 	int status = 0;
 	ocfs_super * osb = NULL;
 	struct super_block *sb = NULL;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	struct buffer_head *bh;
+#endif
 
 	LOG_ENTRY();
 
@@ -1116,6 +1119,12 @@
 		goto done;
 	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	bh = journal->k_journal->j_sb_buffer;
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+#endif
+
 	journal->state = OCFS_JOURNAL_LOADED;
 	journal->bmaps = 0;




*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
Sent: 2004��4��16�� 5:50
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause crash in the second mount under kernel 2.6.

On Thu, Apr 15, 2004 at 05:33:23PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	After digging into the JBD source code, I think I am able to fix
> the OCFS2 bug 54, which cause crash in the second mount under kernel
> 2.6.
> 
> 	Actually, it is a bug in Linux journal functions of kernel 2.6.
> In routine journal_update_superblock(), one special case is dealt with
> to skip actually writing the super block into the disk. 
> 
> 	If(sb->s_start == 0 && journal->j_tail_sequence == 
> 	
> journal->j_transaction_sequence) {
> 		goto out;
> 	}
> 
> 	When a new journal is created, this condition is met and the
> journal super block is not written into the disk.
*ouch*. Can you try force writing journal->j_sb_buffer in
ocfs_journal_create or something? Here's what I'm thinking:

@@ -1086,6 +1094,7 @@ int ocfs_journal_create(ocfs_journal *jo
 	int status = 0;
 	ocfs_super * osb = NULL;
 	struct super_block *sb = NULL;
+	struct buffer_head *bh;
 
 	LOG_ENTRY();
 
@@ -1117,6 +1126,11 @@ int ocfs_journal_create(ocfs_journal *jo
 		goto done;
 	}
 
+	/* work around a bug in journal_update_superblock() */
+	bh = journal->k_journal->j_sb_buffer;
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+
 	journal->state = OCFS_JOURNAL_LOADED;
 	journal->bmaps = 0;
 
Of course, we should fix the real problem in the kernel.

> 	I give out 2 solutions. Both work fine by now. One is to break
> the condition in routine journal_create() and write the journal super
> block immediately. The other is to force updating the journal super
> block in routine journal_destroy(), when the volume is unmounted.
I'm not sure about these though...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-journal-create-superblock.patch
Type: application/octet-stream
Size: 562 bytes
Desc: ocfs2-journal-create-superblock.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040416/169ca8ea/ocfs2-journal-create-superblock.obj
